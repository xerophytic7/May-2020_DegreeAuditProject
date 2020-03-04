require 'data_mapper'

if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/PlannedFutureCourses')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/PlannedFutureCourses.db")
end

class PlannedFutureCourses
  property :UserID, Integer
  property :CourseID, Integer
  property :SemesterID, Integer
end

DataMapper.finalize
PlannedFutureCourses.auto_upgrade!

