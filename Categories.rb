require 'data_mapper'

if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/Categories.db")
end

class Categories
  property :CourseID, Integer
  property :PreReqID, Integer
end

DataMapper.finalize
Categories.auto_upgrade!

