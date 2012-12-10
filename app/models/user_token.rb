class UserToken < ActiveRecord::Base
	attr_accessible :uid, :provider, :token, :token_secret, :user_id, :approved
  belongs_to :user
end
