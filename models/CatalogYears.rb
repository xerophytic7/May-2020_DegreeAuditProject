require 'data_mapper'



class CatalogYears
  include DataMapper::Resource

  property :CatalogYear, String, :key=> true

end