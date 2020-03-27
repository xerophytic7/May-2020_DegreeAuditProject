require "sinatra"
#require "sinatra/namespace"
require "json"
#require 'fog'
require 'csv'
#require 'sinatra-flash'
require_relative "api_authentication.rb"


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


#adding some random users
if User.count < 40

  i = 1
  last = 51

  while i < last do
    u = User.new
    u.Email = "email#{i}@email.com"
    u.FirstName = "user#{i}"
    u.Password = "pw#{i}"
    u.save
    i += 1

    print u.UserID
    print u.Email
    print u.FirstName
    print u.Password

  end


end


############## CREATE ################


#test get
get '/test'do

  return "hello"

end

# Create Users Given Email, FirstName, LastName, Password, and isAdmin (true/false).


# Create entry to StudentCourses using current UserID
# (Depending on params given)


# Create entry to StudentCourses given UserID
# (Depending on params given)


# Create entries to PlannedFutureCourses given JSON list of courses, 
# list of courses should have CourseID and SemesterID. 


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


# Given an email (or student ID if we add that), Read a users FirstName, 
# LastName, Email, GPA, CatalogYear, Classification, Hours, AdvancedHours,
# & Advanced_CS_Hours from User Table
# Also read their taken courses, their planned future courses


# Read current users courses from StudentCourses table.
# Maybe calculate user GPA, Classification, Hours, AdvancedHours,
# and Advanced_CS_Hours while we're at it.


# Read a students PlannedFutureCourses given an email and semester(s)


# Read from PlannedFutureCourses table given a semester  


# Read ALL PlannedFutureCourses 
# (Return Summer I, II, and Fall if in spring semester. 
# Return Summer II, and Fall if in Summer I semester. 
# Return Fall if in Summer II semester.
# Return Spring if in Fall semester.)



# Read all courses from AllCourses Table


# Read course pre requisites given a CourseID


# Read Courses requiring approval, and their notes


# Read existing catalog years
#(Possibly need new table to list catalog years quicker, for drop down menus)


############## UPDATE ################

# Update all User attributes from User Table, except UserID (Use params passed)


# Update a users course in StudenCourses table


# Update


# Update



############## DESTROY ###############