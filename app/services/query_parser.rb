class QueryParser
  def initialize(params)
    @sort = params[:_sort]
    @order = params[:_order]
    @start = params[:_start]
    @end = params[:_end]
  end

  def order
    { @sort => @order.presence || "asc" } if @sort.present?
  end

  def offset
    Integer(@start) if @start.present?
  end

  def limit
    Integer(@end) - (offset || 0) if @end.present?
  end
end
