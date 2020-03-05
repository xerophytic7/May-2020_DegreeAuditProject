require 'data_mapper'

if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/student')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/student.db")
end

class User
  include DataMapper::Resource
  property :UserID, primary_key
  property :Email, String
  property :FirstName, String
  property :LastName, String
  property :Password, String
  property :GPA, Float
  property :CatalogYear, Integer
  property :Classification, String
  property :Hours, Integer
  property :IsAdmin, Boolean, :default => false
  property :AdvancedHours, Integer
  property :Advanced_CS_Hours, Integer

  def login(password)
    return self.password == password
  end


end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
User.auto_upgrade!