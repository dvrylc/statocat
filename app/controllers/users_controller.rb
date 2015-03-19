class UsersController < ApplicationController
    before_action :find_user

    # Get GitHub secrets fron environment
    GITHUB_ID = Rails.application.secrets.GITHUB_ID
    GITHUB_SECRET = Rails.application.secrets.GITHUB_SECRET
    AUTH = "?client_id=" + GITHUB_ID + "&client_secret=" + GITHUB_SECRET

    # Methods
    def root
    end

    # User profile
    def profile

        # If user profile in database is older than 10 mins
        if ((Time.now - @user.updated_at) / 1.minute).round > 30
            puts Time.now
            # Update user profile parameters, save
            user_set_profile(@user)
            @user.updated_at = Time.now
            @user.save

        end

    end

    # User statistics
    def statistics

        # Get username from params hash
        username = params[:username]

        # Look for user's language object
        @language = @user.language

        # If user's language object cannot be found
        if @language == nil

            # Create a new language object, bind it to the user
            @language = Language.new
            @user.language = @language

            # Set language object's params and save
            user_set_statistics(@language)
            @language.save

        # If language object in database is older than 10 mins
        elsif ((Time.now - @language.updated_at) / 1.minute).round > 30

            # Update user's language object and save
            user_set_statistics(@language)
            @language.updated_at = Time.now
            @language.save

        end

        # Render json of user's repo languages
        render json: @language.to_json

    end

    def find_user

        # Get username from params hash
        username = params[:username]

        @user = User.find_by_username(username)

        if @user == nil
            # Create new user profile
            @user = User.new
            # Set user profile parameters, save
            user_set_profile(@user)
            @user.save
        end

    end

    def user_set_profile(user)

        # Get username from params hash
        username = params[:username]

        user_raw = JSON.parse(HTTParty.get("https://api.github.com/users/" + username + AUTH).body)

        user.avatar = user_raw["avatar_url"]
        user.name = user_raw["name"]
        user.username = user_raw["login"].downcase
        user.followers = user_raw["followers"]
        user.following = user_raw["following"]
        user.join_date = user_raw["created_at"]
        user.public_repos = user_raw["public_repos"]
        user.public_gists = user_raw["public_gists"]

    end

    def user_set_statistics(language)

        # Get username from params hash
        username = params[:username]

        # Create new temp_repo hash
        temp_repo = { }
        temp_code = { }

        # Call GitHub API, parse response into the repos_raw object
        repos_raw = JSON.parse(HTTParty.get("https://api.github.com/users/" + username + "/repos" + AUTH).body)

        repos_raw.each do |repo| 

            # We don't want stats for forks
            if repo["fork"] == false && repo["language"] != nil

                # Add/append the language to the temp_repo hash
                lang = repo["language"]
                if temp_repo.has_key?(lang)
                    temp_repo[lang] = temp_repo[lang] + 1
                else 
                     temp_repo[lang] = 1
                end

                # Get this repo's languages, parse response into repo_languages_raw hash
                repo_languages_raw = JSON.parse(HTTParty.get(repo["languages_url"] + AUTH).body)

                # If valid languages exist, add/append to the temp_code hash
                if !repo_languages_raw.empty?
                    repo_languages_raw.each do |lang, size| 
                        if temp_code.has_key?(lang)
                            temp_code[lang] = temp_code[lang] + size
                        else
                            temp_code[lang] = size
                        end
                    end
                end

            end

        end

        language.repo = temp_repo.to_json
        language.code = temp_code.to_json

    end

    private :find_user, :user_set_profile, :user_set_statistics

end
