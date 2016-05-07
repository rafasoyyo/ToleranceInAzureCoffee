
###
# Node models
# @namespace Node.models
# @module comentario
# @see rafa
###

mongoose = require 'mongoose'
Schema   = mongoose.Schema

###
# afeccionModel
# @memberOf comentario
# @method comentarioSchema
###
comentarioSchema = new Schema({
                                autor  : { type : Schema.ObjectId, ref: 'user', default: "572e3471124d12207cae6246" }
                                mensaje: { type : String }
                                created: { type : Date   }
                    })

module.exports = comentarioSchema