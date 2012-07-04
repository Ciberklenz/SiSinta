# encoding: utf-8
class Horizonte < ActiveRecord::Base

  # Declaramos la lista de asociaciones a preparar durante la inicialización
  after_initialize do
    preparar  :color_seco, :color_humedo, :limite, :consistencia, :estructura,
              :analisis
  end

  # Arregla la entrada para que no haya objetos repetidos ni se creen vacíos
  before_save do
    buscar_asociaciones color_seco: 'hvc', color_humedo: 'hvc'
  end

  has_one :analisis,      dependent: :destroy, inverse_of: :horizonte
  has_one :limite,        dependent: :destroy, inverse_of: :horizonte
  has_one :consistencia,  dependent: :destroy, inverse_of: :horizonte
  has_one :estructura,    dependent: :destroy, inverse_of: :horizonte

  belongs_to :calicata, inverse_of: :horizontes

  belongs_to :color_seco, class_name: 'Color', inverse_of: :horizontes_en_seco,
                          autosave: false
  belongs_to :color_humedo, class_name: 'Color', inverse_of: :horizontes_en_humedo,
                            autosave: false
  belongs_to :textura_de_horizonte, inverse_of: :horizontes

  accepts_nested_attributes_for :analisis, :limite, :consistencia,
                                :estructura, :textura_de_horizonte,
                                limit: 1
  accepts_nested_attributes_for :color_seco, :color_humedo,
                                reject_if: :all_blank

  validates_presence_of :calicata

  def rango_profundidad
    unless profundidad_superior.blank? or profundidad_inferior.blank?
      "#{profundidad_superior} - #{profundidad_inferior}"
    end
  end

  def to_s
    self.to_param
  end

end
