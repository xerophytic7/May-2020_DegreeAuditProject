require 'data_mapper'

class CoursePreREQ
  include DataMapper::Resource
  
  # property :id, Serial
  property :CourseID, Integer, :key=> true
  property :PreReqID, Integer, :key=> true
end


