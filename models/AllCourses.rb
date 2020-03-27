require 'data_mapper'

if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/AllCourses')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/AllCourses.db")
end

class AllCourses
  include DataMapper::Resource
  property :CourseID, Serial
  property :CourseDept, String
  property :CourseNum, Integer
  property :Name, String
  property :Institution, String
end

DataMapper.finalize
AllCourses.auto_upgrade!
