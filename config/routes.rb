Rails.application.routes.draw do

    get "/u/:username", to: "users#profile"
    get "/u/:username/statistics/", to: "users#statistics"

    get "/faq", to: "users#faq", as: :faq
    get "/invalid", to: "users#invalid", as: :invalid

    root "users#root"

end
