(($) ->

  class RucValidatorEc
    constructor: ( @numero ) ->
      @numero = @numero.toString()
      @valid = false
      @codigo_provincia = null
      @tipo_de_cedula = null
      @already_validated = false

    validate: ->
      unless @numero.length is 10 or @numero.length is 13
        @valid = false

      # código de provincia:
      provincias = 22
      @codigo_provincia = parseInt @numero.substr(0,2)
      if @codigo_provincia < 1 or @codigo_provincia > provincias
        @valid = false
        throw new Error("Código de provincia incorrecto.")

      # tercer digito:
      #     9    -> sociedades privadas o extranjeras
      #     6    -> sociedades publicas
      #     0..6 -> personas naturales
      tercer_digito = parseInt @numero[2]
      if tercer_digito is 7 or tercer_digito is 8
        throw new Error("Tercer dígito es inválido.")
      if tercer_digito is 9 then @tipo_de_cedula = "Sociedad privada o extranjera"
      else if tercer_digito is 6 then @tipo_de_cedula = "Sociedad pública"
      else if tercer_digito < 6 then @tipo_de_cedula = "Persona natural"

      productos = []

      # para personas naturales:
      if tercer_digito < 6
        modulo = 10
        verificador = parseInt(@numero.substr(9,1))
        p = 2
        for i in @numero.substr(0,9)
          producto = parseInt(i) * p
          if producto >= 10 then producto -= 9
          productos.push producto
          if p == 2 then p = 1 else p = 2

      # para sociedades públicas:
      if tercer_digito is 6
        verificador = parseInt(@numero.substr(8,1))
        modulo = 11
        multiplicadores = [ 3, 2, 7, 6, 5, 4, 3, 2 ]
        for i in [0..7]
          productos[i] = parseInt(@numero[i]) * multiplicadores[i]
        productos[8] = 0

      # para entidades privadas:
      if tercer_digito is 9
        verificador = parseInt(@numero.substr(9,1))
        modulo = 11
        multiplicadores = [ 4, 3, 2, 7, 6,5, 4, 3, 2 ]
        for i in [0..8]
          productos[i] = parseInt(@numero[i]) * multiplicadores[i]

      suma = 0
      for i in productos
        suma += i
      residuo = suma % modulo
      digito_verificador = if residuo is 0 then 0 else modulo - residuo

      # sociedades públicas:
      if tercer_digito is 6
        if @numero.substr(9,4) isnt "0001"
          throw new Error("RUC de empresa del sector público debe terminar en 0001")
        if digito_verificador is verificador
          @valid = true
        else
          @valid = false

      # entidades privadas:
      if tercer_digito is 9
        if @numero.substr(10,3) isnt "001"
          throw new Error("RUC de entidad privada debe terminar en 001")
        if digito_verificador is verificador
          @valid = true
        else
          @valid = false

      # personas naturales:
      if tercer_digito < 6
        if @numero.length > 10 and @numero.substr(10,3) isnt "001"
          throw new Error("RUC de persona natural debe terminar en 001")
        if digito_verificador is verificador
          @valid = true
        else
          @valid = false
      this

    isValid: ->
      @validate() unless @already_validated
      @valid

  window.RucValidatorEc = RucValidatorEc     # uncomment only for testing

  class jQueryRucValidatorEc
    constructor: ( @$node, @options ) ->
      @options = $.extend({}, $.fn.validarCedulaEC.defaults, @options)
      @$node.on @options.events, @validateContent

    validateContent: =>
      numero_de_cedula = @$node.val().toString()
      check = not @options.strict
      if @options.strict and numero_de_cedula.length is 10 or numero_de_cedula.length is 13
        check = true
      if check and new RucValidatorEc(numero_de_cedula).isValid()
        @$node.removeClass @options.the_classes
        @options.onValid.call @$node
      else
        @$node.addClass @options.the_classes
        @options.onInvalid.call @$node
      null

      
      

  $.fn.validarCedulaEC = ( options ) ->
    this.each ->
      new jQueryRucValidatorEc( $(this), options )
    this

  $.fn.validarCedulaEC.defaults =
    strict: true
    events: "change"
    the_classes: "invalid"
    onValid: ->
      null
    onInvalid: ->
      null

  

)(jQuery)
