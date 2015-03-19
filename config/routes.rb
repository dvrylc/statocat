Rails.application.routes.draw do

    get "/u/:username", to: "statocat#user"
    get "/u/:username/repo-languages", to: "statocat#user_repo_languages"
    get "/u/:username/code-languages", to: "statocat#user_code_languages"

    root "statocat#root"

end
