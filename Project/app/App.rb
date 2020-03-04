require "sinatra"
require 'sinatra/flash'
require_relative "Authentication.rb"


#If there is no admin account, make one.
if User.all(admin: true).count == 0
  u = User.new
  u.email = "admin@admin.com"
  u.password = "admin"
  u.admin = true
  u.save
end


############## CREATE ################

# Create Users Given Email, FirstName, LastName, and Password.

# Create courses user has taken Given CourseID, SemesterID, and Grade

# Create a Category Given CategoryNum, Name, and ReqHours

# Assign a given CourseID and CategoryID to CourseCategories Table

# Create Course prerequisites Given a CourseID and PreReqID

# Create Course alternatives Given a CourseID and AltID

############## READ ##################

############## UPDATE ################

############## DESTROY ###############