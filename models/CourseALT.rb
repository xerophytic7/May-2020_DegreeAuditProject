require 'data_mapper'

class CourseALT
  include DataMapper::Resource

  property :id, Serial
  property :CourseID, Integer
  property :AltID, Integer
end


