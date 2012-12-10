class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable,# :confirmable,
  			 :lockable, :timeoutable, :omniauthable


	attr_accessor :login,:info, :credentials, :extra
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :type, :phone
  attr_accessible :provider, :uid, :name, :info, :credentials, :extra, :user_tokens_attributes
  
  has_many :user_tokens, :dependent => :destroy
  has_many :user_preferences, :dependent => :destroy
  
  validates :first_name, :last_name, :presence => true
  
  accepts_nested_attributes_for :user_tokens
  
  def name
  	return [self.first_name,self.last_name].compact.join(" ") rescue "-"
  end
  
  def name=(name)
  	self.first_name = name.split(" ")[0] rescue "-"
  	self.last_name  = name.split(" ")[1] rescue "-"
  end
  
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
  	email = auth.info.email
		user = User.readonly(false).joins(:user_tokens).where("user_tokens.provider" => auth.provider, "user_tokens.uid" => auth.uid).first
		if not user
			user = User.readonly(false).where(:email => email).first
		end
		if signed_in_resource and not user
			user = signed_in_resource
		end
		if not user
			Rails.logger.info "******************* User #{signed_in_resource} ********************************"
			fname = auth.extra.raw_info.name.split(" ")[0] rescue '-'
			lname = auth.extra.raw_info.name.split(" ")[1] rescue '-'
		  user = User.create(
		                     :first_name => fname,
		  									 :last_name => lname,
	                       :email => auth.info.email,
	                       :password => Devise.friendly_token[0,20]
	                       )
		else
			user.apply_omniauth(auth)
		end
		user
	end
	
	def apply_omniauth(omniauth)
		self.provider = omniauth.provider
    self.uid = omniauth.uid
    
    case omniauth['provider']
			when 'facebook'
				self.apply_facebook(omniauth)
		end
		token = user_tokens.where(:provider => omniauth['provider']).first
		if not token
			user_tokens.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :token =>(omniauth['credentials']['token'] rescue nil))
		end
		self.save
	end
	
	def facebook
		@fb_user ||= FbGraph::User.me(self.user_tokens.find_by_provider('facebook').token)  rescue nil
	end
	
	def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  
  def self.fill_data
  	require 'csv'
  	index = 1;
  	CSV.open("#{Rails.root}/u.csv","r") do |r|
  		puts "#{index} #{r[0]} #{r[1]} #{r[2]}"
  		u = User.new
  		u.first_name = "User"
  		u.last_name = "#{index}"
  		u.email = "prashant+#{index}@truespider.com"
  		u.password = "prashant"
  		u.save
  		
  		p = Product.new
  		p.name = "Product #{index}"
  		p.price = rand(100000)
  		p.description = "Product #{index}"
  		p.save
  		index = index + 1
  	end	
  	
  end
  
  def self.fill_prefs
  	require 'csv'
  	index = 1
  	CSV.open("#{Rails.root}/u.csv","r") do |r|
  		if index > 1500 and index <= 5200
				user = User.find(r[0])
				item = Product.find(r[1])
				user_preference = UserPreference.new
				user_preference.user_id = user.id
				user_preference.item_id = item.id
				user_preference.preference = r[2]
				user_preference.save!
			end
			index = index + 1
		end
  end	
  
  protected
  def apply_facebook(omniauth)
		if (extra = omniauth['extra']['user_hash'] rescue false)
		  self.email = (extra['email'] rescue '')
		end
	end
end
