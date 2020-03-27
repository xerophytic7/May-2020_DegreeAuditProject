require 'data_mapper'

class CourseALT
    include DataMapper::Resource
    property :id, Serial
    property :courseID, Integer
    property :alternativeID, Integer
end



