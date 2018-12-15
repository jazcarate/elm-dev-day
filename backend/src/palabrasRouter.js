var express = require('express');
var router = express.Router();

var delay = process.env.DELAY || 0

const sample = (array) => array[Math.floor(Math.random() * array.length)]

const palabraRandom = () => sample(["Rascarse", "Panal", "Grabar", "Mundo", "Celda", "Espalda", "Corriente", "Boomerang", "Disparo", "Oliva" ])

router.get('/', function(req, res, next) {
  setTimeout(() => {
    res.send({ palabra: palabraRandom() });
  }, delay);
});

module.exports = router;
