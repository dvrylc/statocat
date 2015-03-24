class UsersController < ApplicationController
    before_action :find_user, except: [:root, :invalid, :faq]
    before_action :set_no_nav, only: [:root, :invalid]

    # Get GitHub secrets fron environment
    GITHUB_ID = Rails.application.secrets.GITHUB_ID
    GITHUB_SECRET = Rails.application.secrets.GITHUB_SECRET
    AUTH = "?client_id=" + GITHUB_ID + "&client_secret=" + GITHUB_SECRET

    # Static methods
    def root
    end

    def invalid
    end

    def faq
    end

    # Logic
    # User profile
    def profile

        # If user profile in database is older than 1 hour
        if ((Time.now - @user.updated_at) / 1.hour).round > -1
            puts Time.now
            # Update user profile parameters, save
            user_set_profile(@user)
            @user.updated_at = Time.now
            @user.save

        end

        respond_to do |format|
        	format.html {}
        	format.json { render json: @user, except: [:id, :created_at] }
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

        # If statistic object in database is older than 1 hour
        elsif ((Time.now - @statistic.updated_at) / 1.hour).round > -1

            # Update user's statistic object and save
            user_set_statistics(@statistic)
            @statistic.updated_at = Time.now
            @statistic.save

        end

        # Render json of user's statistic object
        render json: @statistic, except: [:id, :user_id, :created_at]

    end

    def find_user

        # Get username from params hash
        username = params[:username]

        @user = User.where('lower(username) = ?', username.downcase).first

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

        if user_raw["login"] != nil

            user.avatar = user_raw["avatar_url"]
            user.name = user_raw["name"]
            user.username = user_raw["login"]
            user.followers = user_raw["followers"]
            user.following = user_raw["following"]
            user.join_date = user_raw["created_at"]
            user.public_repos = user_raw["public_repos"]
            user.public_gists = user_raw["public_gists"]

        else 
            redirect_to invalid_path
        end

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
        temp_total_issues = 0
        temp_average_issues = 0.00
        temp_total_pages = 0
        temp_percentage_pages = 0.00

        # Call GitHub API, parse response into the repos_raw object
        repos_raw = JSON.parse(HTTParty.get("https://api.github.com/users/" + username + "/repos" + AUTH + "&per_page=100").body)

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

                # total_issues
                temp_total_issues += repo["open_issues_count"]
                statistic.total_issues = temp_total_issues

                # total_pages
                if repo["has_pages"] == true 
                    temp_total_pages += 1
                end
                statistic.total_pages = temp_total_pages

            end

        end

        # average_stars
        temp_average_stars = temp_total_stars.to_f / repos_raw.size
        statistic.average_stars = temp_average_stars.round(2)

        # average_forks
        temp_average_forks = temp_total_forks.to_f / repos_raw.size
        statistic.average_forks = temp_average_forks.round(2)

        # average_issues
        temp_average_issues = temp_total_issues.to_f / repos_raw.size
        statistic.average_issues = temp_average_issues.round(2)

        # percentage_pages
        temp_percentage_pages = temp_total_pages.to_f / repos_raw.size 
        statistic.percentage_pages = temp_percentage_pages.round(2)

        # average characters
        temp_average_characters = temp_total_characters.to_f / repos_raw.size
        statistic.average_characters = temp_average_characters.round(2)

    end

    def set_no_nav 
        @no_nav = true
    end

    private :find_user, :user_set_profile, :user_set_statistics, :set_no_nav

end
