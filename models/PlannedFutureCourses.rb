require 'data_mapper'



class PlannedFutureCourse
  include DataMapper::Resource

 # property :id, Serial
  property :UserID, Integer, :key=> true
  property :CourseID, Integer, :key=> true
  property :Semester, String

end

