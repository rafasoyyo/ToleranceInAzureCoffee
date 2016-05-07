express = require 'express'
router = express.Router()

user  = require '../models/userModel'
lugar = require '../models/lugarModel'
afeccion = require '../models/afeccionModel'
producto = require '../models/productoModel'
finder   = require '../models/finder'

# GET home page.
router.get '/', user.isAuthenticated , (req, res, next) ->
    
    res.render 'home/index',
        title   : 'Home - ToleranceIn'
        pageName: 'Home'
        user    : req.user


# GET home page.
router.route '/elements/all'
    .get (req, res, next) ->
        
        console.log 'results'
        finder.find_all_items (err, results)->
            console.log results
            if err then return res.status(500).json(err)       
            res.status(200).json({
                                    productos : results.producto
                                    afecciones: results.afeccion
                                    lugares   : results.lugar
                                    all       : results.all
                                })
    .post (req, res, next) ->
        console.log req.body
        finder.filter_all_items req.body.finder, (err, results)->
            if err then return res.status(500).json(err)       
            res.status(200).json({
                                    productos : results.producto
                                    afecciones: results.afeccion
                                    lugares   : results.lugar
                                    all       : results.all
                                })


# CREATION PAGES
router.route '/create' 
    .get user.isAuthenticated, (req, res, next) ->
        
        res.render 'creation/index',
            title   : 'Creation - ToleranceIn'
            pageName: 'Creation'
            user    : req.user

    # .post user.isAuthenticated, (req,res,next)->

    #     console.log req.body
        

    #     new_product = new product({
    #         nombre      : req.body.name
    #         description : req.body.description
    #         recomendado : req.body.recomended
    #         norecomendado: req.body.notrecomended
    #         etiquetas   : req.body.tags.split(',') 
    #         tipo        : req.body.tipo 
    #     })

    #     new_product.save( (err, new_product)->
    #         if err 
    #             console.log err
    #             res.status(500).send( err.message)

    #         res.render 'creation/index',
    #             title   : 'Express'
    #             pageName: 'Creation'
    #             user    : req.user 
    #     )

module.exports = router
