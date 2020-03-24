# This plugin was adapted from https://github.com/shioyama/mobility/issues/361

module Mobility
  module Plugins
    # Adds a +#{attribute}_translations+ method so you can easily mass assign the property from a hash
    class MassAssign < Module
      def self.apply(attributes, option)
        return unless option
        attributes.model_class.include(new(*attributes.names))
      end

      def initialize(*attribute_names)
        Array(attribute_names).each do |name|
          define_translations_reader(name)
          define_translations_writer(name)
        end
      end

      private

      def define_translations_reader(name)
        module_eval <<~RUBY, __FILE__, __LINE__ + 1
          def #{name}_translations
            #{name}_backend.translations
          end
        RUBY
      end

      def define_translations_writer(name)
        module_eval <<~RUBY, __FILE__, __LINE__ + 1
          def #{name}_translations=(values)
            values.each { |locale, value| mobility_backends[:#{name}].write(locale, value) }
          end
        RUBY
      end
    end
  end
end
