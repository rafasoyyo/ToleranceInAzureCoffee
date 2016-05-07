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
                            autor       : { type : Schema.ObjectId, ref: 'user', default: "571d3e6ce83b3f8f15ed61aa" }
                            comentarios : [ comentarioSchema ]
                }, {timestamps: true})


lugarModel = mongoose.model('lugar', lugarSchema)

module.exports = lugarModel