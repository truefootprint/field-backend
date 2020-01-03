module CreateOrUpdate
  def create_or_update!(model, where:, attributes:)
    record = model.order(:id).find_by(where)

    if record
      record.update!(attributes)
    else
      record = model.create!(attributes)
    end

    record
  end
end
