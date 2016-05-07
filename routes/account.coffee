
router  = require('express').Router()
passport = require 'passport'

userM  = require '../models/userModel'


# LOGUIN DEL USUARIO
router.post '/login', passport.authenticate('local') , (req, res, next)-> res.status(200).end()


# LOGOUT DEL USUARIO
router.all '/logout', (req, res, next)-> 
    console.log 'all'
    req.logOut()    
    res.redirect('/')


# REGISTRO DE NUEVOS USUARIOS
router.post '/register', (req, res, next)->
    # console.log 'req.body: ', req.body

    userM.register(  new userM({  
                                nickname : req.body.nickname
                                username : req.body.nickname 
                                email    : req.body.email 
                            }), 
                    req.body.password, 
                    (err, user)->
                        if err
                            console.log err
                            # console.log err.toJSON()
                            # console.log '$$$$$$$$$$$$$$$$$$$$$$'
                            # console.log err.toString()
                            switch err.name
                                when 'MissingUsernameError' then return res.status(400).json({id: 1, msg: 'No username'})
                                when 'UserExistsError'      then return res.status(400).json({id: 2, msg: 'Username in use'})
                                when 'MongoError'           
                                    if err.code is 11000 then res.status(400).json({id: 3, msg: 'Email in use', code: err.code })
                                    else res.status(400).json({id: 4, msg: 'Data base error', code: err.code })
                                else  res.status(400).json({id: 0, msg: 'Undefined error' })
                        
                        req.login(user, -> res.status(200).end() ) 
                )   

# REGISTRO DE NUEVOS USUARIOS
router.post '/available', (req, res, next)->

    userM.findOne({username: req.body.username} , (err, user)->
                        if err then console.error err; return res.status(500).end()
                        if !user then return res.status(200).end()
                        return res.status(400).json({id: 0, msg: 'Username in use' })
                )   

# REGISTRO DE NUEVOS USUARIOS
router.post '/recover', (req, res, next)->

    userM.findOne({$or: [{username: req.body.username}, {email: req.body.username}] }, (err, user)->
                        if err then console.error err; return res.status(400).json({id:0, msg: 'Error finding user'})
                        if not user then return res.status(400).json({id:1, msg: 'No acount found'})

                        user.update( {'recover' : Date.now().toString() }, (err)->
                            if err then return res.status(400).end({id:2, msg: 'Error saving new recover key'})
                            return res.status(200).end()
                            console.log user
                        )
                ) 

module.exports = router