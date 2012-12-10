class Ability
	include CanCan::Ability
  def initialize(user)
		user ||= User.new # guest user
		if user.is_a? Admin
	    can :manage, :all
		else
			can [:read], :all
			can :manage, UserPreference do |up|
				up.user == user
			end
			can :create, UserPreference
		end
 end
end
