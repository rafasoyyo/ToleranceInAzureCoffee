express  = require 'express'
router   = express.Router()

product  = require '../models/productoModel'


# CREATION PAGES
router.route '/' 
    .post product.filter , (req, res, next) ->
        if req.producto.err
            return res.status(500).json(req.producto.err)
        res.status(200).json(req.producto.result)


module.exports = router