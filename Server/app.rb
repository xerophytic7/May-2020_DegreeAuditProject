require "sinatra"
require "sinatra/namespace"
require_relative "api_authentication.rb"
require "json"
require File.expand_path("../models/AllCourses.rb", __FILE__)
require File.expand_path("../models/User.rb", __FILE__)
require File.expand_path("../models/Categories.rb", __FILE__)
require File.expand_path("../models/CourseALT.rb", __FILE__)
require File.expand_path("../models/CourseCategories.rb", __FILE__)
require File.expand_path("../models/CoursePreREQ.rb", __FILE__)
require File.expand_path("../models/PlannedFutureCourses.rb", __FILE__)
require File.expand_path("../models/StudentCourses.rb", __FILE__)

#require_relative 'models/User.rb'
#require_relative 'models/Categories.rb'
#require_relative 'models/CourseALT.rb'
#require_relative 'models/CourseCategories.rb'
#require_relative 'models/CoursePreREQ.rb'
#require_relative 'models/PlannedFutureCourses.rb'
#require_relative 'models/StudentCourses.rb'

if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost//mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/app.db")
end

DataMapper.finalize

User.auto_upgrade!
PlannedFutureCourses.auto_upgrade!
CourseALT.auto_upgrade!
CourseCategories.auto_upgrade!
CoursePreREQ.auto_upgrade!
StudentCourses.auto_upgrade!
AllCourses.auto_upgrade!
Categories.auto_upgrade!

#If there is no admin account, make one.
post '/createAdmin' do

  if User.all(admin: true).count == 0
    u = User.new
    u.id = 1337
    u.Email = "admin@admin.com"
    u.Password = "admin"
    u.admin = true
    u.save
    return u.to_json
    halt 200, {"message": "Admin account created"}.to_json
  else
  halt 422, {"message": "Admin account already exists"}.to_json
  end
end

# TEST # Create user with custom serial id
post '/customid' do
  username = params["username"]
  password = params["password"]
  fn = params["firstName"]
  ln = params["lastName"]
  id = params["id"]
  if username && password
    user = User.first(Email: username.downcase)
 
    if(user)
      halt 422, {"message": "Username already in use"}.to_json
    else
      if fn && ln && id
        u = User.new
        u.FirstName = fn
        u.LastName = ln
        u.Email = username.downcase
        u.Password = password
        u.id = id
        u.save
        halt 201, {"message": "Account successfully registered"}.to_json
      else
        message = "Missing First or Last Name or ID"
        halt 400, {"message": message}.to_json
      end
    end
  else
      message = "Missing username or password"
      halt 400, {"message": message}.to_json
  end
end
    
#test add 10 regular users if there's less than 3 users
get '/test' do
  #api_authenticate!
  
  if User.count < 3
    
    i = 1
    last = 11
      
    while i < last do
      u = User.new
      u.id = i + 9999
      u.Email = "email#{i}@email.com"
      u.FirstName = "user#{i}"
      u.Password = "pw#{i}"
      u.save
      i += 1 
    end
      
    return "Created 10 users"
  end
  
  return "Current Users: #{User.count}"
    
end

#test delete all non admin users
delete '/allUsers' do
  u = User.all(admin: false)
  u.destroy

  if User.count == 1
    halt 200, {message: "All Users Successfully deleted"}.to_json
  else
    halt 400, {message: "Unable to delete all users"}.to_json
  end
end
  
#Test user authentication
get '/test_authentication' do
  #api_authenticate!
  
  halt 200, {message: "User Authentication passed."}.to_json
end  
#CHECKS IF GIVEN COURSEID CATALOG YEAR MATCHES GIVEN USERID CATALOG YEAR
#RETURNS TRUE IF MATCH, OR IF COURSE HAS NO CATALOG YEAR
#RETURNS FALSE IF COURSE IS PART OF DIFFERENT CATALOG YEAR
def same_catalog_year courseid, userid
  cats = CourseCategories.all(CourseID: courseid)
  if cats
    cats.each do |i|
    yrs << Categories.get(i.CategoryID)
    end
    if yrs
      u = User.get(userid)
      yrs.each do |i|
        u.CatalogYear == i.CatalogYear ? (return true) : next
      end
      return false
    end
  else
    return true
  end
