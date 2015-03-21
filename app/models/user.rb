class User < ActiveRecord::Base
    validates_uniqueness_of :username, :case_sensitive => false
    has_one :user_statistic
end
