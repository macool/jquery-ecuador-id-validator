describe "load dependences", ->

  it "should have already loaded jQuery 1.9.1 in $", ->
    expect($.fn.jquery).toEqual "1.9.1"

  it "should have loaded validarCedulaEC in $.fn", ->
    expect($.fn.validarCedulaEC).toBeDefined()



describe "ruc jquery validator plugin", ->

  describe "DOM behavior", ->

    $input = null
    cedulaValida = 1104680135
    cedulaInvalida = 1104680134

    beforeEach ->
      $input = $("<input />", {type: "text"})

    it "should fill the input node with a valid CI number and say it's valid.", ->
      $input.validarCedulaEC( {a:"b"} )
      $input.val cedulaValida
      $input.trigger "change"
      expect($input.hasClass("invalid")).toBeFalsy()

    it "should fill the input node with an invalid CI number and say it's invalid.", ->
      $input.validarCedulaEC()
      $input.val cedulaInvalida
      $input.trigger "change"
      expect($input.hasClass("invalid")).toBeTruthy()

