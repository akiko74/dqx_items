$:.unshift File.dirname(__FILE__)
require 'test_helper'

class CloudfilesAuthenticationTest < Test::Unit::TestCase
  def test_good_authentication
    response = ['http://cdn.example.com/storage', 'dummy_token', {'x-cdn-management-url' => 'http://cdn.example.com/path', 'x-storage-url' => 'http://cdn.example.com/storage', 'authtoken' => 'dummy_token'}]
    SwiftClient.stubs(:get_auth).returns(response)
    @connection = stub(:authuser => 'dummy_user', :authkey => 'dummy_key', :cdnmgmthost= => true, :cdnmgmtpath= => true, :cdnmgmtport= => true, :cdnmgmtscheme= => true, :storagehost= => true, :storagepath= => true, :storageport= => true, :storagescheme= => true, :authtoken= => true, :authok= => true, :snet? => false, :auth_url => 'https://auth.api.rackspacecloud.com/v1.0', :cdn_available? => true, :cdn_available= => true, :snet => false)
    result = CloudFiles::Authentication.new(@connection)
    assert_equal result.class, CloudFiles::Authentication
  end
  
  def test_snet_authentication
    response = ['http://cdn.example.com/storage', 'dummy_token', {'x-cdn-management-url' => 'http://cdn.example.com/path', 'x-storage-url' => 'http://cdn.example.com/storage', 'authtoken' => 'dummy_token'}]
    SwiftClient.stubs(:get_auth).returns(response)
    @connection = stub(:authuser => 'dummy_user', :authkey => 'dummy_key', :cdnmgmthost= => true, :cdnmgmtpath= => true, :cdnmgmtport= => true, :cdnmgmtscheme= => true, :storagehost= => true, :storagepath= => true, :storageport= => true, :storagescheme= => true, :authtoken= => true, :authok= => true, :snet? => true, :auth_url => 'https://auth.api.rackspacecloud.com/v1.0', :cdn_available? => true, :cdn_available= => true, :snet => true)
    result = CloudFiles::Authentication.new(@connection)
    assert_equal result.class, CloudFiles::Authentication
  end
  
  def test_bad_authentication
    SwiftClient.stubs(:get_auth).returns(nil)
    @connection = stub(:authuser => 'bad_user', :authkey => 'bad_key', :authok= => true, :authtoken= => true,  :auth_url => 'https://auth.api.rackspacecloud.com/v1.0', :cdn_available? => true, :snet? => false)
    assert_raises(CloudFiles::Exception::Authentication) do
      result = CloudFiles::Authentication.new(@connection)
    end
  end
    
  def test_bad_hostname
    Net::HTTP.stubs(:new).raises(CloudFiles::Exception::Connection)
    @connection = stub(:proxy_host => nil, :proxy_port => nil, :authuser => 'bad_user', :authkey => 'bad_key', :authok= => true, :authtoken= => true, :auth_url => 'https://auth.api.rackspacecloud.com/v1.0', :cdn_available? => true, :snet? => false)
    assert_raises(CloudFiles::Exception::Connection) do
      result = CloudFiles::Authentication.new(@connection)
    end
  end
  
  def test_authentication_general_exception
    SwiftClient.stubs(:get_auth).raises(ClientException.new('foobar'))
    @connection = stub(:proxy_host => nil, :proxy_port => nil, :authuser => 'bad_user', :authkey => 'bad_key', :authok= => true, :authtoken= => true, :auth_url => 'https://auth.api.rackspacecloud.com/v1.0', :cdn_available? => true, :snet? => false)
    assert_raises(CloudFiles::Exception::Connection) do 
      result = CloudFiles::Authentication.new(@connection)
    end
  end
end
