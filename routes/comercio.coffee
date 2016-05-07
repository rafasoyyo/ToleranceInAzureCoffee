
router   = require('express').Router()
moment   = require 'moment'
lodash   = require 'lodash'
user     = require '../models/userModel'
Lugar    = require '../models/lugarModel'
colors   = require 'colors'

files = require '../utils/files'

router.route '/'
    # RETURN JSON WITH ALL PRODUCTS
    .get user.isAuthenticated , (req, res, next) ->

        Lugar.find (err, results)->
            if err then return res.status(500).end()

            resp = []
            opts = [{ path: 'autor'}]  
            results.forEach (item)->          
                Lugar.populate item, opts, (err, data)->
                    resp.push data
                    if results.length is resp.length then return res.json resp
            

    # SAVE PRODUCT
    .post user.isAuthenticated , files.saveFile('./public/images/items', 'displayImage'), (req, res, next) ->

        new_lugar = new Lugar({
            url         : encodeURI(req.body.name)
            nombre      : req.body.name
            descripcion : req.body.description
            especialidad: req.body.especialidad
            direccion   : req.body.direccion
            telefono    : req.body.telefono
            web         : req.body.web
            etiquetas   : lodash.compact(req.body.tags.split(',') )
            tipo        : req.body.tipo 
            image       : if req.file and req.file.path then req.file.path else null
        })

        if req.user 
            new_lugar.autor = req.user._id
            if req.user.rol isnt 'user' 
                new_lugar.validado = true
                new_lugar.revisor  = req.user_id

        new_lugar.save (err, lugar)->
            if err then return res.redirect 'create' + "?item=comercio&invalid=0"

            if req.user
                user.findOneAndUpdate req.user._id , {$push: {"lugares": lugar._id }}, (err, users)->
                    res.redirect 'comercio/' + lugar.url
            else
                res.redirect 'comercio/' + lugar.url



router.route '/:slug'
    # SEE PRODUCT VIEW
    .get user.isAuthenticated , (req, res, next) ->

        Lugar.findOne  {nombre: req.params.slug} , (err, result)->
            if err or not result then return res.status(500).send(err)
            num_visita = if isNaN(result.visitas) then 1 else result.visitas + 1
            Lugar.findOneAndUpdate {nombre: req.params.slug}  , {visitas: result.visitas + 1}, (err, lugar_found)->                  
                if err then console.log colors.red(err) 

                lugar = new Lugar(lugar_found)
                opts = [{ path: 'autor'}, { path: 'revisor'}, { path: 'comentarios.autor' }]            
                Lugar.populate result, opts, (err, resp)->  
                    if err then return res.status(500).send(err)

                    resp.comentarios = resp.comentarios.sort (a, b)->
                                                        r = new Date(a.created).getTime() - new Date(b.created).getTime()
                                                        return r < 0 ? true : false

                    # console.log colors.red(resp.comentarios)
                    res.render 'item/item',
                        title   : resp.nombre + ' - ToleranceIn'
                        pageName: 'Lugar - ToleranceIn'
                        user    : req.user
                        item    : resp



router.route '/edit/:slug'
    # EDIT PRODUCT VIEW
    .get user.isAuthenticated , (req, res, next) ->

        Lugar.findOne {nombre: req.params.slug} , (err, comercio)->
            console.log comercio
            if err then return res.status(500).end()
            res.render 'item/lugar_edit',
                title   : 'Edit - ToleranceIn'
                pageName: 'EditProduct'
                user    : req.user
                comercio: comercio


    # PRODUCT CREATION
    .post user.isAdmin, files.saveFile('./public/images/items', 'displayImage'), (req, res, next) -> 

        new_lugar = 
                    descripcion : req.body.description
                    especialidad: req.body.especialidad
                    direccion   : req.body.direccion
                    telefono    : req.body.telefono
                    web         : req.body.web
                    etiquetas   : if req.body.tags then lodash.compact(req.body.tags.split(',') ) else null
                    tipo        : req.body.tipo 
                    revisor     : req.user._id
                    validado    : if req.user.rol isnt user then true else false

        Lugar.findOneAndUpdate {nombre: req.params.slug} , new_lugar, (err, lugar)->
            if err then res.status(500).send( err.message)
            console.log colors.red(lugar)
            res.redirect '/comercio/' + lugar.nombre



router.route '/comment/:id'
    .get (req, res, next) -> 

        Lugar.findById(req.params.id).populate([{ path: 'comentarios.autor' }]).exec (err, product)-> 
        # lugar.findById req.params.id, (err, product)->
            if err then return res.status(500).send( err.message)
            res.status(200).json({comentarios: product.comentarios})

router.route '/comment'
    # PRODUCT COMMENT
    .post user.isAuthenticated, (req, res, next) -> 
        
        new_comment = {
                        autor: if req.user then req.user._id else '572e3471124d12207cae6246'
                        mensaje: req.body.comentario
                        created: Date.now()
        }

        Lugar.findByIdAndUpdate req.body.id, {$push: {"comentarios": new_comment }}, {new: true}, (err, lugar)->
            if err then res.status(500).send( err.message)
            console.log lugar.comentarios
            res.status(200).json({comentario: new_comment})


module.exports = router