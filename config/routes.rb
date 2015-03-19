Rails.application.routes.draw do

    get "/u/:username", to: "users#profile"
    get "/u/:username/statistics", to: "users#statistics"

    root "statocat#root"

end
