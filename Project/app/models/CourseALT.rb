require 'data_mapper'

if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/StudentCourses.db")
end

class CourseALT
  property :CourseID, Integer
  property :AlternativeID, Integer
end

DataMapper.finalize
CourseALT.auto_upgrade!

