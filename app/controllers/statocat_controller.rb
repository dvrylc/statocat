class StatocatController < ApplicationController

    # Get GitHub secrets fron environment
    GITHUB_ID = Rails.application.secrets.GITHUB_ID
    GITHUB_SECRET = Rails.application.secrets.GITHUB_SECRET
    AUTH = "?client_id=" + GITHUB_ID + "&client_secret=" + GITHUB_SECRET

    # Methods
    def root
    end

    def user

        # Get username from request hash
        username = params[:username]

        # Get user object from GitHub
        user_profile_raw = HTTParty.get("https://api.github.com/users/" + username + AUTH)
        @user_profile = JSON.parse(user_profile_raw.body)

    end

    def user_repo_languages

        # Get username from request hash
        username = params[:username]

        # Get user's repos
        user_repos_raw = HTTParty.get("https://api.github.com/users/" + username + "/repos" + AUTH)
        user_repos = JSON.parse(user_repos_raw.body)

        @user_repo_languages = { }
        user_repos.each do |repo| 

            # We don't want stats for forks
            if repo["fork"] == false && repo["language"] != nil

                # Add/append the language to the @user_repo_languages hash
                language = repo["language"]
                if @user_repo_languages.has_key?(language)
                    @user_repo_languages[language] = @user_repo_languages[language] + 1
                else 
                     @user_repo_languages[language] = 1
                end

            end

        end

        render json: @user_repo_languages

    end

    def user_code_languages 

        # Get username from request hash
        username = params[:username]

        # Get user's repos
        user_repos_raw = HTTParty.get("https://api.github.com/users/" + username + "/repos" + AUTH)
        user_repos = JSON.parse(user_repos_raw.body)

        # For each repo
        @user_code_languages = { }
        user_repos.each do |repo| 

            # We don't want stats for forks
            if repo["fork"] == false 

                # Get this repo's languages
                repo_languages_raw = HTTParty.get(repo["languages_url"] + AUTH)
                repo_languages = JSON.parse(repo_languages_raw.body)

                # If valid languages exist, add/append to the @user_code_languages hash
                if !repo_languages.empty?
                    repo_languages.each do |lang, size| 
                        if @user_code_languages.has_key?(lang)
                            @user_code_languages[lang] = @user_code_languages[lang] + size
                        else
                            @user_code_languages[lang] = size
                        end
                    end
                end

            end

        end

        render json: @user_code_languages

    end

end
