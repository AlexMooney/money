module MoneyAccessor
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def money_accessor(*columns)
      Array(columns).flatten.each do |name|
        define_method(name) do
          value = instance_variable_get("@#{name}")
          value.blank? ? nil : Money.new(value)
        end

        define_method("#{name}=") do |value|
          if value.blank? || !value.respond_to?(:to_money)
            instance_variable_set("@#{name}", nil)
            nil
          else
            money = value.to_money
            instance_variable_set("@#{name}", money.value)
            money
          end
        end
      end
    end
  end
end
