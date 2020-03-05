require "sinatra"
require 'sinatra/flash'
require_relative "Authentication.rb"


#If there is no admin account, make one.
if User.all(admin: true).count == 0
  u = User.new
  u.UserID = 01234567
  u.Email = "admin@admin.com"
  u.Password = "admin"
  u.IsAdmin = true
  u.save

  print u.UserID
end


############## CREATE ################

# Create Users Given Email, FirstName, LastName, and Password.

# Create courses user has taken Given CourseID, SemesterID, and Grade

# Create entries to PlannedFutureCourses given JSON string of courses, 
# CourseID and SemesterID. 

# Create a Category Given CategoryNum, Name, and ReqHours

# Assign a given CourseID and CategoryID to CourseCategories Table

# Create Course prerequisites Given a CourseID and PreReqID

# Create Course alternatives Given a CourseID and AltID

# Create new degree plan (Mainly add to Categories Table: CategoryNum, 
# CategoryName, CatalogYear, and ReqHours. Then matching the CatagoryID
# with a CourseID and adding that to CourseCategories table.)



############## READ ##################

# Read current users FirstName, LastName, Email, GPA, CatalogYear, 
# Classification, Hours, AdvancedHours, & Advanced_CS_Hours from User Table

# Read current users courses from StudentCourses table.
# Maybe calculate user GPA, Classification, Hours, AdvancedHours,
# and Advanced_CS_Hours while we're at it.

# Read from PlannedFutureCourses table given a semester

# Read ALL PlannedFutureCourses 
# (Return Summer I, II, and Fall if in spring semester. 
# Return Summer II, and Fall if in Summer I semester. 
# Return Fall if in Summer II semester.
# Return Spring if in Fall semester.)

# Read all courses from AllCourses Table

# Read course pre requisites given a CourseID

# Read 



############## UPDATE ################



############## DESTROY ###############