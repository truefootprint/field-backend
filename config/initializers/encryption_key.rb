# These keys are for development use only. They should be set explicitly in
# prodution and stored securely. If lost, we can no longer decrypt the database.

unless Rails.env.production?
  ENV["KEY"] = "0" * 32
  ENV["BLIND_INDEX_MASTER_KEY"] = "0" * 64
end
