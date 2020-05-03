require 'data_mapper'



class PlannedFutureCourses
  include DataMapper::Resource

  property :AdvisementID, Integer, :key=> true
  property :UserID, Integer, :key=> true
  property :CourseID, Integer, :key=> true
  property :Semester, String

end

