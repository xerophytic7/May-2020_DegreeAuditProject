require 'data_mapper'

if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/CourseCategories.db")
end

class CourseCategories
  property :CategoryID, Integer
  property :CategoryNum, Integer
  property :CategoryName, String
  property :RegHours, Integer
end

DataMapper.finalize
CourseCategories.auto_upgrade!

