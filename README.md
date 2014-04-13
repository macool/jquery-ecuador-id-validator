# jQuery plugin para validar cédula o RUC de Ecuador

plugin para jQuery para validar la cédula o RUC de Ecuador.

****

[![Build Status](https://travis-ci.org/macool/jquery-ecuador-id-validator.png?branch=master)](https://travis-ci.org/macool/jquery-ecuador-id-validator)
[![Code Climate](https://codeclimate.com/github/macool/jquery-ecuador-id-validator.png)](https://codeclimate.com/github/macool/jquery-ecuador-id-validator)

## Cómo usar

1. jQuery `<script src='jquery.js'></script>`
2. librería JavaScript: `<script src='dist/ruc_jquery_validator.min.js'></script>`
3. seleccionar un input y aplicar el plugin:

```javascript
$("input").validarCedulaEC();
```
*Ha sido probado con jQuery 1.9.1, pero estoy casi seguro de que correrá con muchas versiones anteriores.*

## Qué hará

1. Validará el número de cédula ingresado en el input (cuando tenga 10 o 13 caracteres) al momento de dispararse un evento (por defecto change)
2. Agregará una clase al nodo del input en caso de haber una cédula incorrecta (se puede especificar qué clase agregar)
3. Tiene dos callbacks: cuando la cédula es válida y cuando es inválida. Dentro de estas funciones, `this` es el objeto jQuery en el que se disparó la validación

## Opciones y Callbacks

```javascript
var opciones = {
  strict: true,              // va a validar siempre, aunque la cantidad de caracteres no sea 10 ni 13
  events: "change",          // evento que va a disparar la validación
  the_classes: "invalid",    // clase que se va a agregar al nodo en el que se realiza la validación
  onValid: function () {},   // callback cuando la cédula es correcta.
  onInvalid: function () {}  // callback cuando la cédula es incorrecta.
};
$("input").validarCedulaEC(opciones);
```
*Dentro del contexto de las funciones anónimas del callback, `this` es un objeto javascript que referencia al nodo en el que se acaba de disparar el evento.*


## Contribuir

He utilizado [jasmine](https://github.com/pivotal/jasmine) para el testing, y está escrito en [coffeescript](http://coffeescript.org/).

## Ejemplos

Dentro de la carpeta *examples*
