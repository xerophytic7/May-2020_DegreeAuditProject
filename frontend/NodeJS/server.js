

const express = require('express');
const path = require('path');
//const request = require('request');
const axios = require('axios').default;
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

//get home page
app.get('/home', (req, res) => {

    res.render("home",{active: { home: true },page: "Home"});
});

//get login page
app.get('/login', (req, res) => {
    res.render("login");
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
        //res.redirect("/login");
    });

   
});


// //register a new user with the api
// // http://localhost:4567/api/register
// app.post('/register', (req, res) => {
//     let username = req.body.username;
//     let password = req.body.password;
// 	let firstName = req.body.firstName;
//     let lastName = req.body.lastName;
//     //console.log(username, password);
//     //call api with user info
//     axios.post('http://localhost:4567/api/register', {username: username, password: password, 
//     firstName: firstName,  lastName: lastName, }, 
//     {headers: {'Accept': 'application/json'}})
//     .then(function (response) {
//         console.log(response);
//     })
//     .catch(function (error) {
//         console.log(error);
//     });

// });











// // basic view route
// app.get('/home', function(req, res, next) {
//   res.render('home');
// });



var server = app.listen(app.get('port'), function() {
	console.log("Server started...")
});