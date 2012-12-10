require 'java'
require 'rubygems'
require 'pry'

#Dir.glob('mahout/lib/*.jar').each { |d| require d }

Dir["jars/\*.jar"].each { |jar| require jar }
Dir["jars/mahout/\*.jar"].each { |jar| require jar }
Dir["jars/mahout/hadoop/\*.jar"].each { |jar| require jar }


#require 'mahout/mahout-core-0.5.jar'
#require 'mahout/mahout-utils-0.5.jar'
#require 'mahout/mahout-math-0.5.jar'

MahoutFile = org.apache.mahout.cf.taste.impl.model.file
model = MahoutFile.FileDataModel.new(java.io.File.new("/home/prashant/jruby/jruby_app/user_preferences.csv"))

MahoutSimilarity = org.apache.mahout.cf.taste.impl.similarity
similarity = MahoutSimilarity.TanimotoCoefficientSimilarity.new(model)

MahoutNeighborhood = org.apache.mahout.cf.taste.impl.neighborhood
neighborhood = MahoutNeighborhood.NearestNUserNeighborhood.new(5, similarity, model)

MahoutRecommender = org.apache.mahout.cf.taste.impl.recommender
recommender = MahoutRecommender.GenericBooleanPrefUserBasedRecommender.new(model, neighborhood, similarity)
recommendations = recommender.recommend(4, 10)
recommendations.each do |a|
	puts a
end
#r = recommend(3, 5, neighborhood, model, similarity)
