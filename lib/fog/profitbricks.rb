require 'fog/core'

module Fog
  module ProfitBricks
    extend Fog::Provider

    service(:compute, 'profitbricks/compute', 'Compute')

  end
end
