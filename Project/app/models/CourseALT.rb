require 'data_mapper'

if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/CourseALT')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/CourseALT.db")
end

class CourseALT
  property :CourseID, Integer
  property :AltID, Integer
end

DataMapper.finalize
CourseALT.auto_upgrade!

