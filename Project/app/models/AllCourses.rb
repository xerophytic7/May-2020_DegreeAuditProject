require 'data_mapper'

class AllCourses
    include DataMapper::Resource
    property :id, Serial
    property :courseID, Integer
    property :courseDept, String
    property :courseNum, Integer
    property :name, String
    property :category, String
    property :catalogYear, Integer
end


