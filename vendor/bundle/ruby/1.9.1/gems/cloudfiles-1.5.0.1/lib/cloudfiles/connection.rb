module CloudFiles
  class Connection
    # See COPYING for license information.
    # Copyright (c) 2011, Rackspace US, Inc.

    # Authentication key provided when the CloudFiles class was instantiated
    attr_reader :authkey

    # Token returned after a successful authentication
    attr_accessor :authtoken

    # Authentication username provided when the CloudFiles class was instantiated
    attr_reader :authuser

    # API host to authenticate to
    attr_reader :auth_url

    # Set at auth to see if a CDN is available for use
    attr_accessor :cdn_available
    alias :cdn_available? :cdn_available

    # Hostname of the CDN management server
    attr_accessor :cdnmgmthost

    # Path for managing containers on the CDN management server
    attr_accessor :cdnmgmtpath

    # Port number for the CDN server
    attr_accessor :cdnmgmtport

    # URI scheme for the CDN server
    attr_accessor :cdnmgmtscheme

    # Hostname of the storage server
    attr_accessor :storagehost

    # Path for managing containers/objects on the storage server
    attr_accessor :storagepath

    # Port for managing the storage server
    attr_accessor :storageport

    # URI scheme for the storage server
    attr_accessor :storagescheme

    # Instance variable that is set when authorization succeeds
    attr_accessor :authok

    # Optional proxy variables
    attr_reader :proxy_host
    attr_reader :proxy_port

    # Creates a new CloudFiles::Connection object.  Uses CloudFiles::Authentication to perform the login for the connection.
    # The authuser is the Rackspace Cloud username, the authkey is the Rackspace Cloud API key.
    #
    # Setting the :retry_auth option to false will cause an exception to be thrown if your authorization token expires.
    # Otherwise, it will attempt to reauthenticate.
    #
    # Setting the :snet option to true or setting an environment variable of RACKSPACE_SERVICENET to any value will cause
    # storage URLs to be returned with a prefix pointing them to the internal Rackspace service network, instead of a public URL.
    #
    # This is useful if you are using the library on a Rackspace-hosted system, as it provides faster speeds, keeps traffic off of
    # the public network, and the bandwidth is not billed.
    #
    # If you need to connect to a Cloud Files installation that is NOT the standard Rackspace one, set the :auth_url option to the URL
    # of your authentication endpoint.  The old option name of :authurl is deprecated.  The default is CloudFiles::AUTH_USA (https://auth.api.rackspacecloud.com/v1.0)
    #
    # There are two predefined constants to represent the United States-based authentication endpoint and the United Kingdom-based endpoint:
    # CloudFiles::AUTH_USA (the default) and CloudFiles::AUTH_UK - both can be passed to the :auth_url option to quickly choose one or the other.
    #
    # This will likely be the base class for most operations.
    #
    # With gem 1.4.8, the connection style has changed.  It is now a hash of arguments.  Note that the proxy options are currently only
    # supported in the new style.
    #
    #   cf = CloudFiles::Connection.new(:username => "MY_USERNAME", :api_key => "MY_API_KEY", :auth_url => CloudFiles::AUTH_UK, :retry_auth => true, :snet => false, :proxy_host => "localhost", :proxy_port => "1234")
    #
    # The old style (positional arguments) is deprecated and will be removed at some point in the future.
    #
    #   cf = CloudFiles::Connection.new(MY_USERNAME, MY_API_KEY, RETRY_AUTH, USE_SNET)
    def initialize(*args)
      if args[0].is_a?(Hash)
        options = args[0]
        @authuser = options[:username] ||( raise CloudFiles::Exception::Authentication, "Must supply a :username")
        @authkey = options[:api_key] || (raise CloudFiles::Exception::Authentication, "Must supply an :api_key")
        @auth_url = options[:authurl] || CloudFiles::AUTH_USA
        @auth_url = options[:auth_url] || CloudFiles::AUTH_USA
        @retry_auth = options[:retry_auth] || true
        @snet = ENV['RACKSPACE_SERVICENET'] || options[:snet]
        @proxy_host = options[:proxy_host]
        @proxy_port = options[:proxy_port]
      else
        @authuser = args[0] ||( raise CloudFiles::Exception::Authentication, "Must supply the username as the first argument")
        @authkey = args[1] || (raise CloudFiles::Exception::Authentication, "Must supply the API key as the second argument")
        @retry_auth = args[2] || true
        @snet = (ENV['RACKSPACE_SERVICENET'] || args[3]) ? true : false
        @auth_url = CloudFiles::AUTH_USA
      end
      @authok = false
      @http = {}
      CloudFiles::Authentication.new(self)
    end

    # Returns true if the authentication was successful and returns false otherwise.
    #
    #   cf.authok?
    #   => true
    def authok?
      @authok
    end

    # Returns true if the library is requesting the use of the Rackspace service network
    def snet?
      @snet
    end

    # Returns an CloudFiles::Container object that can be manipulated easily.  Throws a NoSuchContainerException if
    # the container doesn't exist.
    #
    #    container = cf.container('test')
    #    container.count
    #    => 2
    def container(name)
      CloudFiles::Container.new(self, name)
    end
    alias :get_container :container

    # Sets instance variables for the bytes of storage used for this account/connection, as well as the number of containers
    # stored under the account.  Returns a hash with :bytes and :count keys, and also sets the instance variables.
    #
    #   cf.get_info
    #   => {:count=>8, :bytes=>42438527}
    #   cf.bytes
    #   => 42438527
    # Hostname of the storage server

    def get_info
      begin
        raise CloudFiles::Exception::AuthenticationException, "Not authenticated" unless self.authok?
        response = SwiftClient.head_account(storageurl, self.authtoken)
        @bytes = response["x-account-bytes-used"].to_i
        @count = response["x-account-container-count"].to_i
        {:bytes => @bytes, :count => @count}
      rescue ClientException => e
        raise CloudFiles::Exception::InvalidResponse, "Unable to obtain account size" unless (e.status.to_s == "204")
      end
    end
    
    # The total size in bytes under this connection
    def bytes
      get_info[:bytes]
    end
    
    # The total number of containers under this connection
    def count
      get_info[:count]
    end

    # Gathers a list of the containers that exist for the account and returns the list of container names
    # as an array.  If no containers exist, an empty array is returned.  Throws an InvalidResponseException
    # if the request fails.
    #
    # If you supply the optional limit and marker parameters, the call will return the number of containers
    # specified in limit, starting after the object named in marker.
    #
    #   cf.containers
    #   => ["backup", "Books", "cftest", "test", "video", "webpics"]
    #
    #   cf.containers(2,'cftest')
    #   => ["test", "video"]
    def containers(limit = nil, marker = nil)
      begin
        response = SwiftClient.get_account(storageurl, self.authtoken, marker, limit)
        response[1].collect{|c| c['name']}
      rescue ClientException => e
        raise CloudFiles::Exception::InvalidResponse, "Invalid response code #{e.status.to_s}" unless (e.status.to_s == "200")
      end
    end
    alias :list_containers :containers

    # Retrieves a list of containers on the account along with their sizes (in bytes) and counts of the objects
    # held within them.  If no containers exist, an empty hash is returned.  Throws an InvalidResponseException
    # if the request fails.
    #
    # If you supply the optional limit and marker parameters, the call will return the number of containers
    # specified in limit, starting after the object named in marker.
    #
    #   cf.containers_detail
    #   => { "container1" => { :bytes => "36543", :count => "146" },
    #        "container2" => { :bytes => "105943", :count => "25" } }
    def containers_detail(limit = nil, marker = nil)
      begin
        response = SwiftClient.get_account(storageurl, self.authtoken, marker, limit)
        Hash[*response[1].collect{|c| [c['name'], {:bytes => c['bytes'], :count => c['count']}]}.flatten]
      rescue ClientException => e
        raise CloudFiles::Exception::InvalidResponse, "Invalid response code #{e.status.to_s}" unless (e.status.to_s == "200")
      end
    end
    alias :list_containers_info :containers_detail

    # Returns true if the requested container exists and returns false otherwise.
    #
    #   cf.container_exists?('good_container')
    #   => true
    #
    #   cf.container_exists?('bad_container')
    #   => false
    def container_exists?(containername)
      begin
        response = SwiftClient.head_container(storageurl, self.authtoken, containername)
        true
      rescue ClientException => e
        false
      end
    end

    # Creates a new container and returns the CloudFiles::Container object.  Throws an InvalidResponseException if the
    # request fails.
    #
    # "/" is not valid in a container name.  The container name is limited to
    # 256 characters or less.
    #
    #   container = cf.create_container('new_container')
    #   container.name
    #   => "new_container"
    #
    #   container = cf.create_container('bad/name')
    #   => SyntaxException: Container name cannot contain '/'
    def create_container(containername)
      raise CloudFiles::Exception::Syntax, "Container name cannot contain '/'" if containername.match("/")
      raise CloudFiles::Exception::Syntax, "Container name is limited to 256 characters" if containername.length > 256
      begin
        SwiftClient.put_container(storageurl, self.authtoken, containername)
        CloudFiles::Container.new(self, containername)
      rescue ClientException => e
        raise CloudFiles::Exception::InvalidResponse, "Unable to create container #{containername}" unless (e.status.to_s == "201" || e.status.to_s == "202")
      end
    end

    # Deletes a container from the account.  Throws a NonEmptyContainerException if the container still contains
    # objects.  Throws a NoSuchContainerException if the container doesn't exist.
    #
    #   cf.delete_container('new_container')
    #   => true
    #
    #   cf.delete_container('video')
    #   => NonEmptyContainerException: Container video is not empty
    #
    #   cf.delete_container('nonexistent')
    #   => NoSuchContainerException: Container nonexistent does not exist
    def delete_container(containername)
      begin
        SwiftClient.delete_container(storageurl, self.authtoken, containername)
      rescue ClientException => e
        raise CloudFiles::Exception::NonEmptyContainer, "Container #{containername} is not empty" if (e.status.to_s == "409")
        raise CloudFiles::Exception::NoSuchContainer, "Container #{containername} does not exist" unless (e.status.to_s == "204")
      end
      true
    end

    # Gathers a list of public (CDN-enabled) containers that exist for an account and returns the list of container names
    # as an array.  If no containers are public, an empty array is returned.  Throws a InvalidResponseException if
    # the request fails.
    #
    # If you pass the optional argument as true, it will only show containers that are CURRENTLY being shared on the CDN,
    # as opposed to the default behavior which is to show all containers that have EVER been public.
    #
    #   cf.public_containers
    #   => ["video", "webpics"]
    def public_containers(enabled_only = false)
      begin
        response = SwiftClient.get_account(cdnurl, self.authtoken)
        response[1].collect{|c| c['name']}
      rescue ClientException => e
        raise CloudFiles::Exception::InvalidResponse, "Invalid response code #{e.status.to_s}" unless (e.status.to_s == "200")
      end
    end
    
    def storageurl
      "#{self.storagescheme}://#{self.storagehost}:#{self.storageport.to_s}#{self.storagepath}"
    end
    def cdnurl
      "#{self.cdnmgmtscheme}://#{self.cdnmgmthost}:#{self.cdnmgmtport.to_s}#{self.cdnmgmtpath}"
    end
  end
end
