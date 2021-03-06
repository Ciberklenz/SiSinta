# Creación de modelos para los tests. Sin argumentos ni traits debería crear
# modelos que pasen la validación.
FactoryGirl.define do
  factory :usuario do
    nombre { generate :cadena_unica }
    email
    password 'algún password inolvidable'
    # Debe ser la default para no romper las vistas
    ficha { Ficha.default || create(:ficha, :default) }

    transient { rol nil }
    after(:build) do |usuario, params|
      usuario.grant(params.rol) if params.rol
    end
  end
end
