require 'data_mapper'

class CourseALT
  include DataMapper::Resource

 # property :id, Serial
  property :CourseID, Integer, :key=> true
  property :AltID, Integer, :key=> true
end


