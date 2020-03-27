require 'data_mapper'

class User
  include DataMapper::Resource

  property :id, Serial
  property :Email, String
  property :FirstName, String
  property :LastName, String
  property :Password, String
  property :GPA, Float
  property :CatalogYear, Integer
  property :Classification, String
  property :Hours, Integer
  property :admin, Boolean, :default => false
  property :AdvancedHours, Integer
  property :Advanced_CS_Hours, Integer

  def login(password)
    return self.Password == password
  end


end
