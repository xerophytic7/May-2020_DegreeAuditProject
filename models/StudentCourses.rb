require 'data_mapper'


class StudentCourses
  include DataMapper::Resource

  #property :id, Serial
  property :UserID, Integer, :key=> true
  property :CourseID, Integer
  property :SemesterID, Integer
  property :Grade, String
  property :Approved, Boolean, :default => true
  property :Notes, String

end






