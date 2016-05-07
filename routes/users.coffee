express  = require 'express'
router   = express.Router()
colors   = require 'colors'
# async    = require 'async'
# passport = require 'passport'

user  = require '../models/userModel'
lugar = require '../models/lugarModel'
afeccion = require '../models/afeccionModel'
producto = require '../models/productoModel'
finder   = require '../models/finder'

files = require '../utils/files'


# PÁGINA CON TODOS LOS PRODUCTOS DEL USUARIO
router.route '/:username/all'
    .get user.isLogged
        , 
            (req, res, next)-> 
                if req.params.username is req.user.username
                    finder.find_user_items req.user._id, (err, user_items)->
                        if err then res.status(500).send(err)
                        req.user.isowner = true
                        req.send = 
                                user : req.user
                                items: user_items
                        next()
                else
                    user.findOne {username: req.params.username}, (err, user_found)->
                        if err then res.status(500).send(err)
                        finder.find_user_items user_found._id, (err, user_items)->
                            if err then res.status(500).send(err)
                            req.send = 
                                    user : user_found
                                    items: user_items
                            next()
        ,
            (req, res, next)->
                res.render 'profile/items',
                    title   : 'Items - ToleranceIn'
                    pageName: 'Items'
                    loggued : req.user
                    user    : req.send.user
                    items   : req.send.items


# PÁGINA CON TODOS LOS FAVORITOS DEL USUARIO
router.route '/:username/favorites'
    .get user.isLogged
        , 
            (req, res, next)-> 
                if req.params.username is req.user.username
                    finder.find_user_favs req.user._id, (err, user_favs)->
                        if err then res.status(500).send(err)
                        req.user.isowner = true
                        req.send = 
                                user : req.user
                                items: user_favs
                        next()
                else
                    user.findOne {username: req.params.username}, (err, user_found)->
                        if err then res.status(500).send(err)
                        finder.find_user_favs user_found._id, (err, user_favs)->
                            if err then res.status(500).send(err)
                            req.send = 
                                    user : user_found
                                    items: user_favs
                            next()
        ,
            (req, res, next)->
                res.render 'profile/items',
                    title   : 'Favoritos - ToleranceIn'
                    pageName: 'Favoritos'
                    loggued : req.user
                    user    : req.send.user
                    items   : req.send.items


# PÁGINA CON TODOS LOS LUGARES DEL USUARIO
router.route '/:username/places'
    .get user.isLogged
        , 
            (req, res, next)->         
                # opts = [ { path: req.user,    options: { limit: 100 , sort: {'visitas': 1}} } ]
                if req.params.username is req.user.username
                    user.findById(req.user._id).populate('lugares').exec (err, user_places)->
                        if err then res.status(500).send(err)
                        req.user.isowner = true
                        req.send = 
                                user : req.user
                                items: user_places.lugares
                        next()
                else
                    user.findOne({username: req.params.username}).populate('lugares').exec (err, user_places)->
                        if err then res.status(500).send(err)
                        req.send = 
                                user : user_places
                                items: user_places.lugares
                        next()
        ,
            (req, res, next)->
                res.render 'profile/items',
                    title   : 'Lugares - ToleranceIn'
                    pageName: 'Lugares'
                    loggued : req.user
                    user    : req.send.user
                    items   : req.send.items


# PÁGINA CON TODOS LOS PRODUCTOS DEL USUARIO
router.route '/:username/products'
    .get user.isLogged
        ,
            (req, res, next)->                
                if req.params.username is req.user.username
                    user.findById(req.user._id).populate('productos').exec (err, user_products)->
                        if err then res.status(500).send(err)
                        req.user.isowner = true
                        req.send = 
                                user : req.user
                                items: user_products.productos
                        next()
                else
                    user.findOne({username: req.params.username}).populate('productos').exec (err, user_products)->
                        if err then res.status(500).send(err)
                        req.send = 
                                user : user_products
                                items: user_products.productos
                        next()
        ,
            (req, res, next)->    
                res.render 'profile/items',
                    title   : 'Productos - ToleranceIn'
                    pageName: 'Productos'
                    loggued : req.user
                    user    : req.send.user
                    items   : req.send.items


# PÁGINA CON FORMULARIO DE PERFIL DEL USUARIO
router.route '/:username/profile'

    .get user.isLogged
        , 
            (req, res, next)-> 
                if req.params.username is req.user.username
                    req.user.isowner = true     
                    res.render 'profile/perfil',
                        title   : 'Perfil - ToleranceIn'
                        pageName: 'Perfil'
                        loggued : req.user
                        user    : req.user
                else
                    user.findOne({username: req.params.username}, (err, user_found)->
                        if err then res.status(500).send(err)     
                        res.render 'profile/public_perfil',
                            title   : 'Perfil - ToleranceIn'
                            pageName: 'Perfil'
                            loggued : req.user
                            user    : user_found
                    )
        
        
    .post user.isLogged, files.saveFile('./public/images/users', 'displayImage'), (req, res, next) ->

                user.findOneAndUpdate(  {username: req.user.username}
                                        { $set: {           
                                                    nombre      : req.body.nombre
                                                    apellidos   : req.body.apellidos
                                                    ciudad      : req.body.ciudad
                                                    intereses   : req.body.alergias
                                                    image       : if req.file and req.file.path then req.file.path else req.user.image
                                                    # intereses   : req.body.intereses
                                                }
                                        }
                                        { new : true }
                                        (err, resp)->
                                            if err 
                                                console.log err 
                                                return res.status(400).send('Cannot save user')
                                            # console.log resp
                                            res.render 'profile/perfil',
                                                title   : 'Perfil - ToleranceIn'
                                                pageName: 'Perfil'
                                                user    : resp
                                    )


# GUARDAR FAV
router.route '/:username/save_fav'

    .post user.isLogged, (req, res, next) ->
        switch req.body.clase
            when 'producto' 
                if req.user.productoFAV.indexOf(req.body.item) is -1
                    update = {$push: { productoFAV: req.body.item } } 
                    option = 'added'
                else 
                    update = {$pull: { productoFAV: req.body.item } } 
                    option = 'removed'


        user.findByIdAndUpdate( req.user._id, update, (err, updated_user)->
            if err 
                console.log err
                res.status(400).json({error: err})
            res.status(200).json({user: updated_user, option: option })
        )





module.exports = router
