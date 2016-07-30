require 'numero_a_letras'
class SaleDecorator < Draper::Decorator
  delegate_all

  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper

  def brand_and_model
    vehicle_decorated.brand_and_model
  end

  def version
    vehicle_decorated.version
  end

  def specs
    vehicle_decorated.specs
  end

  def price
    number_to_currency(object.price, precision: 2) || '-'
  end

  def price_in_letters
    object.price.a_moneda
  end

  def advance
    number_to_currency(object.advance, precision: 2) || '-'
  end

  def advance_in_letters
    object.advance.a_moneda
  end

  def unformatted_advance
    object.advance
  end

  def remaining
    object.price - object.advance
  end

  def remaining_in_letters
    (object.price - object.advance).a_moneda
  end

  def notes
    if object.notes.empty?
      '<i> Sin notas </i>'.html_safe
    else
      simple_format(object.notes)
    end
  end

  def sold_on
    object.sold_on || '-'
  end

  private

  def vehicle_decorated
    @vehicle ||= object.vehicle.decorate
  end
end