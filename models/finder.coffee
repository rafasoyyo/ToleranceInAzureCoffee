_ = require 'lodash' 
async   = require 'async'

user  = require './userModel'
lugar = require './lugarModel'
afeccion = require './afeccionModel'
producto = require './productoModel'

module.exports = 
    find_all_items : (callback)->
        async.parallel([
                (cb)-> producto.find({}, null,  {limit: 100, sort: {'visitas': 1}}).populate('autor').exec(cb)
                (cb)-> afeccion.find({}, null,  {limit: 100, sort: {'visitas': 1}}).populate('autor').exec(cb)
                (cb)-> lugar.find({}, null,     {limit: 100, sort: {'visitas': 1}}).populate('autor').exec(cb)
            ], 
            (err, results)-> 
                callback(err, { 
                                producto: results[0], 
                                afeccion: results[1], 
                                lugar: results[2], 
                                all: _.sortBy(_.compact(_.concat(results[0], results[1], results[2]), ['visitas']))
                            })
        )

    filter_all_items : (param, callback)->
        
        regex = new RegExp(param, "i")
        filter = { $or: [{nombre: regex}, {descripcion: regex}, {recomendado: regex}, {norecomendado: regex}, {etiquetas: regex}] }
        async.parallel([
                (cb)-> producto.find(filter, null,  {limit: 100, sort: {'visitas': 1}}).populate('autor').exec(cb)
                (cb)-> afeccion.find(filter, null,  {limit: 100, sort: {'visitas': 1}}).populate('autor').exec(cb)
                (cb)-> lugar.find(filter, null,     {limit: 100, sort: {'visitas': 1}}).populate('autor').exec(cb)
            ], 
            (err, results)-> 
                callback(err, { 
                                producto: results[0], 
                                afeccion: results[1], 
                                lugar: results[2], 
                                all: _.sortBy(_.compact(_.concat(results[0], results[1], results[2]), ['visitas']))
                            })
        )
        
    find_user_items : (user_id, callback)->

        user.findById user_id, (err, result)->
            opts = [
                    { path: 'lugares',      options: { limit: 100 , sort: {'visitas': 1}} }
                    { path: 'productos',    options: { limit: 100 , sort: {'visitas': 1}} }
                    { path: 'afecciones',   options: { limit: 100 , sort: {'visitas': 1}} }
            ]
            user.populate(result, opts, (err, results)->
                if err then return callback(err, null)
                return callback(null, _.sortBy(_.compact(_.concat(results.lugares, results.productos, results.afecciones ), ['visitas'])))
            )


    find_user_favs : (user_id, callback)->
        
        user.findById user_id, (err, result)->
            opts = [
                    { path: 'lugareFAV', options: { limit: 100 } },
                    { path: 'productoFAV', options: { limit: 100 } }
                    { path: 'afeccioneFAV', options: { limit: 100 } }
            ]
            user.populate(result, opts, (err, results)->
                if err then return callback(err, null)
                console.log result
                return callback(null, _.sortBy(_.compact(_.concat(results.lugarFAV, results.productoFAV, results.afeccionFAV ), ['visitas'])))
            )