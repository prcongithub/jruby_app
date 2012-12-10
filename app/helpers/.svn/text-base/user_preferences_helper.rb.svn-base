module UserPreferencesHelper
	def get_item_options
		hash = {}
		Product.all.each{|x| hash[x.name] = x.id}
		return hash
	end
	
	def get_user_options
		hash = {}
		User.all.each{|x| hash[x.name] = x.id}
		return hash
	end
end
