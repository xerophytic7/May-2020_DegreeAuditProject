require 'data_mapper'


class CourseCategories
  include DataMapper::Resource
  
  property :id, Serial
  property :CourseID, Integer
  property :CategoryID, Integer
end

