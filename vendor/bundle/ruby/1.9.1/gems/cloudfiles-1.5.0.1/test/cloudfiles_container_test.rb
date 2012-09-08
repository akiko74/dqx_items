$:.unshift File.dirname(__FILE__)
require 'test_helper'

class CloudfilesContainerTest < Test::Unit::TestCase
  
  def test_object_creation
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => nil, :storageurl => nil, :authtoken => "dummy token")
    response = {'x-container-bytes-used' => '42', 'x-container-object-count' => '5'}
    SwiftClient.stubs(:head_container).returns(response)
    @container = CloudFiles::Container.new(connection, 'test_container')
    assert_equal @container.name, 'test_container'
    assert_equal @container.class, CloudFiles::Container
    assert_equal @container.public?, false
    assert_equal @container.cdn_url, nil
    assert_equal @container.cdn_ttl, nil
  end

  def test_object_creation_with_no_cdn_available
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => false, :cdnurl => nil, :storageurl => nil, :authtoken => "dummy token")
    response = {'x-container-bytes-used' => '42', 'x-container-object-count' => '5'}
    SwiftClient.stubs(:head_container).returns(response)
    @container = CloudFiles::Container.new(connection, 'test_container')
    assert_equal 'test_container', @container.name
    assert_equal CloudFiles::Container, @container.class
    assert_equal false, @container.public?
  end
  
  def test_object_creation_no_such_container
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => false, :cdnurl => nil, :storageurl => nil, :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).raises(ClientException.new("foobar", :http_status => 404))
    assert_raise(CloudFiles::Exception::NoSuchContainer) do
      @container = CloudFiles::Container.new(connection, 'test_container')
    end
  end
  
  def test_object_creation_with_cdn
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => nil, :storageurl => nil, :authtoken => "dummy token")
    response = {'x-container-bytes-used' => '42', 'x-container-object-count' => '5', 'x-cdn-enabled' => 'True', 'x-cdn-uri' => 'http://cdn.test.example/container', 'x-ttl' => '86400'}
    SwiftClient.stubs(:head_container).returns(response)
    @container = CloudFiles::Container.new(connection, 'test_container')
    assert_equal @container.name, 'test_container'
    assert_equal @container.cdn_enabled, true
    assert_equal @container.public?, true
    assert_equal @container.cdn_url, 'http://cdn.test.example/container'
    assert_equal @container.cdn_ttl, 86400
  end
  
  def test_to_s
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => nil, :storageurl => nil, :authtoken => "dummy token")
    response = {'x-container-bytes-used' => '42', 'x-container-object-count' => '5', 'x-cdn-enabled' => 'True', 'x-cdn-uri' => 'http://cdn.test.example/container', 'x-ttl' => '86400'}
    SwiftClient.stubs(:head_container).returns(response)
    @container = CloudFiles::Container.new(connection, 'test_container')
    assert_equal @container.to_s, 'test_container'
  end
  
  def test_make_private_succeeds
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => nil, :storageurl => nil, :authtoken => "dummy token", :container_metadata => {'x-container-bytes-used' => '42', 'x-container-object-count' => '5'})
    response = {'x-container-bytes-used' => '42', 'x-container-object-count' => '5', 'x-cdn-enabled' => 'True', 'x-cdn-uri' => 'http://cdn.test.example/container', 'x-ttl' => '86400'}
    SwiftClient.stubs(:head_container).returns(response)
    SwiftClient.stubs(:post_container).returns(nil)
    @container = CloudFiles::Container.new(connection, 'test_container')
    assert_nothing_raised do
      @container.make_private
    end
  end
  
  def test_make_private_fails
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => nil, :storageurl => nil, :authtoken => "dummy token", :container_metadata => {'x-container-bytes-used' => '42', 'x-container-object-count' => '5'})
    response = {'x-container-bytes-used' => '42', 'x-container-object-count' => '5', 'x-cdn-enabled' => 'True', 'x-cdn-uri' => 'http://cdn.test.example/container', 'x-ttl' => '86400'}
    SwiftClient.stubs(:head_container).returns(response)
    SwiftClient.stubs(:post_container).raises(ClientException.new("test_make_private_fails", :http_status => 404))
    @container = CloudFiles::Container.new(connection, 'test_container')    
    assert_raises(CloudFiles::Exception::NoSuchContainer) do
      @container.make_private
    end
  end
  
  def test_make_public_succeeds
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://cdn.test.example/container', :storageurl => nil, :authtoken => "dummy token")
    response = {'x-container-bytes-used' => '42', 'x-container-object-count' => '5', 'x-cdn-enabled' => 'True', 'x-cdn-uri' => 'http://cdn.test.example/container', 'x-ttl' => '86400'}
    SwiftClient.stubs(:put_container).returns(nil)
    SwiftClient.stubs(:head_container).returns(response)
    CloudFiles::Container.any_instance.stubs(:post_with_headers).returns(nil)
    @container = CloudFiles::Container.new(connection, 'test_container')
    assert_nothing_raised do
      @container.make_public
    end
  end
  
  def test_make_public_fixnum_ttl_deprication_warning_and_succeeds
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://cdn.test.example/container', :storageurl => nil, :authtoken => "dummy token")
    response = {'x-container-bytes-used' => '42', 'x-container-object-count' => '5', 'x-cdn-enabled' => 'True', 'x-cdn-uri' => 'http://cdn.test.example/container', 'x-ttl' => '86400'}
    SwiftClient.stubs(:put_container).returns(nil)
    SwiftClient.stubs(:head_container).returns(response)
    CloudFiles::Container.any_instance.stubs(:post_with_headers).returns(nil)
    @container = CloudFiles::Container.new(connection, 'test_container')
    assert_nothing_raised do
      @container.make_public(:ttl => 123)
    end
  end
  
  def test_make_public_fails
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://cdn.test.example/container', :storageurl => nil, :authtoken => "dummy token")
    response = {'x-container-bytes-used' => '42', 'x-container-object-count' => '5', 'x-cdn-enabled' => 'True', 'x-cdn-uri' => 'http://cdn.test.example/container', 'x-ttl' => '86400'}
    SwiftClient.stubs(:head_container).returns(response)
    SwiftClient.stubs(:put_container).raises(ClientException.new("test_make_public_fails", :http_status => 404))
    CloudFiles::Container.any_instance.stubs(:post_with_headers).returns(nil)
    @container = CloudFiles::Container.new(connection, 'test_container')
    assert_raises(CloudFiles::Exception::NoSuchContainer) do
      @container.make_public
    end
  end
  
  def test_empty_is_false
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://cdn.test.example/container', :storageurl => nil, :authtoken => "dummy token")
    response = {'x-container-bytes-used' => '42', 'x-container-object-count' => '5'}
    SwiftClient.stubs(:head_container).returns(response)
    @container = CloudFiles::Container.new(connection, 'test_container')
    assert_equal @container.empty?, false
  end
  
  def test_empty_is_true
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://cdn.test.example/container', :storageurl => nil, :authtoken => "dummy token")
    response = {'x-container-bytes-used' => '0', 'x-container-object-count' => '0'}
    SwiftClient.stubs(:head_container).returns(response)
    @container = CloudFiles::Container.new(connection, 'test_container')
    assert_equal @container.empty?, true
  end

  def build_acl_test_state(opts={})
    @connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => false, :cdnurl => 'http://cdn.test.example/container', :storageurl => nil, :authtoken => "dummy token")
    
    @response = {
      'x-container-bytes-used' => '0',
      'x-container-object-count' => '0',
    }.merge(opts.fetch(:response, {}))

    @response.stubs(:code).returns(opts.fetch(:code, '204'))
    if opts[:code] =~ /^![2]0/
      SwiftClient.stubs(:head_container).raises(ClientException.new("acl_test_state", :http_status => opts.fetch(:code, 204)))
    else
      SwiftClient.stubs(:head_container).returns(@response)
    end
    @container = CloudFiles::Container.new(@connection, 'test_container')
  end
  
  def test_read_acl_is_set_from_headers
    @connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => false, :cdnurl => 'http://cdn.test.example/container', :storageurl => nil, :authtoken => "dummy token")
    @response = {'x-container-bytes-used' => '0','x-container-object-count' => '0', 'x-container-read' => '.r:*'}
    SwiftClient.stubs(:head_container).returns(@response)
    @container = CloudFiles::Container.new(@connection, 'test_container')
    assert_equal @response["x-container-read"], @container.read_acl
  end

  def test_set_read_acl_fails
    @connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => false, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '0','x-container-object-count' => '0'})
    SwiftClient.stubs(:post_container).raises(ClientException.new("test_set_read_acl_fails", :http_status => 404))
    @container = CloudFiles::Container.new(@connection, 'test_container')
    assert_raises(CloudFiles::Exception::NoSuchContainer) do
      @container.set_read_acl('.r:*')
    end
  end

  def test_set_read_acl_succeeds
    @connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => false, :cdnurl => 'http://cdn.test.example/container', :storageurl => nil, :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '0','x-container-object-count' => '0', 'x-container-write' => '.r:*'})
    SwiftClient.stubs(:post_container).returns(true)
    @container = CloudFiles::Container.new(@connection, 'test_container')
    assert_equal @container.set_read_acl('.r:*'), true
  end

  def test_write_acl_is_set_from_headers
    @connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => false, :cdnurl => 'http://cdn.test.example/container', :storageurl => nil, :authtoken => "dummy token")
    @response = {'x-container-bytes-used' => '0','x-container-object-count' => '0', 'x-container-write' => '.r:*'}
    SwiftClient.stubs(:head_container).returns(@response)
    @container = CloudFiles::Container.new(@connection, 'test_container')
    assert_equal @response["x-container-write"], @container.write_acl
  end

  def test_set_write_acl_fails
    @connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => false, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '0','x-container-object-count' => '0'})
    SwiftClient.stubs(:post_container).raises(ClientException.new("test_set_write_acl_fails", :http_status => 404))
    @container = CloudFiles::Container.new(@connection, 'test_container')
    assert_raises(CloudFiles::Exception::NoSuchContainer) do
      @container.set_write_acl('.r:*')
    end
  end

  def test_set_write_acl_succeeds
    @connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => false, :cdnurl => 'http://cdn.test.example/container', :storageurl => nil, :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '0','x-container-object-count' => '0', 'x-container-write' => '.r:*'})
    SwiftClient.stubs(:post_container).returns(true)
    @container = CloudFiles::Container.new(@connection, 'test_container')
    assert_equal @container.set_write_acl('.r:*'), true
  end

  def test_log_retention_is_true
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '0', 'x-container-object-count' => '0', 'x-cdn-enabled' => 'True', 'x-log-retention' => 'True'})
    @container = CloudFiles::Container.new(connection, 'test_container')
    assert_equal @container.log_retention?, true
  end
  
  def test_object_fetch
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '10','x-container-object-count' => '1'})
    SwiftClient.stubs(:head_object).returns({'last-modified' => 'Wed, 28 Jan 2009 16:16:26 GMT'})
    @container = CloudFiles::Container.new(connection, "test_container")
    object = @container.object('good_object')
    assert_equal object.class, CloudFiles::StorageObject
  end
  
  def test_create_object
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '10','x-container-object-count' => '1'})
    @container = CloudFiles::Container.new(connection, "test_container")
    object = @container.create_object('new_object')
    assert_equal object.class, CloudFiles::StorageObject
  end
  
  def test_object_exists_true
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '10','x-container-object-count' => '1'})
    SwiftClient.stubs(:head_object).returns({'last-modified' => 'Wed, 28 Jan 2009 16:16:26 GMT'})
    @container = CloudFiles::Container.new(connection, "test_container")
    assert_equal @container.object_exists?('good_object'), true
  end
  
  def test_object_exists_false
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '10','x-container-object-count' => '1'})
    SwiftClient.stubs(:head_object).raises(ClientException.new("test_object_exists_false", :http_status => 404))
    @container = CloudFiles::Container.new(connection, "test_container")
    assert_equal @container.object_exists?('bad_object'), false
  end
  
  def test_delete_object_succeeds
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '10','x-container-object-count' => '1'})
    SwiftClient.stubs(:delete_object).returns(nil)
    @container = CloudFiles::Container.new(connection, "test_container")
    assert_nothing_raised do
      @container.delete_object('good_object')
    end
  end
  
  def test_delete_invalid_object_fails
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '10','x-container-object-count' => '1'})
    SwiftClient.stubs(:delete_object).raises(ClientException.new('test_delete_invalid_object_fails', :http_status => 404))
    @container = CloudFiles::Container.new(connection, "test_container")
    assert_raise(CloudFiles::Exception::NoSuchObject) do
      @container.delete_object('nonexistent_object')
    end
  end
  
  def test_delete_invalid_response_code_fails
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '10','x-container-object-count' => '1'})
    SwiftClient.stubs(:delete_object).raises(ClientException.new('test_delete_invalid_object_fails', :http_status => 999))
    @container = CloudFiles::Container.new(connection, "test_container")
    assert_raise(CloudFiles::Exception::InvalidResponse) do
      @container.delete_object('broken_object')
    end
  end
  
  def test_fetch_objects
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '10','x-container-object-count' => '1'})
    SwiftClient.stubs(:get_container).returns([{'x-container-bytes-used' => '10','x-container-object-count' => '1'}, [{'name' => 'foo'},{'name' => 'bar'},{'name' => 'baz'}]])
    @container = CloudFiles::Container.new(connection, "test_container")
    
    objects = @container.objects
    assert_equal objects.class, Array
    assert_equal objects.size, 3
    assert_equal objects.first, 'foo'
  end
  
  def test_fetch_objects_fails
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '10','x-container-object-count' => '1'})
    SwiftClient.stubs(:get_container).raises(ClientException.new("test_fetch_object_fails", :http_status => 500))
    @container = CloudFiles::Container.new(connection, "test_container")
    
    assert_raise(CloudFiles::Exception::InvalidResponse) do
      objects = @container.objects
    end
  end
  
  def test_fetch_objects_with_limit
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '10','x-container-object-count' => '1'})
    SwiftClient.stubs(:get_container).returns([{'x-container-bytes-used' => '10','x-container-object-count' => '1'}, [{'name' => 'foo'}]])
    @container = CloudFiles::Container.new(connection, "test_container")
    
    objects = @container.objects(:limit => 1)
    assert_equal objects.class, Array
    assert_equal objects.size, 1
    assert_equal objects.first, 'foo'
  end

  def test_fetch_objects_with_marker
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '10','x-container-object-count' => '1'})
    SwiftClient.stubs(:get_container).returns([{'x-container-bytes-used' => '10','x-container-object-count' => '1'}, [{'name' => 'bar'}]])
    @container = CloudFiles::Container.new(connection, "test_container")
    
    objects = @container.objects(:marker => 'foo')
    assert_equal objects.class, Array
    assert_equal objects.size, 1
    assert_equal objects.first, 'bar'
  end

  def test_fetch_objects_with_deprecated_offset_param
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '10','x-container-object-count' => '1'})
    SwiftClient.stubs(:get_container).returns([{'x-container-bytes-used' => '10','x-container-object-count' => '1'}, [{'name' => 'bar'}]])
    @container = CloudFiles::Container.new(connection, "test_container")
    
    objects = @container.objects(:offset => 'foo')
    assert_equal objects.class, Array
    assert_equal objects.size, 1
    assert_equal objects.first, 'bar'
  end
  
  def object_detail_body(skip_kisscam=false)
    lines = []
    lines << {'name' => 'kisscam.mov', 'hash' => '96efd5a0d78b74cfe2a911c479b98ddd', 'bytes' => '9196332', 'content_type' => 'video/quicktime', 'last_modified' => '2008-12-18T10:34:43.867648'} unless skip_kisscam
    lines << {'name' => 'penaltybox.mov', 'hash' => 'd2a4c0c24d8a7b4e935bee23080e0685', 'bytes' => '24944966', 'content_type' => 'video/quicktime', 'last_modified' => '2008-12-18T10:35:19.273927'}
  end
  
  def test_fetch_objects_detail
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '10','x-container-object-count' => '2'})
    SwiftClient.stubs(:get_container).returns([{'x-container-bytes-used' => '10','x-container-object-count' => '2'}, object_detail_body])
    @container = CloudFiles::Container.new(connection, "test_container")
    
    details = @container.objects_detail
    assert_equal details.size, 2
    assert_equal details['kisscam.mov'][:bytes], '9196332'
  end
  
  def test_fetch_objects_details_with_limit
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '10','x-container-object-count' => '2'})
    SwiftClient.stubs(:get_container).returns([{'x-container-bytes-used' => '10','x-container-object-count' => '2'}, object_detail_body])
    @container = CloudFiles::Container.new(connection, "test_container")
    
    details = @container.objects_detail(:limit => 2)
    assert_equal details.size, 2
    assert_equal details['kisscam.mov'][:bytes], '9196332'
  end

  def test_fetch_objects_detail_with_marker
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '10','x-container-object-count' => '1'})
    SwiftClient.stubs(:get_container).returns([{'x-container-bytes-used' => '10','x-container-object-count' => '1'}, object_detail_body(true)])
    @container = CloudFiles::Container.new(connection, "test_container")
                                                  
    details = @container.objects_detail(:marker => 'kisscam.mov')
    assert_equal details.size, 1
    assert_equal details['penaltybox.mov'][:bytes], '24944966'
  end

  def test_fetch_objects_detail_with_deprecated_offset_param
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '10','x-container-object-count' => '1'})
    SwiftClient.stubs(:get_container).returns([{'x-container-bytes-used' => '10','x-container-object-count' => '1'}, object_detail_body(true)])
    @container = CloudFiles::Container.new(connection, "test_container")
  
    details = @container.objects_detail(:offset => 'kisscam.mov')
    assert_equal details.size, 1
    assert_equal details['penaltybox.mov'][:bytes], '24944966'
  end
  
    
  def test_fetch_object_detail_empty
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '0','x-container-object-count' => '0'})
    SwiftClient.stubs(:get_container).returns([{'x-container-bytes-used' => '0','x-container-object-count' => '0'}, {}])
    @container = CloudFiles::Container.new(connection, "test_container")
    
    details = @container.objects_detail
    assert_equal details, {}
  end
  
  def test_fetch_object_detail_error
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '0','x-container-object-count' => '0'})
    SwiftClient.stubs(:get_container).raises(ClientException.new('test_fetch_object_detail_error', :http_status => 999))
    @container = CloudFiles::Container.new(connection, "test_container")
    
    assert_raise(CloudFiles::Exception::InvalidResponse) do
      details = @container.objects_detail
    end
  end
  
  def test_setting_log_retention
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '0','x-container-object-count' => '0'})
    SwiftClient.stubs(:post_container).returns(true)
    @container = CloudFiles::Container.new(connection, "test_container")
    
    assert(@container.log_retention='false')
  end

  def test_setting_log_retention_fails
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '0','x-container-object-count' => '0'})
    SwiftClient.stubs(:post_container).raises(ClientException.new("test_setting_log_retention_fails", :http_status => 500))
    @container = CloudFiles::Container.new(connection, "test_container")
    
    assert_raise(CloudFiles::Exception::InvalidResponse) do
      @container.log_retention='false'
    end
  end
  
  def test_purge_from_cdn_succeeds
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '0','x-container-object-count' => '0'})
    SwiftClient.stubs(:delete_container).returns(nil)
    @container = CloudFiles::Container.new(connection, "test_container")
    
    assert_nothing_raised do
      @container.purge_from_cdn
      @container.purge_from_cdn("small.fox@hole.org")
    end
  end
  
  def test_purge_from_cdn_fails
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '0','x-container-object-count' => '0'})
    SwiftClient.stubs(:delete_container).raises(ClientException.new("test_purge_from_cdn_fails", :http_status => 500))
    @container = CloudFiles::Container.new(connection, "test_container")
    
    assert_raise(CloudFiles::Exception::Connection) do
      @container.purge_from_cdn
    end
  end
  
  def test_cdn_metadata_fails
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '0','x-container-object-count' => '0'})
    @container = CloudFiles::Container.new(connection, "test_container")    
    SwiftClient.stubs(:head_container).raises(ClientException.new("test_cdn_metadata_fails", :http_status => 404))    
    assert_raise(CloudFiles::Exception::NoSuchContainer) do
      @container.cdn_metadata
    end
  end
  
  def test_cdn_metadata_no_cdn
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => false, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '0','x-container-object-count' => '0'})
    @container = CloudFiles::Container.new(connection, "test_container")    
    assert_equal @container.cdn_metadata, {}
  end
  
  def test_bytes
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => false, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '99','x-container-object-count' => '10'})
    @container = CloudFiles::Container.new(connection, "test_container")    
    assert_equal @container.bytes, 99
  end
  
  def test_count
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => false, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '0','x-container-object-count' => '10'})
    @container = CloudFiles::Container.new(connection, "test_container")    
    assert_equal @container.count, 10    
  end
  
  def test_cdn_ssl_url
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '0','x-container-object-count' => '10', 'x-cdn-ssl-uri' => 'https://ssl.cdn.test.example/container', "x-cdn-enabled" => 'True'})
    @container = CloudFiles::Container.new(connection, "test_container")    
    assert_equal @container.cdn_ssl_url, 'https://ssl.cdn.test.example/container'
  end
  
  def test_cdn_url
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '0','x-container-object-count' => '10', 'x-cdn-uri' => 'http://cdn.test.example/container', "x-cdn-enabled" => 'True'})
    @container = CloudFiles::Container.new(connection, "test_container")    
    assert_equal @container.cdn_url, 'http://cdn.test.example/container'
  end
  
  def test_metadata
    connection = stub(:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token")
    SwiftClient.stubs(:head_container).returns({'x-container-bytes-used' => '0','x-container-object-count' => '10', 'x-container-meta-foo' => 'bar'})
    @container = CloudFiles::Container.new(connection, "test_container")
    assert_equal @container.metadata, {'foo' => 'bar'}
  end
end
