class SalesPresenter
  include ActionView::Helpers::NumberHelper

  def initialize(params)
    @params = params
  end

  def sales
    @sales ||= filter.call.page(@params[:page]).decorate
  end

  def filter
    @filter ||= SaleFilter.new(filter_params)
  end

  def total_price
    number_to_currency(filter.call.sum(:price_in_cents)/10000 || 0)
  end

  def total_cash
    number_to_currency(filter.call.sum(:cash_in_cents)/10000 || 0)
  end

  def total_difference
    return @total_difference unless @total_difference.nil?
    @total_difference = filter.call.decorate.map(&:unformatted_difference).reduce(:+)
    @total_difference = 0 if @total_difference.nil?
    number_to_currency(@total_difference)
  end

  def total_cost
    total = filter.call.decorate.map(&:unformatted_vehicle_cost).reduce(:+)
    number_to_currency(total)
  end

  def total_expenses
    return @total_expenses unless @total_expense.nil?
    expense_params = filter_params
    expense_params[:skip_defaults] = true
    filter = ExpenseFilter.new(expense_params)
    @total_expenses = filter.total
  end

  def total_profit
    total_difference - total_expenses
  end

  private

  def filter_params
    if @params[:sale_filter]
      parameters = @params.require(:sale_filter).permit(:vehicle_model_id, :from, :to, :hide_not_finished)
    end
    parameters || {}
  end

end
