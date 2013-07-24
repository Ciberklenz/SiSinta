# encoding: utf-8
class CSVSerializer < ActiveModel::ArraySerializer
  # Opciones:
  # - headers: true o false para incluir headers o no
  # - checls: array de nombres datos a incluir
  # - base: clase de la que derivar un encabezado sin filas
  def as_csv(*args)
    o = args.extract_options!

    CSV.generate(headers: o[:headers]) do |csv|
      csv << encabezado(o[:checks], o[:base]) if csv.headers
      object.each do |perfil|
        perfil.horizontes.each do |horizonte|
          csv << CSVHorizonteSerializer.new(horizonte).to_csv(o[:checks])
        end
      end
    end
  end

  # TODO Reingeniería
  def encabezado(columnas = nil, base = nil)
    lista = HashWithIndifferentAccess.new(stub(base).serializable_hash).sort.flatten_tree
    if columnas.present?
      lista.select {|i| columnas.include? i}
    else
      lista
    end.keys
  end

  private

    # Construye un objeto con todas las asociaciones iniciadas para determinar
    # los nombres de columnas del csv a partir de las llaves del hash
    def stub(base = nil)
      s = if base.present?
        base
      else
        begin
          object.first
        rescue NoMethodError
          object
        end.class
      end.new.decorate

      # TODO desacoplar
      s.horizontes.build
      s.preparar
      CSVHorizonteSerializer.new(s.horizontes.first)
    end
end
