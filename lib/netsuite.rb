require 'set'

require 'netsuite/configuration'
require 'netsuite/errors'
require 'netsuite/response'
require 'netsuite/version'
require 'netsuite/field_support'
require 'netsuite/savon_support'

# ACTIONS
require 'netsuite/actions/add'
require 'netsuite/actions/get'
require 'netsuite/actions/initialize'

# ENTITIES
require 'netsuite/entities/customer'

# TRANSACTIONS
require 'netsuite/transactions/invoice'

module NetSuite

  def self.configure(&block)
    NetSuite::Configuration.instance_eval(&block)
  end

end
