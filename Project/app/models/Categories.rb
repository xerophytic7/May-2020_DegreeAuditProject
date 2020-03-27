require 'data_mapper'

class Categories
    include DataMapper::Resource
    property :id, Serial
    property :courseID, Integer
    property :preReqID, Integer
end



