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

        # If user profile in database is older than 2 mins
        if ((Time.now - @user.updated_at) / 1.minute).round > 2
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

        # Look for user's statistic object
        @statistic = @user.user_statistic

        # If user's statistic object cannot be found
        if @statistic == nil

            # Create a new statistic object, bind it to the user
            @statistic = UserStatistic.new
            @user.user_statistic = @statistic

            # Set statistic object's params and save
            user_set_statistics(@statistic)
            @statistic.save

        # If statistic object in database is older than 2 mins
        elsif ((Time.now - @statistic.updated_at) / 1.minute).round > -1

            # Update user's statistic object and save
            user_set_statistics(@statistic)
            @statistic.updated_at = Time.now
            @statistic.save

        end

        # Render json of user's statistic object
        render json: @statistic.to_json

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

    def user_set_statistics(statistic)

        # Get username from params hash
        username = params[:username]

        # Create temporary variables
        temp_repo_lang = { }
        temp_code_lang = { }
        temp_total_stars = 0
        temp_average_stars = 0.00
        temp_total_forks = 0
        temp_average_forks = 0.00
        temp_total_characters = 0
        temp_average_characters = 0.00
        temp_total_watchers = 0
        temp_average_watchers = 0.00

        # Call GitHub API, parse response into the repos_raw object
        repos_raw = JSON.parse(HTTParty.get("https://api.github.com/users/" + username + "/repos" + AUTH).body)

        # total_repos
        statistic.total_repos = repos_raw.size

        # For each repo
        repos_raw.each do |repo| 

            # We don't want stats for forks
            if repo["fork"] == false

                # repo_lang
                if repo["language"] != nil
                    # Add/append the language to the temp_repo_lang hash
                    lang = repo["language"]
                    if temp_repo_lang.has_key?(lang)
                        temp_repo_lang[lang] = temp_repo_lang[lang] + 1
                    else 
                         temp_repo_lang[lang] = 1
                    end
                end
                statistic.repo_lang = temp_repo_lang.to_json

                # code_lang
                # Get this repo's languages, parse response into repo_languages_raw hash
                repo_languages_raw = JSON.parse(HTTParty.get(repo["languages_url"] + AUTH).body)
                # If valid languages exist, add/append to the temp_code_lang and temp_total_characters hash
                if !repo_languages_raw.empty?
                    repo_languages_raw.each do |lang, size| 
                        if temp_code_lang.has_key?(lang)
                            temp_code_lang[lang] = temp_code_lang[lang] + size
                        else
                            temp_code_lang[lang] = size
                        end
                        temp_total_characters += size
                    end
                end
                statistic.code_lang = temp_code_lang.to_json
                statistic.total_characters = temp_total_characters

                # total_stars
                temp_total_stars += repo["stargazers_count"]
                statistic.total_stars = temp_total_stars

                # total_forks
                temp_total_forks += repo["forks_count"]
                statistic.total_forks = temp_total_forks

                # total_watchers
                temp_total_watchers += repo["watchers_count"]
                statistic.total_watchers = temp_total_watchers

            end

        end

        # average_stars
        temp_average_stars = temp_total_stars.to_f / repos_raw.size
        statistic.average_stars = temp_average_stars

        # average_forks
        temp_average_forks = temp_total_forks.to_f / repos_raw.size
        statistic.average_forks = temp_average_forks

        # average_watchers
        temp_average_watchers = temp_total_watchers.to_f / repos_raw.size
        statistic.average_watchers = temp_average_watchers

        # average characters
        temp_average_characters = temp_total_characters.to_f / repos_raw.size
        statistic.average_characters = temp_average_characters

    end

    private :find_user, :user_set_profile, :user_set_statistics

end
