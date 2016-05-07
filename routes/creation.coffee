# express  = require 'express'
# router   = express.Router()

# mongoose = require 'mongoose'
# product = require '../models/productoModel'
# user  = require '../models/userModel'

# # CREATION PAGES
# router.route '/' 
#     .get user.isAuthenticated, (req, res, next) ->
        
#         res.render 'creation/index',
#             title   : 'Express'
#             pageName: 'Creation'
#             user    : req.user

#     .post user.isAuthenticated, (req,res,next)->

#         console.log req.body
        

#         new_product = new product({
#             nombre      : req.body.name
#             description : req.body.description
#             recomendado : req.body.recomended
#             norecomendado: req.body.notrecomended
#             etiquetas   : req.body.tags.split(',') 
#             tipo        : req.body.tipo 
#         })

#         new_product.save( (err, new_product)->
#             if err 
#                 console.log err
#                 res.status(500).send( err.message)

#             res.render 'creation/index',
#                 title   : 'Express'
#                 pageName: 'Creation'
#                 user    : req.user 
#         )
    


# module.exports = router
