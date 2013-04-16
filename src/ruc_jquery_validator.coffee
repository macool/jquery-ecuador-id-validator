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
      else if tercer_digito <= 6 then @tipo_de_cedula = "Persona natural"

      productos = []

      # para personas naturales:
      if tercer_digito < 6
        p = 2
        for i in @numero
          producto = parseInt(i) * p
          if producto >= 10 then producto -= 9
          productos.push producto
          if p == 2 then p = 1 else p = 2
      console.log productos

      this

    isValid: ->
      @validate() unless @already_validated
      @valid

  window.RucValidatorEc = RucValidatorEc     # only for testing

  class jQueryRucValidatorEc
    constructor: ( @$node, @options ) ->
      @$node.on @options.events, @validateContent

    validateContent: =>
      if new RucValidatorEc(@$node.val().toString()).isValid()
        console.log "valid."
      else
        @$node.addClass("invalid")
      null

      
      

  $.fn.validarCedulaEC = ( options ) ->
    options = $.extend({}, $.fn.validarCedulaEC.defaults, options)
    this.each ->
      new jQueryRucValidatorEc( $(this), options )
    this

  $.fn.validarCedulaEC.defaults =
    events: "change"
    onValid: ->
      null
    onInvalid: ->
      null

  

)(jQuery)
