# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# User.create(email: 'ernepazzo@virtualstoragepazzo.com', username: 'ernepazzo', password: '3rn3st1c0.V1rtu4lSt9r4g3P4zz0', whatsapp: 53867624, admin: true)
if User.count == 0
  User.create!(
    email: 'ernepazzo1212@gmail.com',
    password: '3rn3st1c0.12',
    password_confirmation: '3rn3st1c0.12',
    admin: true,
    confirmed_at: Time.current
  )
  User.create!(
    email: 'duniaosorio88@gmail.com',
    password: '1q2w3e4r5t',
    password_confirmation: '1q2w3e4r5t',
    admin: true,
    confirmed_at: Time.current
  )
  User.create!(
    email: 'livanmay27@gmail.com',
    password: '1q2w3e4r5t',
    password_confirmation: '1q2w3e4r5t',
    admin: true,
    confirmed_at: Time.current
  )
end

units = {
  # Unidades individuales / contables
  'unit'     => 'Unidad',
  'pair'     => 'Par',
  'set'      => 'Juego / Set',
  'piece'    => 'Pieza',
  'item'     => 'Ítem',
  'each'     => 'Cada uno',
  'lot'      => 'Lote',

  # Unidades de peso
  'kg'       => 'Kilogramo',
  'g'        => 'Gramo',
  'ton'      => 'Tonelada',
  'lb'       => 'Libra',
  'oz'       => 'Onza',

  # Unidades de volumen / capacidad
  'lt'       => 'Litro',
  'l'        => 'Litro', # alternativa
  'ml'       => 'Mililitro',
  'm3'       => 'Metro cúbico',
  'cm3'      => 'Centímetro cúbico',
  'gal'      => 'Galón',
  'bbl'      => 'Barril',

  # Unidades de empaque / presentación
  'box'      => 'Caja',
  'package'  => 'Paquete',
  'paquete'  => 'Paquete (español)',
  'bag'      => 'Bolsa',
  'bottle'   => 'Botella',
  'can'      => 'Lata',
  'drum'     => 'Tambor',
  'jar'      => 'Frasco',
  'tube'     => 'Tubo',
  'roll'     => 'Rollo',

  # Unidades logísticas / transporte
  'pallet'   => 'Palet / Tarima',
  'container'=> 'Contenedor',
  'crate'    => 'Cajón / Jaula',
  'carton'   => 'Cartón',
  'skid'     => 'Trineo / Base',
  'bundle'   => 'Atado / Fardo',

  # Unidades de área
  'm2'       => 'Metro cuadrado',
  'cm2'      => 'Centímetro cuadrado',
  'ft2'      => 'Pie cuadrado',
  'ha'       => 'Hectárea',

  # Unidades de longitud
  'm'        => 'Metro',
  'cm'       => 'Centímetro',
  'km'       => 'Kilómetro',
  'mm'       => 'Milímetro',
  'ft'       => 'Pie',
  'in'       => 'Pulgada',
  'yd'       => 'Yarda',

  # Otros / genéricos
  'dozen'    => 'Docena',
  'gross'    => 'Resma / Gran gruesa (144 unidades)',
  'ream'     => 'Resma (500 hojas)',
  'portion'  => 'Porción',
  'serving'  => 'Ración',
  'batch'    => 'Tanda / Lote de producción'
}

if NomUnit.count == 0
  units.each do |code, name|
    NomUnit.find_or_create_by(code: code) do |unit|
      unit.name = name
    end
  end
end