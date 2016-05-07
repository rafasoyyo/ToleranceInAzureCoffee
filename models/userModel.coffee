mongoose = require 'mongoose'
passportLocalMongoose = require 'passport-local-mongoose'
Schema   = mongoose.Schema

lugar = require './lugarModel'
afeccion = require './afeccionModel'
producto = require './productoModel'

userSchema = new Schema({
                        username    : { type : String, unique : true, required: true}
                        email       : { type : String, unique : true, required: true}
                        nombre      : { type : String }
                        apellidos   : { type : String }
                        ciudad      : { type : String }
                        image       : { type : String }
                        password    : { type : String }
                        intereses   : [{ type : String }]
                        rol         : { type : String , default: "user", enum: ['user', 'admin', 'super']}
                        lugares     : [{ type : Schema.ObjectId, ref: 'lugar'    }]
                        productos   : [{ type : Schema.ObjectId, ref: 'producto' }]
                        afecciones  : [{ type : Schema.ObjectId, ref: 'afeccion' }]
                        lugarFAV    : [{ type : Schema.ObjectId, ref: 'lugar'    }]
                        productoFAV : [{ type : Schema.ObjectId, ref: 'producto' }]
                        afeccionFAV : [{ type : Schema.ObjectId, ref: 'afeccion' }]
                }, { timestamps: true, strict: false })



userSchema.post 'init', (result)->
    if result.image and result.image.match('public') isnt null
        result.image = result.image.split('public')[1]


userSchema.plugin(passportLocalMongoose, ({usernameQueryFields: ['username', 'email']}))

userModel = mongoose.model('user', userSchema)

module.exports = userModel

# // route middleware to make sure a user is logged in
userModel.isAuthenticated = (req, res, next)->
    req.isAuthenticated()
    next()

# // route middleware to make sure a user is logged in
userModel.isLogged = (req, res, next)->
    console.log 'isAuthenticated', req.isAuthenticated()
    if req.isAuthenticated() then return next()
    res.redirect('/')

# // route middleware to make sure a user is logged in
userModel.isAdmin = (req, res, next)->
    if req.isAuthenticated() 
        if req.user.rol isnt 'user' then return next()
    res.redirect('/')