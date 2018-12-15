Array.prototype.sample = function () {
  return this[Math.floor(Math.random() * this.length)]
}

function palabraRandom(){
  return ["Rascarse", "Panal", "Grabar", "Mundo", "Celda", "Espalda", "Corriente", "Boomerang", "Disparo", "Oliva" ].sample();
}


const express = require('express')
const app = express()
const port = process.env.PORT || 3000
const host = process.env.HOST || 'localhost'
const delay = process.env.DELAY || 0

const obtenerPalabra = (req, res) => {
  setTimeout(() => res.send({ palabra: palabraRandom() }), delay)
}

app.get('/', obtenerPalabra)
app.get('/backend', obtenerPalabra)

app.listen(port, host, () => console.log(`\{^_^}/ Estoy corriendo en http://${host}:${port}!`))