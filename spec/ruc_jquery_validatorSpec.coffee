describe "load dependences", ->

  it "should have already loaded jQuery 1.9.1 in $", ->
    expect($.fn.jquery).toEqual "1.9.1"

  it "should have loaded validarCedulaEC in $.fn", ->
    expect($.fn.validarCedulaEC).toBeDefined()



describe "Ruc jQuery Validator Plugin", ->

  cedulaValida = 1104680135
  cedulaInvalida = 1104680134

  describe "Class methods", ->
    
    it "should say province code is invalid", ->
      expect ->
        new RucValidatorEc("2304680135").isValid()
      .toThrow("Código de provincia incorrecto.")
      expect ->
        new RucValidatorEc("-204680135").isValid()
      .toThrow("Código de provincia incorrecto.")

    it "should say third digit is invalid", ->
      expect ->
        new RucValidatorEc("1174680135").isValid()
      .toThrow("Tercer dígito es inválido.")
      expect ->
        new RucValidatorEc("1184680135").isValid()
      .toThrow("Tercer dígito es inválido.")

    describe "tipo de cédula", ->

      it "should say its Persona natural", ->
        expect(new RucValidatorEc("1104680135").validate().tipo_de_cedula).toBe("Persona natural")

      it "should say its Sociedad pública", ->
        expect(new RucValidatorEc("1164680135").validate().tipo_de_cedula).toBe("Sociedad pública")

      it "should say its Sociedad privada o extranjera", ->
        expect(new RucValidatorEc("1194680135").validate().tipo_de_cedula).toBe("Sociedad privada o extranjera")



  describe "DOM behavior", ->

    $input = null

    beforeEach ->
      $input = $("<input />", {type: "text"})

    it "should fill the input node with a valid CI number and say it's valid", ->
      $input.validarCedulaEC( {a:"b"} )
      $input.val cedulaValida
      $input.trigger "change"
      # expect($input.hasClass("invalid")).toBeFalsy()

    it "should fill the input node with an invalid CI number and say it's invalid", ->
      $input.validarCedulaEC()
      $input.val cedulaInvalida
      $input.trigger "change"
      # expect($input.hasClass("invalid")).toBeTruthy()

