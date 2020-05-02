/*
*This is the client side server it serves the pages and connects to the api
*you need to install dependencies by running npm install
*then run the server with "node server.js" or "nodemon server.js" 
*you can view the page at http://localhost:3002
*make sure your API server is also running to be able to connect to it
*I use handlebars to inject all html pages into main.html
*I also use handlebars to inject the information from the api into the html views
* 
*/
//___________________________Server setup_________________
const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const axios = require('axios').default;//for jwt request to api
var hbs = require( 'express-handlebars');
//require('handlebars-form-helpers').register(hbs.handlebars);


app = express();
app.set('port', 3002);

// add middleware to expose and manipulate cookie data in
//  the request/response
app.use(cookieParser());

// setup handlebars and the view engine for res.render calls
app.set('view engine', 'html');
app.engine( 'html', hbs( {
  extname: 'html',
  defaultView: 'default',
  layoutsDir: __dirname + '/views/layouts/',
  partialsDir: __dirname + '/views/partials/'
}));

// setup body parsing for form data
var bodyParser = require('body-parser');
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// setup static file service
app.use(express.static(path.join(__dirname, 'static')));

const url = require('url'); 
//const token = ''

//______________________________________________________________________________

//get home page
app.get('/home', (req, res) => {

    //get all the courses using token
    axios.get(`http://localhost:4567/all/Courses`, {
        headers:{
            'Authorization': `bearer ${req.cookies["token"]}`
        }        
    }).then(function (response) {
        // handle success
        console.log("courses: "+JSON.stringify(response["data"]));
        let courses = response["data"];
        console.log("courses variable: "+courses);
        //render page with courses 
        res.render("home",{active: 
            { home: true },
            page: "Home",
            courses: courses    
        });

      })
      .catch(function (error) {
        // return error to notify user
        console.log(error);
      })


});

//get login page
app.get('/login', (req, res) => {
    //hide main.html content by sending false
    res.render("login", {layout: false});
});

//get register page
app.get('/register', (req, res) => {
    res.render("register",{layout: false});
});

//get advising page
app.get('/advising', (req, res) => {
    res.render("advising",{active: 
        { advising: true },
        page: "Advising"
    });
});



//get future_courses page
app.get('/future_courses', (req, res) => {
     console.log("cookie token: "+req.cookies["token"]);
     //get all the courses using token
     axios.get(`http://localhost:4567/all/Courses`, {
        headers:{
            'Authorization': `bearer ${req.cookies["token"]}`
        }        
    }).then(function (response) {
        // handle success
        console.log("courses: "+JSON.stringify(response["data"]));
        let courses = response["data"];
        //render page with courses 
        res.render("future_courses",{active: 
            { future_courses: true },
            page: "Future Courses",
            courses: courses    
        });

      })
      .catch(function (error) {
        // handle error
        console.log(error);
      })

});

//get notifications page
app.get('/notifications', (req, res) => {
    res.render("notifications",{active: { notifications: true },page: "Notifications"});
});

//get user_profile page
app.get('/user_profile', (req, res) => {
    res.render("user_profile",{active: { user_profile: true },page: "User Profile"});
});


//add courses that users plan to take in the next semester (veryfied by advisor)
//http://localhost:4567/update/Student_Courses/
//req.body.courses contains the course id to be added
app.post('/add_courses', (req, res) => {
    console.log("add_courses: "+req.body.courses);
    //use axios to add courses in api
    for (i = 0; i < req.body.courses.length; i++) {
        axios.post(`http://localhost:4567/update/Student_Courses?CourseID=${req.body.courses[i]}`, {
            headers:{
                'Authorization': `bearer ${req.cookies["token"]}`
            }        
        }
         ).then(function (response) {
            console.log(response);
            //if succsesful
            res.redirect("/future_courses");
        })
        .catch(function (error) {
            console.log(error+" error adding course");
            //if succsesful
            res.redirect("/future_courses");
        });
    }
 });
 
 

//register a new user with the api
// http://localhost:4567/api/register
app.post('/register', (req, res) => {
    let username = req.body.username.trim();
    let password = req.body.password.trim();
	let firstName = req.body.firstName.trim();
    let lastName = req.body.lastName.trim();
    //console.log(username, password);
    //call api with user info
    axios.post(`http://localhost:4567/api/register?username=${username}&password=${password}&firstName=${firstName}&lastName=${lastName}`
      
   ).then(function (response) {
        console.log(response);
         //if succsesful
         res.redirect("/login");
    })
    .catch(function (error) {
        console.log(error);
         //if succsesful
        res.redirect("/login");
    });
});



//get login information from api
//`http://localhost:4567/api/login?username=${username}&password=${password}`
app.post('/login', (req, res) => {
    let username = req.body.username.trim();
    let password = req.body.password.trim();
    axios.get(`http://localhost:4567/api/login?username=${username}&password=${password}`
      
   ).then(function (response) {
        console.log(response);
         //if succsesful
        const token = response['data'].token;
        console.log("login token: "+token);
       //store token in cookie
       res.cookie("token", token);
       res.redirect("/home");
    })
    .catch(function (error) {
        console.log(error);
         //if unsuccsesful
        res.redirect("/login");
    });
});


var server = app.listen(app.get('port'), function() {
	console.log("Server started...")
});