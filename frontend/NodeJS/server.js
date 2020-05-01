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
const axios = require('axios').default;//for jwt request to api
var hbs = require( 'express-handlebars');

app = express();
app.set('port', 3002);

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
    console.log("home token: "+req.query.token);

    //get all the courses usin token
    axios.get(`http://localhost:4567/all/Courses`, {
        headers:{
            'Authorization': `bearer ${req.query.token}`
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
            token: req.query.token,
            courses: courses    
        });

      })
      .catch(function (error) {
        // handle error
        console.log(error);
      })


    // //render page with courses 
    // res.render("home",{active: 
    //     { home: true },
    //     page: "Home",
    //     token: req.query.token
    // });
});

//get login page
app.get('/login', (req, res) => {
    //hide main.html content by sending false
    res.render("login", {show: null});
});

//get register page
app.get('/register', (req, res) => {
    res.render("register");
});

//get advising page
app.get('/advising', (req, res) => {
    res.render("advising",{active: { advising: true },page: "Advising"});
});

//get future_courses page
app.get('/future_courses', (req, res) => {
    res.render("future_courses",{active: { future_courses: true },page: "Future Courses"});
});

//get notifications page
app.get('/notifications', (req, res) => {
    res.render("notifications",{active: { notifications: true },page: "Notifications"});
});

//get user_profile page
app.get('/user_profile', (req, res) => {
    res.render("user_profile",{active: { user_profile: true },page: "User Profile"});
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
        // res.redirect("/home"+token);
        //redirect user to home page with token
        res.redirect(url.format({
            pathname:"/home",
            query: {
               "token": token,
             }
          }));
    })
    .catch(function (error) {
        console.log(error);
        
         //if succsesful
       // res.redirect("/login");
    });

  // res.redirect("/home");
});


var server = app.listen(app.get('port'), function() {
	console.log("Server started...")
});