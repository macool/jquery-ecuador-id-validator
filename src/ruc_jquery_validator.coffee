(($) ->

  class RucValidatorEc
    constructor: ( @$node, @options ) ->
      @$node.on "change", @validateContent

    validateCI: ( ci ) ->


    validateContent: =>
      console.log @$node
      value = @$node.val().toString()
      length = value.length
      if length is 10 or length is 13
        
      

  $.fn.validarCedulaEC = ( options ) ->
    options = $.extend({}, $.fn.validarCedulaEC.defaults, options)
    this.each ->
      new RucValidatorEc( $(this), options )
    this

  $.fn.validarCedulaEC.defaults =
    onValid: ->
      null
    onInvalid: ->
      null

  

)(jQuery)
