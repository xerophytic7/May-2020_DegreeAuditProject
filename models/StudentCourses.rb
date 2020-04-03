require 'data_mapper'


class StudentCourse
  include DataMapper::Resource

  #property :id, Serial
  property :UserID, Integer, :key=> true
  property :CourseID, Integer
  property :Semester, String
  property :Grade, String
  property :Approved, Boolean, :default => true
  property :Notes, String

  #belongs_to :User
end