end
#IN CASE WE NEED TO CHECK IF GIVEN SEMESTER IS VALID
semesters = ["fall", "spring", "summer i", "summer ii"]
def valid_semester semester
  semester.split
  if semester.length !=2
    return false
  end
  if semesters.count semester[0].downcase != 1
    return false
  end
  if semester[1].to_i < 1927 && semester[1].to_i > Time.new.year
    return false
  end
  return true
end

############## CREATE ################

  # Create Courses given params CourseDept, CourseNum, Name, and Institution
  post '/add/Course' do
    #api_authenticate!
    # if !current_user.admin
    #   halt 401, {"message": "Unauthorized user"}.to_json
    # end
    params["CourseDept"] ? (CourseDept = params["CourseDept"]) : (halt 400, {"message": "Missing Paramaters"}.to_json)
    params["CourseNum"] ? (CourseNum = params["CourseNum"]) : (halt 400, {"message": "Missing Paramaters"}.to_json)
    params["Name"] ? (name = params["Name"]) : (halt 400, {"message": "Missing Paramaters"}.to_json)
    params["Institution"] ? (Institution = params["Institution"]) : (halt 400, {"message": "Missing Paramaters"}.to_json)

    if CourseDept != '' && CourseNum != '' && name != '' && Institution != ''
      c = AllCourses.new
      c.CourseDept = CourseDept
      c.CourseNum = CourseNum
      c.Name = name
      c.Institution = Institution
      c.save

      halt 200, {"message": "Successfully added course to AllCourses Table"}.to_json
    else
      halt 400, {"message": "Missing Paramaters"}.to_json
    end

  end
  
  # Create Users Given Email, FirstName, LastName, Password, and admin (true/false).
  #****ALREADY IMPLEMENTED IN ***
  #     api_authentication.rb
  
  # Create entry to StudentCourses using current UserID
  # (Depending on params given)
  post '/add/StudentCourses' do
    #api_authenticate!
    userid = params['UserID']
    params["CourseID"] ? (courseid = params['CourseID']): (halt 400, {"message": "Missing CourseID paramater"}.to_json)
    params["Semester"] ? (semester = params['Semester']): (halt 400, {"message": "Missing Semester paramater"}.to_json)
    params["Grade"] ? (grade = params['Grade']): (halt 400, {"message": "Missing Grade paramater"}.to_json)
    notes = params['Notes']
    if courseid != '' && semester != '' && grade != ''
      if userid
        if current_user.admin
          # I COULD CHECK IF COURSE CATALOG YEAR MATCHES USER CATALOG YEAR
          # if same_catalog_year(courseid, userid)    
          # BUT NOT SURE WHY WE'D NEED THIS CHECK HERE
          c = StudentCourses.new
          userid != '' ? (c.UserID = userid) : (halt 400, {"message": "Missing UserID paramater"}.to_json)
          c.CourseID = courseid
          c.SemesterID = semester
          c.Grade = grade
          if notes != nil
            c.Notes = notes 
          end
          c.save
          halt 201, {"message": "Course added successfully"}.to_json
        else
          halt 401, {"message": "Unauthorized user"}.to_json
        end
      else
        # I COULD CHECK IF COURSE CATALOG YEAR MATCHES USER CATALOG YEAR
        # if same_catalog_year(courseid, current_user.id)
        # BUT NOT SURE WHY WE'D NEED THIS CHECK HERE
        c = StudentCourses.new
        c.UserID = current_user.id
        c.CourseID = courseid
        c.SemesterID = semester
        c.Grade = grade
        if notes != nil
          c.Notes = notes
        end
        c.save
        halt 201, {"message": "Course added successfully"}.to_json
      end
    else
      halt 400, {"message": "Missing courseID, semester, or grade"}.to_json
    end
  end
  
  # Create entries to PlannedFutureCourses given JSON list of courses, 
  # list of courses should have CourseID and Semester. 
  post '/add/PlannedCourses' do
    #api_authenticate!
    plannedCourses = params[:Courses]
    if plannedCourses
      plannedCourses.each do |i|
        if i[1]["courseID"] != '' && i[1]["semester"] != ''
          # if valid_semester(i[1]['semester'])    Checks semester matches spring, fall, summer i, or summer ii
          next
        else
          halt 400, {"message": "Missing CourseID or Semester"}.to_json
        end 
      end
      plannedCourses.each do |i|
        #puts i[1]["courseID"]
        #puts i[1]["semester"]
        p = PlannedFutureCourses.new
        p.UserID = current_user.id
        p.CourseID = i[1]["courseID"]
        p.Semester = i[1]["semester"]
        p.save
      end
        halt 201, {"message": "Courses added to Planned courses successfully"}.to_json
    else
      halt 400, {"message": "Missing Courses paramaters"}.to_json
    end
  end

  #///////////////////////////////////////////////////////////
  # Create a Category Given CategoryNum, Name, and ReqHours
  post '/add/Category' do
    #api_authenticate!
    #halt 404, {"message" => "User not an admin"} if 
    
    halt 400, {"message" => "Missing CategoryNum or CategoryName or ReqHours"}.to_json if((params["CategoryNum"].nil?) or (params["CategoryName"].nil?) or (params["ReqHours"].nil?)) 
    c = Categories.new
    c.CategoryNum   = params["CategoryNum"] 
    c.CategoryName  = params["CategoryName"]
    c.ReqHours      = params["ReqHours"]
    c.CatalogYear   = params["CatalogYear"]       if !params["CatalogYear"].nil?
    c.save
    halt 201, c.to_json

  end

  
  # Assign a given CourseID and CategoryID to CourseCategories Table
  
  
  # Create Course prerequisites Given a CourseID and PreReqID
  
  
  # Create Course alternatives Given a CourseID and AltID
  
  
  # Create new degree plan (Mainly add to Categories Table: CategoryNum, 
  # CategoryName, CatalogYear, and ReqHours. Then matching the CatagoryID
  # with a CourseID and adding that to CourseCategories table.)
  
  
  
  
  ############## READ ##################
  
  # Read current users FirstName, LastName, Email, GPA, CatalogYear, 
  # Classification, Hours, AdvancedHours, & Advanced_CS_Hours from User Table
  get '/user/myaccount' do
    api_authenticate!
    halt 200, current_user.to_json(exclude: [:password])
    #halt 200, current_user.to_json(exclude: [:password],[:admin])
  end
  
  # Given an email (or student ID if we add that), Read a users FirstName, 
  # LastName, Email, GPA, CatalogYear, Classification, Hours, AdvancedHours,
  # & Advanced_CS_Hours from User Table
  # Also read their taken courses, their planned future courses
  get '/user/email' do

    #halt 200, User.Email("#{params["email"]}").to_json(exclude: [:password])
  
  end
  
  # Read current users courses from StudentCourses table.
  # Maybe calculate user GPA, Classification, Hours, AdvancedHours,
  # and Advanced_CS_Hours while we're at it.
  
  
  # Read a students PlannedFutureCourses given an email and semester(s)
  
  
  # Read from PlannedFutureCourses table given a semester  
  get '/user/PlannedFutureCourses' do
    #api_authenticate!
    Semester = params["semester"]
    halt 200, PlannedFutureClasses.current_user(id).to_json(exclude: [:UserID])
    #halt 200, current_user.to_json(exclude: [:password],[:admin])
  end
  
  
  # Read ALL PlannedFutureCourses 
  # (Return Summer I, II, and Fall if in spring semester. 
  # Return Summer II, and Fall if in Summer I semester. 
  # Return Fall if in Summer II semester.
  # Return Spring if in Fall semester.)
  
  
  
  # Read all courses from AllCourses Table
  get "/courses/all" do
    halt 200, AllCourses.all.to_json
  end
  
  # Read course pre requisites given a CourseID
  
  
  # Read Courses requiring approval, and their notes
  
  
  # Read existing catalog years
  #(Possibly need new table to list catalog years quicker, for drop down menus)
  

  #TEST READ ALL USERS
  get '/printAllUsers' do
    return User.all.to_json
  end
  
  ############## UPDATE ################
  
  # Update all User attributes from User Table, except UserID (Use params passed)
  
  
  # Update a users course in StudenCourses table
  
  
  # Update
  
  
  # Update
  
  
  
  ############## DESTROY ###############