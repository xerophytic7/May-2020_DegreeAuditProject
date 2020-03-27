require 'data_mapper'

class User
    include DataMapper::Resource
    property :id, Serial
    property :first_Name, String
    property :last_Name, String
    property :email, String
    property :password, String
    property :gpa, Float
    property :catalog_Year, Integer
    property :classification, String
    property :hours, Integer
    property :admin, Boolean, :default => false
    def login(password)
       return self.password == password
    end
end
