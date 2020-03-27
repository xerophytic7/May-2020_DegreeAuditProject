require 'data_mapper'



class PlannedFutureCourses
  include DataMapper::Resource

  property :id, Serial
  property :UserID, Integer
  property :CourseID, Integer
  property :SemesterID, Integer
end

