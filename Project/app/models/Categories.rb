require 'data_mapper'

if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/Categories')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/Categories.db")
end

class Categories
  property :CategoryID, primary_key
  property :CategoryNum, Integer
  property :CategoryName, String
  property :CatalogYear, Integer
  property :ReqHours, Integer
end

DataMapper.finalize
Categories.auto_upgrade!

