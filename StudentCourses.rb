require 'data_mapper'

if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/StudentCourses.db")
end

class StudentCourses
  property :StudentID, Integer
  property :CourseID, Integer
  property :SemesterID, Integer
end

DataMapper.finalize
StudentCourses.auto_upgrade!







