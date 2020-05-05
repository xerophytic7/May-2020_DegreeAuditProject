require 'data_mapper'

class AdvisementSession
  include DataMapper::Resource

  property :id, Serial
  property :AdminID, Integer 
  property :StudentID, Integer 
  property :created_at, Date
  property :Notes, Text

end 