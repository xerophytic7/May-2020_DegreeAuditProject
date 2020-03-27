require 'data_mapper'

if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/StudentCourses')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/StudentCourses.db")
end

class StudentCourses
  property :UserID, Integer
  property :CourseID, Integer
  property :SemesterID, Integer
  property :Grade, String
  property :Approved, Boolean, :default => true
  property :Notes, String

end

DataMapper.finalize
StudentCourses.auto_upgrade!







