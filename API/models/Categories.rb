require 'data_mapper'

class Categories
  include DataMapper::Resource
  
  property :CategoryID, Serial
  property :CategoryNum, Integer
  property :CategoryName, String
  property :CatalogYear, Integer
  property :ReqHours, Integer
end


