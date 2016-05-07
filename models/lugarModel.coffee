mongoose = require 'mongoose'
Schema   = mongoose.Schema
comentarioSchema = require './commentModel'

lugarSchema = new Schema({
                            # index     : { unique : true }
                            clase       : { type : String, default: "comercio" }
                            nombre      : { type : String, unique : true, required: true}
                            url         : { type : String, unique : true, required: true}
                            descripcion : { type : String }
                            direccion   : { type : String }
                            telefono    : { type : String }
                            web         : { type : String }
                            especialidad: { type : String }
                            tipo        : { type : String }
                            image       : { type : String }
                            etiquetas   : { type : Array  , trim: true    }
                            validado    : { type : Boolean, default: false}
                            visitas     : { type : Number , min: 0, default: 0 }
                            revisor     : { type : Schema.ObjectId, ref: 'user'}
                            autor       : { type : Schema.ObjectId, ref: 'user', default: "572e3471124d12207cae6246" }
                            comentarios : [ comentarioSchema ]
                }, {timestamps: true})


lugarSchema.post 'init', (result)->
    console.log result
    if result.image and result.image.match('public') isnt null
        result.image = result.image.split('public')[1]

lugarModel = mongoose.model('lugar', lugarSchema)

module.exports = lugarModel