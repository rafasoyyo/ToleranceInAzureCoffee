mongoose = require 'mongoose'
Schema   = mongoose.Schema
comentarioSchema = require './commentModel'

productoSchema = new Schema({
                            # index     : { unique : true }
                            clase       : { type : String, default: "producto" }
                            nombre      : { type : String, unique : true, required: true}
                            url         : { type : String, unique : true, required: true}
                            descripcion : { type : String }
                            tipo        : { type : String }
                            image       : { type : String }
                            recomendado : { type : Object }
                            norecomendado:{ type : Object }
                            etiquetas   : { type : Array  , trim: true    }
                            validado    : { type : Boolean, default: false}
                            visitas     : { type : Number , min: 0, default: 0   }
                            lugar       : { type : Schema.ObjectId, ref: 'lugar' }
                            revisor     : { type : Schema.ObjectId, ref: 'user'  }
                            autor       : { type : Schema.ObjectId, ref: 'user', default: "571d3e6ce83b3f8f15ed61aa" }
                            comentarios : [ comentarioSchema ]
                }, {timestamps: true})


productoSchema.post 'init', (result)->
    if result.image and result.image.match('public') isnt null
        result.image = result.image.split('public')[1]


productoModel = mongoose.model('producto', productoSchema)

module.exports = productoModel

productoModel.filter = (req, res, next)->
    productoModel.find({nombre: req.body.search}, (err, result)->
                if err then req.producto = {err : err, result: null}
                else req.producto = {err: null, result: result}
                next()
            )

productoModel.verified = (req, res, next)->
    productoModel.find({ validado : true }, (err, result)->
                if err then req.producto = {err : err, result: null}
                else req.producto = {err: null, result: result}
                next()
            )

productoModel.All = (req, res, next)->
    productoModel.find((err, result)->
                if err then req.producto = {err : err, result: null}
                else req.producto = {err: null, result: result}
                next()
            )