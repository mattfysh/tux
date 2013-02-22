express = require 'express'
mongodb = require 'mongodb'

PORT = 3000

app = express()
mongoServer = new mongodb.Server 'localhost', mongodb.Connection.DEFAULT_PORT
dbConn = new mongodb.Db 'tux', mongoServer, safe: false
ObjectID = mongodb.ObjectID
collections = {}

app.use express.bodyParser()
app.use express.static 'pub/dist/dev'

dbConn.open (err, db) ->
  throw err if err
  console.log '- db connection open'

  app.all '/models/:coll*', (req, res, next) ->
    coll = req.params.coll
    if collections[coll]
      req.coll = collections[coll]
      next()
    else
      db.collection coll, (err, collObj) ->
        return next(err) if err
        req.coll = collections[coll] = collObj
        next()

  app.post '/models/:coll', (req, res, next) ->
    req.coll.insert req.body, (err, doc) ->
      return next(err) if err
      res.send doc[0]

  app.get '/models/:coll', (req, res, next) ->
    req.coll.find({}).toArray (err, docs) ->
      return next(err) if err
      res.send docs

  app.del '/models/:coll/:id', (req, res, next) ->
    req.coll.remove _id: ObjectID.createFromHexString req.params.id, (err) ->
      return next(err) if err
      res.send 200, ''

  app.post '/models/:coll/:id', (req, res, next) ->
    delete req.body._id
    req.coll.update _id: ObjectID.createFromHexString req.params.id,
      $set: req.body, (err) ->
        return next(err) if err
        res.send 200, ''

  app.listen PORT, ->
    console.log "- listening on port #{PORT}"