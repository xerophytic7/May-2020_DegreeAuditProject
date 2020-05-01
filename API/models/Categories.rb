require 'data_mapper'

class Categories
  include DataMapper::Resource
  
  property :CategoryID, Serial
  property :MainCategory, String
  property :CategoryNum, String
  property :CategoryName, String
  property :CatalogYear, String
  property :ReqHours, Integer
  property :AdvHours, Integer
end
