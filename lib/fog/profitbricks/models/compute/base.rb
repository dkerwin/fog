## Simple abstraction to get method attr_translate in all PB model classes

module Fog
  module Compute
    class ProfitBricks
      module Base

        def attr_translate
          self.class.aliases.invert
        end

      end
    end
  end
end
