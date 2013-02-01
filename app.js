var express = require('express'),
  app = express.createServer(),
  mongodb = require('mongodb'),
  mongoServer = new mongodb.Server('localhost', mongodb.Connection.DEFAULT_PORT),
  dbConn = new mongodb.Db('tux', mongoServer),
  ObjectID = mongodb.ObjectID,
  collections = {};

app.use(express.bodyParser());
app.use(express.static('public'));

dbConn.open(function(err, db) {
  if (err) {
    throw err;
  }
  console.log('- db connection open');

  app.all('/models/:coll*', function(req, res, next) {
    var coll = req.params.coll;
    if (!collections[coll]) {
      db.collection(coll, function(err, collObj) {
        if (err) {
          return next(err);
        }
        req.coll = collections[coll] = collObj;
        next();
      });
    } else {
      req.coll = collections[coll];
      next();
    }
  });

  app.post('/models/:coll', function(req, res, next) {
    req.coll.insert(req.body, function(err, doc) {
      if (err) {
        return next(err);
      }
      res.send(doc[0]);
    })
  });

  app.get('/models/:coll', function(req, res, next) {
    req.coll.find({}).toArray(function(err, docs) {
      if (err) {
        return next(err);
      }
      res.send(docs);
    });
  });

  app.del('/models/:coll/:id', function(req, res, next) {
    req.coll.remove({'_id': ObjectID.createFromHexString(req.params.id)}, function(err) {
      if (err) {
        return next(err);
      }
      res.send(200, '');
    });
  });

  app.post('/models/:coll/:id', function(req, res, next) {
    delete req.body._id;
    req.coll.update({'_id': ObjectID.createFromHexString(req.params.id)}, {$set: req.body}, function(err) {
      if (err) {
        return next(err);
      }
      res.send(200, '');
    });
  });

  app.listen(3000, function() {
    console.log('- listening on port 3000');
  });

});

