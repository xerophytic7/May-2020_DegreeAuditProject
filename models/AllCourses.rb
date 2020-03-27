require 'data_mapper'

class AllCourses
  include DataMapper::Resource
  
  property :CourseID, Serial
  property :CourseDept, String
  property :CourseNum, Integer
  property :Name, String
  property :Institution, String
end

