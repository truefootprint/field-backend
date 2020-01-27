Rails.application.config.filter_parameters += %i[
  device_id
  password
  phone_number
  token
]
