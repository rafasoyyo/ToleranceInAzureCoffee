require('coffee-script/register');

var express     = require('express');
var path        = require('path');
var favicon     = require('serve-favicon');
var logger      = require('morgan');
var compression = require('compression');
var cookieParser= require('cookie-parser');
var bodyParser  = require('body-parser');

config = require('./config');

mongodb = config.azure.mongodb;
mongoose = require('mongoose');
mongoose.connect(mongodb);

// ROUTES IMPORTS
var home    = require('./routes/index'),
    users   = require('./routes/users'),    
    account = require('./routes/account'),
    producto= require('./routes/producto'),
    comercio= require('./routes/comercio'),
    find    = require('./routes/find');

var app = express();

var env = process.env.NODE_ENV || 'development';
app.locals.ENV = env;
app.locals.ENV_DEVELOPMENT = env == 'development';

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

// User auth
var user = require('./models/userModel');
var passport = require('passport');
var LocalStrategy = require('passport-local').Strategy;
var expressSession = require('express-session');
var MongoStore = require('connect-mongo')(expressSession);
app.use(expressSession({
  secret: 'ToleranceSecretKey',
  resave: false,
  saveUninitialized: true,
  store: new MongoStore({
    mongooseConnection: mongoose.connection,
    ttl: 1 * 24 * 60 * 60
  })
}));
app.use(passport.initialize());
app.use(passport.session());
passport.use(new LocalStrategy(user.authenticate()));
passport.serializeUser(user.serializeUser());
passport.deserializeUser(user.deserializeUser());

// app.use(favicon(__dirname + '/public/img/favicon.ico'));
app.use(compression());
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
  extended: true
}));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

//ROUTES USE
app.use('/',        home);
app.use('/account', account);
app.use('/users',   users);
app.use('/producto',producto);
app.use('/comercio',comercio);
app.use('/find',    find);

/// catch 404 and forward to error handler
app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

/// error handlers

// development error handler
// will print stacktrace

if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        res.status(err.status || 500);
        res.render('error', {
            message: err.message,
            error: err,
            title: 'error'
        });
    });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
        message: err.message,
        error: {},
        title: 'error'
    });
});


module.exports = app;
