describe "load dependences", ->
  it "should have already loaded jQuery 1.9.1 in $", ->
    expect($.fn.jquery).toEqual "1.9.1"

  it "should have loaded validarCedulaEC in $.fn", ->
    expect($.fn.validarCedulaEC).toBeDefined()

describe "RUC jQuery Validator Plugin", ->
  cedulaValida = 1104680135
  cedulaInvalida = 1104680134

  beforeEach ->
    window.RucValidatorEc = $.fn.validarCedulaEC.RucValidatorEc

  describe "Class methods", ->
    it "should say province code is invalid", ->
      expect ->
        new RucValidatorEc("2304680135").isValid()
      .toThrow("Código de provincia incorrecto.")
      expect ->
        new RucValidatorEc("-204680135").isValid()
      .toThrow("Código de provincia incorrecto.")

    it "should say third digit is invalid as 7 and 8 are not allowed", ->
      expect ->
        new RucValidatorEc("1174680135").isValid()
      .toThrow("Tercer dígito es inválido.")
      expect ->
        new RucValidatorEc("1184680135").isValid()
      .toThrow("Tercer dígito es inválido.")

    describe "tipo de cédula", ->
      it "should say its Persona natural", ->
        expect(new RucValidatorEc("1104680135").validate().tipo_de_cedula)
          .toBe("Persona natural")

      it "should say its Sociedad pública", ->
        expect(new RucValidatorEc("1164680130001").validate().tipo_de_cedula)
          .toBe("Sociedad pública")

      it "should say its Sociedad privada o extranjera", ->
        expect(new RucValidatorEc("1194680135001").validate().tipo_de_cedula)
          .toBe("Sociedad privada o extranjera")

    describe "con cédulas", ->
      it "should say cedula is valid", ->
        expect(new RucValidatorEc(cedulaValida).validate().isValid())
          .toBeTruthy

      it "should say cedula is invalid", ->
        expect(new RucValidatorEc(cedulaInvalida).validate().isValid())
          .toBeFalsy

      it "should validate @calu 's CI", ->
        expect(new RucValidatorEc("1102778014").isValid()).toBeTruthy

      it "testing some friend's CIs", ->
        validCIs = [
          "1104077209",
          "1102077425",
          "1102019351"
        ]
        for ci in validCIs
          expect(new RucValidatorEc(ci).isValid()).toBeTruthy



  describe "DOM behavior", ->
    $input = null

    beforeEach ->
      $input = $("<input />", {type: "text"})

    it "should say it's valid when the input's CI is valid", ->
      $input.validarCedulaEC()
      $input.val(cedulaValida).trigger("change")
      expect($input).not.toHaveClass("invalid")

    it "should say it's invalid when the input's CI is invalid", ->
      $input.validarCedulaEC()
      $input.val(cedulaInvalida).trigger("change")
      expect($input).toHaveClass("invalid")

    it "should say it's invalid when the input's CI is too short", ->
      $input.validarCedulaEC()
      $input.val("1234").trigger("change")
      expect($input).toHaveClass("invalid")

    it "should say it's invalid when the input's CI is 11 characters long", ->
      $input.validarCedulaEC()
      $input.val(cedulaValida.toString() + "1").trigger("change")
      expect($input).toHaveClass("invalid")

    it "should say it's invalid when the input's CI is 14 characters long", ->
      $input.validarCedulaEC()
      $input.val(cedulaValida.toString() + "0012").trigger("change")
      expect($input).toHaveClass("invalid")

    describe "options", ->
      it "should validate always because strict is enabled by default", ->
        $input.validarCedulaEC()
        $input.val("1").trigger("change")
        expect($input).toHaveClass("invalid")

      it "should not validate because strict is disabled", ->
        $input.validarCedulaEC({ strict: false })
        $input.val("110468013").trigger("change")
        expect($input).not.toHaveClass("invalid")

      it "should add a class of no-valid if specified", ->
        $input.validarCedulaEC({ the_classes: "no-valid" })
        $input.val(cedulaInvalida).trigger("change")
        expect($input).toHaveClass("no-valid")

      it "should listen for an event of blur instead of change", ->
        $input.validarCedulaEC({ events: "blur" })
        $input.val(cedulaInvalida).trigger("change")
        expect($input).not.toHaveClass("invalid")
        $input.trigger "blur"
        expect($input).toHaveClass("invalid")

    describe "callbacks", ->
      callback_return = null

      beforeEach ->
        @callback_fn = ->
          callback_return = @

        spyOn(@, "callback_fn").andCallThrough()

      it "should fire a callback when CI is valid", ->
        $input.validarCedulaEC({ onValid: @callback_fn })
        $input.val(cedulaValida).trigger("change")
        expect(@callback_fn).toHaveBeenCalled

      it "should fire a callback when CI is invalid", ->
        $input.validarCedulaEC({ onInvalid: @callback_fn })
        $input.val(cedulaInvalida).trigger("change")
        expect(@callback_fn).toHaveBeenCalled

      it "should bind the jQuery object to the valid callback fn", ->
        $input.validarCedulaEC({ onValid: @callback_fn })
        $input.val(cedulaValida).trigger("change")
        expect(callback_return[0]).toBe $input[0]

      it "should bind the jQuery object to the invalid callback fn", ->
        $input.validarCedulaEC({ onInvalid: @callback_fn })
        $input.val(cedulaInvalida).trigger("change")
        expect(callback_return[0]).toBe $input[0]
