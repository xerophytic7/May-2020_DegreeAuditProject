require 'data_mapper'

if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/student')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/student.db")
end

class User
  include DataMapper::Resource
  property :UserID, Integer
  property :first_Name, String
  property :last_Name, String
  property :email, String
  property :password, String
  property :GPA, Float
  property :catalog_Year, Integer
  property :classification, String
  property :hours, Integer
  property :admin, Boolean, :default => false

  def login(password)
    return self.password == password
  end


end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
User.auto_upgrade!