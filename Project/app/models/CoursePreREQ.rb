require 'data_mapper'

class CoursePreREQ
    include DataMapper::Resource
    property :id, Serial
    property :courseID, Integer
    property :preReqID, Integer
end




