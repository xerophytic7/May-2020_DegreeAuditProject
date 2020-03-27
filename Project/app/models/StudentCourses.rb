require 'data_mapper'

class StudentCourses
    include DataMapper::Resource
    property :id, Serial
    property :studentID, Integer
    property :courseID, Integer
    property :semesterID, Integer
end








