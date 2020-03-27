require "sinatra"
require 'sinatra/flash'
require File.expand_path("../Authentication/api_authentication.rb", __FILE__)
require File.expand_path("../models/ALLCourses.rb", __FILE__)
require File.expand_path("../models/Categories.rb", __FILE__)
require File.expand_path("../models/CourseALT.rb", __FILE__)
require File.expand_path("../models/CourseCategories.rb", __FILE__)
require File.expand_path("../models/CoursePreREQ.rb", __FILE__)
require File.expand_path("../models/StudentCourses.rb", __FILE__)


if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/db/app.db")
end
DataMapper.finalize

User.auto_upgrade!
StudentCourses.auto_upgrade!
CoursePreREQ.auto_upgrade!
CourseCategories.auto_upgrade!
CourseALT.auto_upgrade!
Categories.auto_upgrade!
AllCourses.auto_upgrade!



#If there is no admin account, make one.
if User.all(admin: true).count == 0
  u = User.new
  u.email = "admin@admin.com"
  u.password = "admin"
  u.admin = true
  u.save
end
m = StudentCourses.new
m.save

d = CoursePreREQ.new
d.save

s = CourseCategories.new
s.save

a = CourseALT.new
a.save

h = Categories.new
h.save

r = AllCourses.new
r.save

print User.count
print StudentCourses.count
print CoursePreREQ.count
print CourseCategories.count
print CourseALT.count
print Categories.count
print AllCourses.count

get "/" do
	return "#{AllCourses.count}"
end