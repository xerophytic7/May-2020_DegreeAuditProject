require 'data_mapper'

class CourseCategories
    include DataMapper::Resource
    property :id, Serial
    property :categoryID, Integer
    property :categoryNum, Integer
    property :categoryName, String
    property :regHours, Integer
end



