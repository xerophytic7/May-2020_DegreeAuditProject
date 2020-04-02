require 'data_mapper'


class CourseCategories
  include DataMapper::Resource
  
  # property :id, Serial
  property :CourseID, Integer, :key=> true
  property :CategoryID, Integer, :key=> true
end

