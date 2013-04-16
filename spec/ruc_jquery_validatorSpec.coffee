describe "load dependences", ->

  it "should have already loaded jQuery 1.9.1 in $", ->
    expect($.fn.jquery).toEqual "1.9.1"

  it "should have loaded validarCedulaEC in $.fn", ->
    expect($.fn.validarCedulaEC).toBeDefined()



describe "ruc jquery validator plugin", ->

  describe "DOM behavior", ->

    $input = null

    beforeEach ->
      $input = $("input", {type: "text"})

    it "should create an input node, fill it with a valid RUC number and apply the method"

