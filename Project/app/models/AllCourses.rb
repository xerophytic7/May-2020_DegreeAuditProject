require 'data_mapper'

if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/AllCourses.db")
end

class AllCourses
  include DataMapper::Resource
  property :CourseID, Integer
  property :CourseDept, String
  property :CourseNum, Integer
  property :Name, String
  property :Category, String
  property :CatalogYear, Integer
end

DataMapper.finalize
AllCourses.auto_upgrade!
