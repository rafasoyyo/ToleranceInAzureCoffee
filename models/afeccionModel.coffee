
###
# Node models
# @namespace Node.models
# @module afeccion
# @see rafa
###

mongoose = require 'mongoose'
Schema   = mongoose.Schema
comentarioSchema = require './commentModel'

###
# afeccionModel
# @memberOf afeccion
# @method afeccionSchema
###
afeccionSchema = new Schema({
                            # index     : { unique : true }
                            clase       : { type : String, default: "afeccion" }
                            nombre      : { type : String, unique : true, required: true}
                            url         : { type : String, unique : true, required: true}
                            descripcion : { type : String }
                            sintomas    : { type : String }
                            enlace      : { type : String }
                            organismo   : { type : String }
                            tipo        : { type : String }
                            image       : { type : String }
                            validado    : { type : Boolean, default: false}
                            visitas     : { type : Number , min: 0, default: 0 }
                            revisor     : { type : Schema.ObjectId, ref: 'user'}
                            autor       : { type : Schema.ObjectId, ref: 'user', default: '57042cdb9302bc86384b3f57'}
                            comentarios : [ comentarioSchema ]
                }, {timestamps: true})


###
# afeccionModel
# @memberOf afeccion
# @method afeccionModel
###
afeccionModel = mongoose.model('afeccion', afeccionSchema)

module.exports = afeccionModel