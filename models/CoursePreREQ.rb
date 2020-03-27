require 'data_mapper'

class CoursePreREQ
  include DataMapper::Resource
  
  property :id, Serial
  property :CourseID, Integer
  property :PreReqID, Integer
end


