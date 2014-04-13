(function() {
  describe("load dependences", function() {
    it("should have already loaded jQuery 1.9.1 in $", function() {
      return expect($.fn.jquery).toEqual("1.9.1");
    });
    return it("should have loaded validarCedulaEC in $.fn", function() {
      return expect($.fn.validarCedulaEC).toBeDefined();
    });
  });

  describe("RUC jQuery Validator Plugin", function() {
    var cedulaInvalida, cedulaValida;
    cedulaValida = 1104680135;
    cedulaInvalida = 1104680134;
    beforeEach(function() {
      return window.RucValidatorEc = $.fn.validarCedulaEC.RucValidatorEc;
    });
    describe("Class methods", function() {
      it("should say province code is invalid", function() {
        expect(function() {
          return new RucValidatorEc("2304680135").isValid();
        }).toThrow("Código de provincia incorrecto.");
        return expect(function() {
          return new RucValidatorEc("-204680135").isValid();
        }).toThrow("Código de provincia incorrecto.");
      });
      it("should say third digit is invalid as 7 and 8 are not allowed", function() {
        expect(function() {
          return new RucValidatorEc("1174680135").isValid();
        }).toThrow("Tercer dígito es inválido.");
        return expect(function() {
          return new RucValidatorEc("1184680135").isValid();
        }).toThrow("Tercer dígito es inválido.");
      });
      describe("tipo de cédula", function() {
        it("should say its Persona natural", function() {
          return expect(new RucValidatorEc("1104680135").validate().tipo_de_cedula).toBe("Persona natural");
        });
        it("should say its Sociedad pública", function() {
          return expect(new RucValidatorEc("1164680130001").validate().tipo_de_cedula).toBe("Sociedad pública");
        });
        return it("should say its Sociedad privada o extranjera", function() {
          return expect(new RucValidatorEc("1194680135001").validate().tipo_de_cedula).toBe("Sociedad privada o extranjera");
        });
      });
      return describe("con cédulas", function() {
        it("should say cedula is valid", function() {
          return expect(new RucValidatorEc(cedulaValida).validate().isValid()).toBeTruthy;
        });
        it("should say cedula is invalid", function() {
          return expect(new RucValidatorEc(cedulaInvalida).validate().isValid()).toBeFalsy;
        });
        it("should validate @calu 's CI", function() {
          return expect(new RucValidatorEc("1102778014").isValid()).toBeTruthy;
        });
        return it("testing some friend's CIs", function() {
          var ci, validCIs, _i, _len, _results;
          validCIs = ["1104077209", "1102077425", "1102019351"];
          _results = [];
          for (_i = 0, _len = validCIs.length; _i < _len; _i++) {
            ci = validCIs[_i];
            _results.push(expect(new RucValidatorEc(ci).isValid()).toBeTruthy);
          }
          return _results;
        });
      });
    });
    return describe("DOM behavior", function() {
      var $input;
      $input = null;
      beforeEach(function() {
        return $input = $("<input />", {
          type: "text"
        });
      });
      it("should say it's valid when the input's CI is valid", function() {
        $input.validarCedulaEC();
        $input.val(cedulaValida).trigger("change");
        return expect($input).not.toHaveClass("invalid");
      });
      it("should say it's invalid when the input's CI is invalid", function() {
        $input.validarCedulaEC();
        $input.val(cedulaInvalida).trigger("change");
        return expect($input).toHaveClass("invalid");
      });
      it("should say it's invalid when the input's CI is too short", function() {
        $input.validarCedulaEC();
        $input.val("1234").trigger("change");
        return expect($input).toHaveClass("invalid");
      });
      it("should say it's invalid when the input's CI is 11 characters long", function() {
        $input.validarCedulaEC();
        $input.val(cedulaValida.toString() + "1").trigger("change");
        return expect($input).toHaveClass("invalid");
      });
      it("should say it's invalid when the input's CI is 14 characters long", function() {
        $input.validarCedulaEC();
        $input.val(cedulaValida.toString() + "0012").trigger("change");
        return expect($input).toHaveClass("invalid");
      });
      describe("options", function() {
        it("should validate always because strict is enabled by default", function() {
          $input.validarCedulaEC();
          $input.val("1").trigger("change");
          return expect($input).toHaveClass("invalid");
        });
        it("should not validate because strict is disabled", function() {
          $input.validarCedulaEC({
            strict: false
          });
          $input.val("110468013").trigger("change");
          return expect($input).not.toHaveClass("invalid");
        });
        it("should add a class of no-valid if specified", function() {
          $input.validarCedulaEC({
            the_classes: "no-valid"
          });
          $input.val(cedulaInvalida).trigger("change");
          return expect($input).toHaveClass("no-valid");
        });
        return it("should listen for an event of blur instead of change", function() {
          $input.validarCedulaEC({
            events: "blur"
          });
          $input.val(cedulaInvalida).trigger("change");
          expect($input).not.toHaveClass("invalid");
          $input.trigger("blur");
          return expect($input).toHaveClass("invalid");
        });
      });
      return describe("callbacks", function() {
        var callback_return;
        callback_return = null;
        beforeEach(function() {
          this.callback_fn = function() {
            return callback_return = this;
          };
          return spyOn(this, "callback_fn").andCallThrough();
        });
        it("should fire a callback when CI is valid", function() {
          $input.validarCedulaEC({
            onValid: this.callback_fn
          });
          $input.val(cedulaValida).trigger("change");
          return expect(this.callback_fn).toHaveBeenCalled;
        });
        it("should fire a callback when CI is invalid", function() {
          $input.validarCedulaEC({
            onInvalid: this.callback_fn
          });
          $input.val(cedulaInvalida).trigger("change");
          return expect(this.callback_fn).toHaveBeenCalled;
        });
        it("should bind the jQuery object to the valid callback fn", function() {
          $input.validarCedulaEC({
            onValid: this.callback_fn
          });
          $input.val(cedulaValida).trigger("change");
          return expect(callback_return[0]).toBe($input[0]);
        });
        return it("should bind the jQuery object to the invalid callback fn", function() {
          $input.validarCedulaEC({
            onInvalid: this.callback_fn
          });
          $input.val(cedulaInvalida).trigger("change");
          return expect(callback_return[0]).toBe($input[0]);
        });
      });
    });
  });

}).call(this);
