module NetSuite
  module Configuration
    extend self

    def reset!
      attributes.clear
    end

    def attributes
      @attributes ||= {}
    end

    def connection(params = {})
      Savon.client({
        wsdl: wsdl,
        read_timeout: read_timeout,
        namespaces: namespaces,
        soap_header: auth_header,
        pretty_print_xml: true,
        logger: logger,
        log_level: log_level,
      }.merge(params))
    end

    def api_version(version = nil)
      if version
        self.api_version = version
      else
        attributes[:api_version] ||= '2011_2'
      end
    end

    def api_version=(version)
      attributes[:api_version] = version
    end

    def sandbox=(flag)
      attributes[:flag] = flag
    end

    def sandbox(flag = nil)
      if flag.nil?
        attributes[:flag] ||= false
      else
        self.sandbox = flag
      end
    end

    def wsdl=(wsdl)
      attributes[:wsdl] = wsdl
    end

    def wsdl(wsdl = nil)
      if wsdl
        self.wsdl = wsdl
      else
        if sandbox
          wsdl_path = "https://webservices.sandbox.netsuite.com/wsdl/v#{api_version}_0/netsuite.wsdl"
        else
          wsdl_path = File.expand_path("../../../wsdl/#{api_version}.wsdl", __FILE__)
          wsdl_path = "https://webservices.netsuite.com/wsdl/v#{api_version}_0/netsuite.wsdl" unless File.exists? wsdl_path
        end

        attributes[:wsdl] ||= wsdl_path
      end
    end

    def auth_header
      attributes[:auth_header] ||= {
        'platformMsgs:passport' => {
          'platformCore:email'    => email,
          'platformCore:password' => password,
          'platformCore:account'  => account.to_s,
          'platformCore:role'     => { :'@type' => 'role', :@internalId => role }
        }
      }
    end

    def namespaces
      {
        'xmlns:platformMsgs'   => "urn:messages_#{api_version}.platform.webservices.netsuite.com",
        'xmlns:platformCore'   => "urn:core_#{api_version}.platform.webservices.netsuite.com",
        'xmlns:platformCommon' => "urn:common_#{api_version}.platform.webservices.netsuite.com",
        'xmlns:listRel'        => "urn:relationships_#{api_version}.lists.webservices.netsuite.com",
        'xmlns:tranSales'      => "urn:sales_#{api_version}.transactions.webservices.netsuite.com",
        'xmlns:actSched'       => "urn:scheduling_#{api_version}.activities.webservices.netsuite.com",
        'xmlns:setupCustom'    => "urn:customization_#{api_version}.setup.webservices.netsuite.com",
        'xmlns:listAcct'       => "urn:accounting_#{api_version}.lists.webservices.netsuite.com",
        'xmlns:tranCust'       => "urn:customers_#{api_version}.transactions.webservices.netsuite.com",
        'xmlns:listSupport'    => "urn:support_#{api_version}.lists.webservices.netsuite.com",
        'xmlns:tranGeneral'    => "urn:general_#{api_version}.transactions.webservices.netsuite.com",
      }
    end

    def role=(role)
      attributes[:role] = role
    end

    def role(role = nil)
      if role
        self.role = role
      else
        attributes[:role] ||= '3'
      end
    end

    def email=(email)
      attributes[:email] = email
    end

    def email(email = nil)
      if email
        self.email = email
      else
        attributes[:email] ||
        raise(ConfigurationError,
          '#email is a required configuration value. Please set it by calling NetSuite::Configuration.email = "me@example.com"')
      end
    end

    def password=(password)
      attributes[:password] = password
    end

    def password(password = nil)
      if password
        self.password = password
      else
        attributes[:password] ||
        raise(ConfigurationError,
          '#password is a required configuration value. Please set it by calling NetSuite::Configuration.password = "my_pass"')
      end
    end

    def account=(account)
      attributes[:account] = account
    end

    def account(account = nil)
      if account
        self.account = account
      else
        attributes[:account] ||
        raise(ConfigurationError,
          '#account is a required configuration value. Please set it by calling NetSuite::Configuration.account = 1234')
      end
    end

    def read_timeout=(timeout)
      attributes[:read_timeout] = timeout
    end

    def read_timeout(timeout = nil)
      if timeout
        self.read_timeout = timeout
      else
        attributes[:read_timeout] ||= 60
      end
    end

    def log=(path)
      attributes[:log] = path
    end

    def log(path = nil)
      self.log = path if path
      attributes[:log]
    end

    def logger(value = nil)
      attributes[:logger] = if value.nil?
        ::Logger.new((log && !log.empty?) ? log : $stdout)
      else
        value
      end
    end

    def log_level(value = nil)
      self.log_level = value || :debug
      attributes[:log_level]
    end

    def log_level=(value)
      attributes[:log_level] ||= value
    end
  end
end
