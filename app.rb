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
      api_authenticate!
  
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
      
        print u.id
        print u.Email
        print u.FirstName
        print u.Password
      
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
      api_authenticate!
  
      halt 200, {message: "User Authentication passed."}.to_json
    end  
  

  ############## CREATE ################


 
  # Create Users Given Email, FirstName, LastName, Password, and admin (true/false).
  #****ALREADY IMPLEMENTED IN ***
  #     api_authentication.rb
  
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