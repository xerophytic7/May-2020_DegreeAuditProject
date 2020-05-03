require 'data_mapper'

class AdvisementSession
  include DataMapper::Resource

  property :id, Serial
  property :AdminID, Integer, :key=> true
  property :StudentID, Integer, :key=> true
  property :Date, Date
  property :Notes, Text

end 