# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular "dia", "dias"
  inflect.irregular "permiso_vehicular", "permisos_vehiculares"
  inflect.irregular "documento_de_identidad", "documentos_de_identidad"
  inflect.irregular "tanda", "tandas"
  inflect.irregular "movimiento_vehiculo", "movimientos_vehiculos"
  inflect.irregular "vehiculo", "vehiculos"
end

