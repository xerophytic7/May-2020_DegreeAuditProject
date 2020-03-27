require 'data_mapper'

if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/CoursePreREQ')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/CoursePreREQ.db")
end

class CoursePreREQ
  property :CourseID, Integer
  property :PreReqID, Integer
end

DataMapper.finalize
CoursePreREQ.auto_upgrade!



