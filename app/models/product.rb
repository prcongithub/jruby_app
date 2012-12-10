require 'java'

Dir["jars/mahout/\*.jar"].each { |jar| require jar }
Dir["jars/mahout/hadoop/\*.jar"].each { |jar| require jar }
	
DataSourceExample = com.truespider.recommendation.DataSourceExample
ConnectionPoolDataSource = org.apache.mahout.cf.taste.impl.model.jdbc.ConnectionPoolDataSource
MySQLJDBCDataModel = org.apache.mahout.cf.taste.impl.model.jdbc.MySQLJDBCDataModel
NearestNUserNeighborhood = org.apache.mahout.cf.taste.impl.neighborhood.NearestNUserNeighborhood
GenericUserBasedRecommender = org.apache.mahout.cf.taste.impl.recommender.GenericUserBasedRecommender
LogLikelihoodSimilarity = org.apache.mahout.cf.taste.impl.similarity.LogLikelihoodSimilarity


class Product < ActiveRecord::Base
  attr_accessible :description, :name, :price, :category

	validates :name, :category, :price, :presence => true	
	  
  validates :name, :uniqueness => true	
	
  has_many :user_preferences, :dependent => :destroy
  
  has_many :photos, :as => :attachable, :class_name => "Image", :dependent => :destroy, :conditions => { :group_id => "photos" }
	has_one :logo, :as => :attachable, :class_name => "Image", :dependent => :destroy, :conditions => { :group_id => "logo" }


	@@dataSourceExample = DataSourceExample.new()
	@@dataSource = ConnectionPoolDataSource.new(@@dataSourceExample.bdSource)
	@@dataModel = MySQLJDBCDataModel.new(@@dataSource,"user_preferences","user_id","item_id","preference","created_at");
  
  def self.top_products(limit=4)
  	return Product.limit(limit)
  end
  
  def self.recommend_log(user)
 		similarity = LogLikelihoodSimilarity.new(@@dataModel);
		neighborhood = NearestNUserNeighborhood.new(5, similarity, @@dataModel);
		basedRecommender = GenericUserBasedRecommender.new(@@dataModel, neighborhood, similarity);
		recommend = basedRecommender.recommend(user.id, 10);
		products = []
		recommend.each do |ri|
			products.push Product.find(ri.item_id)
		end
		products
  end
  
  
  EuclideanDistanceSimilarity = org.apache.mahout.cf.taste.impl.similarity.EuclideanDistanceSimilarity
  GenericItemBasedRecommender = org.apache.mahout.cf.taste.impl.recommender.GenericItemBasedRecommender
  ItemSimilarity = org.apache.mahout.cf.taste.similarity.ItemSimilarity
  class RecommenderBuilder
    def self.buildRecommender(model)
      similarity = EuclideanDistanceSimilarity.new(model)
      return GenericItemBasedRecommender.new(model, similarity)
  	end
  end	
  
  def self.recommended(user,limit)	
  	user_id = (user.is_a? Fixnum) ? user : user.id
    recommender = RecommenderBuilder.buildRecommender(@@dataModel)
    recomendations = recommender.recommend(user_id,5)
    products = []
    recomendations.each do |recommendedItem|
    	prd = Product.find(recommendedItem.item_id)
      puts prd.name
			products.push prd
		end
		if products.empty?
			return top_products(limit)
		end
		return products[0..limit-1]
  end
  
  
  def rate(user,preference)
  	up = user.user_preferences.where(:item_id => self.id).first
  	if not up
  		user.user_preferences.push(UserPreference.new(:item_id => self.id, :preference => preference))
  		return user.save
  	else
  		up.preference = preference
  		return up.save
  	end
  end
end
