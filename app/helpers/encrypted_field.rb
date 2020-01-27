module EncryptedField
  def encrypted(t, name, options = {})
    unique = options.fetch(:unique, false)
    null = options.fetch(:null, true)

    t.string(:"encrypted_#{name}", options)
    t.string(:"encrypted_#{name}_iv", null: null)
    t.string(:"#{name}_bidx", null: null)

    t.index(:"encrypted_#{name}_iv", name: :"index_#{name}_iv", unique: true)
    t.index(:"#{name}_bidx", name: "index_#{name}_bidx", unique: unique)
  end
end
