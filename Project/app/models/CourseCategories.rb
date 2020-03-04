require 'data_mapper'

if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/CourseCategories')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/CourseCategories.db")
end

class CourseCategories
  property :CourseID, Integer
  property :CategoryID, Integer
end

DataMapper.finalize
CourseCategories.auto_upgrade!

