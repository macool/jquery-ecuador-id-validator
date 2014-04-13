(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  (function($) {
    var RucValidatorEc, jQueryRucValidatorEc;
    RucValidatorEc = (function() {
      function RucValidatorEc(numero) {
        this.numero = numero;
        this.numero = this.numero.toString();
        this.valid = false;
        this.codigo_provincia = null;
        this.tipo_de_cedula = null;
        this.already_validated = false;
      }

      RucValidatorEc.prototype.validate = function() {
        var digito_verificador, i, modulo, multiplicadores, p, producto, productos, provincias, residuo, suma, tercer_digito, verificador, _i, _j, _k, _l, _len, _len1, _ref, _ref1;
        if ((_ref = this.numero.length) !== 10 && _ref !== 13) {
          this.valid = false;
          throw new Error("Longitud incorrecta.");
        }
        provincias = 22;
        this.codigo_provincia = parseInt(this.numero.substr(0, 2), 10);
        if (this.codigo_provincia < 1 || this.codigo_provincia > provincias) {
          this.valid = false;
          throw new Error("Código de provincia incorrecto.");
        }
        tercer_digito = parseInt(this.numero[2], 10);
        if (tercer_digito === 7 || tercer_digito === 8) {
          throw new Error("Tercer dígito es inválido.");
        }
        if (tercer_digito === 9) {
          this.tipo_de_cedula = "Sociedad privada o extranjera";
        } else if (tercer_digito === 6) {
          this.tipo_de_cedula = "Sociedad pública";
        } else if (tercer_digito < 6) {
          this.tipo_de_cedula = "Persona natural";
        }
        productos = [];
        if (tercer_digito < 6) {
          modulo = 10;
          verificador = parseInt(this.numero.substr(9, 1), 10);
          p = 2;
          _ref1 = this.numero.substr(0, 9);
          for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
            i = _ref1[_i];
            producto = parseInt(i, 10) * p;
            if (producto >= 10) {
              producto -= 9;
            }
            productos.push(producto);
            if (p === 2) {
              p = 1;
            } else {
              p = 2;
            }
          }
        }
        if (tercer_digito === 6) {
          verificador = parseInt(this.numero.substr(8, 1), 10);
          modulo = 11;
          multiplicadores = [3, 2, 7, 6, 5, 4, 3, 2];
          for (i = _j = 0; _j <= 7; i = ++_j) {
            productos[i] = parseInt(this.numero[i], 10) * multiplicadores[i];
          }
          productos[8] = 0;
        }
        if (tercer_digito === 9) {
          verificador = parseInt(this.numero.substr(9, 1), 10);
          modulo = 11;
          multiplicadores = [4, 3, 2, 7, 6, 5, 4, 3, 2];
          for (i = _k = 0; _k <= 8; i = ++_k) {
            productos[i] = parseInt(this.numero[i], 10) * multiplicadores[i];
          }
        }
        suma = 0;
        for (_l = 0, _len1 = productos.length; _l < _len1; _l++) {
          i = productos[_l];
          suma += i;
        }
        residuo = suma % modulo;
        digito_verificador = residuo === 0 ? 0 : modulo - residuo;
        if (tercer_digito === 6) {
          if (this.numero.substr(9, 4) !== "0001") {
            throw new Error("RUC de empresa del sector público debe terminar en 0001");
          }
          this.valid = digito_verificador === verificador;
        }
        if (tercer_digito === 9) {
          if (this.numero.substr(10, 3) !== "001") {
            throw new Error("RUC de entidad privada debe terminar en 001");
          }
          this.valid = digito_verificador === verificador;
        }
        if (tercer_digito < 6) {
          if (this.numero.length > 10 && this.numero.substr(10, 3) !== "001") {
            throw new Error("RUC de persona natural debe terminar en 001");
          }
          this.valid = digito_verificador === verificador;
        }
        return this;
      };

      RucValidatorEc.prototype.isValid = function() {
        if (!this.already_validated) {
          this.validate();
        }
        return this.valid;
      };

      return RucValidatorEc;

    })();
    jQueryRucValidatorEc = (function() {
      function jQueryRucValidatorEc($node, options) {
        this.$node = $node;
        this.options = options;
        this.validateContent = __bind(this.validateContent, this);
        this.options = $.extend({}, $.fn.validarCedulaEC.defaults, this.options);
        this.$node.on(this.options.events, this.validateContent);
      }

      jQueryRucValidatorEc.prototype.validateContent = function() {
        var check, error, numero_de_cedula, _ref;
        numero_de_cedula = this.$node.val().toString();
        check = this.options.strict;
        if (!check && ((_ref = numero_de_cedula.length) === 10 || _ref === 13)) {
          check = true;
        }
        if (check) {
          try {
            if (new RucValidatorEc(numero_de_cedula).isValid()) {
              this.$node.removeClass(this.options.the_classes);
              this.options.onValid.call(this.$node);
            } else {
              this.$node.addClass(this.options.the_classes);
              this.options.onInvalid.call(this.$node);
            }
          } catch (_error) {
            error = _error;
            this.$node.addClass(this.options.the_classes);
            this.options.onInvalid.call(this.$node);
          }
        }
        return null;
      };

      return jQueryRucValidatorEc;

    })();
    $.fn.validarCedulaEC = function(options) {
      this.each(function() {
        return new jQueryRucValidatorEc($(this), options);
      });
      return this;
    };
    $.fn.validarCedulaEC.RucValidatorEc = RucValidatorEc;
    return $.fn.validarCedulaEC.defaults = {
      strict: true,
      events: "change",
      the_classes: "invalid",
      onValid: function() {
        return null;
      },
      onInvalid: function() {
        return null;
      }
    };
  })(jQuery);

}).call(this);
