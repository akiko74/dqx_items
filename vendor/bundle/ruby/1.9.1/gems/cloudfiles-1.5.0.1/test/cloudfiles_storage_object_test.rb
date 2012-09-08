$:.unshift File.dirname(__FILE__)
require 'test_helper'

class CloudfilesStorageObjectTest < Test::Unit::TestCase

  def test_object_creation
    build_swift_client_object
    assert_equal @object.name, 'test_object'
    assert_equal @object.class, CloudFiles::StorageObject
    assert_equal @object.to_s, 'test_object'
  end

  def test_object_creation_with_no_cdn_available
    build_swift_client_object(:connection=>{:cdn_available? => false})
    assert_equal @object.name, 'test_object'
    assert_equal @object.class, CloudFiles::StorageObject
    assert_equal @object.to_s, 'test_object'
  end
  
  def test_public_url_exists
    build_swift_client_object(:name => 'test object', :public => true)
    assert_equal @object.public_url, "http://cdn.test.example/test%20object"
  end
  
  def test_public_url_does_not_exist
    build_swift_client_object(:connection => {:cdn_available? => false})
    assert_equal @object.public_url, nil
  end
  
  def test_data_succeeds
    SwiftClient.stubs(:get_object).returns([{"etag"=>"foo", "last-modified"=>"Tue, 21 Jun 2011 19:54:36 GMT", "content-type"=>"text/html", "date"=>"Thu, 15 Sep 2011 22:12:19 GMT", "content-length"=>"17", "accept-ranges"=>"bytes", "x-trans-id"=>"foo"}, "This is good data"])
    build_swift_client_object
    assert_equal @object.data, 'This is good data'
  end
  
  def test_data_with_offset_succeeds
    SwiftClient.stubs(:get_object).returns([{"etag"=>"foo", "last-modified"=>"Tue, 21 Jun 2011 19:54:36 GMT", "content-type"=>"text/html", "date"=>"Thu, 15 Sep 2011 22:12:19 GMT", "content-length"=>"17", "accept-ranges"=>"bytes", "x-trans-id"=>"foo"}, "Thi"])
    build_swift_client_object
    assert_equal @object.data(3), 'Thi'
  end
  
  def test_data_fails
    SwiftClient.stubs(:get_object).raises(ClientException.new("test_data_fails", :http_status => 999))
    build_swift_client_object
    assert_raise(CloudFiles::Exception::NoSuchObject) do
      @object.data
    end
  end
  
  def test_data_stream_succeeds
    SwiftClient.stubs(:get_object).returns([{"etag"=>"foo", "last-modified"=>"Tue, 21 Jun 2011 19:54:36 GMT", "content-type"=>"text/html", "date"=>"Thu, 15 Sep 2011 22:12:19 GMT", "content-length"=>"17", "accept-ranges"=>"bytes", "x-trans-id"=>"foo"}, "This is good data"])
    build_swift_client_object
    data = ""
    assert_nothing_raised do
      @object.data_stream { |chunk|
        data += chunk
      }
    end
  end
  
  def test_data_stream_with_offset_succeeds
    SwiftClient.stubs(:get_object).returns([{"etag"=>"foo", "last-modified"=>"Tue, 21 Jun 2011 19:54:36 GMT", "content-type"=>"text/html", "date"=>"Thu, 15 Sep 2011 22:12:19 GMT", "content-length"=>"5", "accept-ranges"=>"bytes", "x-trans-id"=>"foo"}, "This "])
    build_swift_client_object
    data = ""
    assert_nothing_raised do
      @object.data_stream(5) { |chunk|
        data += chunk
      }
    end
  end
  
  # Need to find a way to simulate this properly
  def data_stream_fails
    SwiftClient.stubs(:get_object).raises(ClientException.new("test_data_stream_fails", :http_status => 404))
    build_swift_client_object
    data = ""
    assert_raise(CloudFiles::Exception::NoSuchObject) do
      @object.data_stream { |chunk|
        data += chunk
      }
    end
  end
  
  def test_set_metadata_succeeds
    SwiftClient.stubs(:post_object).returns(nil)
    build_swift_client_object
    assert_nothing_raised do
      @object.set_metadata({'Foo' =>'bar'})
    end
  end
  
  def test_set_metadata_invalid_object
    SwiftClient.stubs(:post_object).raises(ClientException.new("test_set_metadata_invalid_object", :http_status => 404))
    build_swift_client_object
    assert_raise(CloudFiles::Exception::NoSuchObject) do
      @object.set_metadata({'Foo' =>'bar'})
    end
  end
  
  def test_set_metadata_fails
    SwiftClient.stubs(:post_object).raises(ClientException.new("test_set_metadata_fails", :http_status => 999))
    build_swift_client_object
    assert_raise(CloudFiles::Exception::InvalidResponse) do
      @object.set_metadata({'Foo' =>'bar'})
    end
  end
  
  def test_read_metadata_succeeds
    response = {'x-container-bytes-used' => '42', 'x-container-object-count' => '5', 'x-object-meta-foo' => 'Bar', 'x-object-meta-spam' => ['peanut', 'butter'], 'last-modified' => Time.now.to_s}
    build_swift_client_object
    SwiftClient.stubs(:head_object).returns(response)
    assert_equal @object.metadata, {'foo' => 'Bar', 'spam' => 'peanutbutter'}
  end
  
  def test_write_succeeds
    build_swift_client_object
    SwiftClient.stubs(:put_object).returns("foobarbazquu")
    assert_nothing_raised do
      @object.write("This is test data")
    end
  end
  
  def test_write_with_make_path
    SwiftClient.stubs(:put_object).returns("foobarbazquu")
    SwiftClient.stubs(:head_object).returns({"etag"=>"foo", "last-modified"=>"Tue, 21 Jun 2011 19:54:36 GMT", "content-type"=>"text/html", "date"=>"Thu, 15 Sep 2011 22:12:19 GMT", "content-length"=>"17", "accept-ranges"=>"bytes", "x-trans-id"=>"foo"})
    build_swift_client_object(:name => "path/to/my/test_object", :obj => [false, true])
    assert_nothing_raised do
      @object.write("This is path test data")
    end
  end
  
  def test_load_from_filename_succeeds
    require 'tempfile'
    out = Tempfile.new('test')
    out.write("This is test data")
    out.close
    SwiftClient.stubs(:put_object).returns("foobarbazquu")
    build_swift_client_object
    assert_nothing_raised do
      @object.load_from_filename(out.path)
    end
  end
  
  def test_write_sets_mime_type
    SwiftClient.stubs(:put_object).returns('foobarbazquu')
    build_swift_client_object(:name => 'myfile.xml')
    assert_nothing_raised do
      @object.write("This is test data")
    end
  end
  
  def test_purge_from_cdn_succeeds
    SwiftClient.stubs(:delete_object).returns(true)
    build_swift_client_object(:connection => {:cdn_available? => true})
    assert_nothing_raised do
      @object.purge_from_cdn
      @object.purge_from_cdn("small.fox@hole.org")
    end
  end
  
  def test_write_with_no_data_dies
    build_swift_client_object
    $stdin.stubs(:tty?).returns(true)
    assert_raise(CloudFiles::Exception::Syntax) do
      @object.write(nil)
    end
  end
  
  def test_write_with_invalid_content_length_dies
    SwiftClient.stubs(:put_object).raises(ClientException.new("test_write_with_invalid_content_length_dies", :http_status => '412'))
    build_swift_client_object
    assert_raise(CloudFiles::Exception::InvalidResponse) do
      @object.write('Test Data')
    end
  end
  
  def test_write_with_mismatched_md5_dies
    SwiftClient.stubs(:put_object).raises(ClientException.new("test_write_with_mismatched_md5_dies", :http_status => '422'))
    build_swift_client_object    
    assert_raise(CloudFiles::Exception::MisMatchedChecksum) do
      @object.write('Test Data')
    end
  end
  
  def test_write_with_invalid_response_dies
    SwiftClient.stubs(:put_object).raises(ClientException.new("test_write_with_invalid_response_dies", :http_status => '999'))
    build_swift_client_object
    assert_raise(CloudFiles::Exception::InvalidResponse) do
      @object.write('Test Data')
    end
  end
  
  private
  
  def build_swift_client_object(args = {})
    CloudFiles::Container.any_instance.stubs(:metadata).returns({})
    CloudFiles::Container.any_instance.stubs(:populate).returns(true)
    CloudFiles::Container.any_instance.stubs(:container_metadata).returns({:bytes => 99, :count => 2})
    args[:connection] = {} unless args[:connection]
    connection = stub({:storagehost => 'test.storage.example', :storagepath => '/dummy/path', :storageport => 443, :storagescheme => 'https', :cdnmgmthost => 'cdm.test.example', :cdnmgmtpath => '/dummy/path', :cdnmgmtport => 443, :cdnmgmtscheme => 'https', :cdn_available? => true, :cdnurl => 'http://foo.test.example/container', :storageurl => 'http://foo.test.example/container', :authtoken => "dummy token"}.merge!(args[:connection]))
    args[:response] = {} unless args[:response]
    response = {'x-cdn-management-url' => 'http://cdn.example.com/path', 'x-storage-url' => 'http://cdn.example.com/storage', 'authtoken' => 'dummy_token', 'last-modified' => Time.now.to_s}.merge(args[:response])
    container = CloudFiles::Container.new(connection, 'test_container')
    container.stubs(:connection).returns(connection)
    container.stubs(:public?).returns(args[:public] || false)
    container.stubs(:cdn_url).returns('http://cdn.test.example')
    args[:obj] = [] unless args[:obj]
    @object = CloudFiles::StorageObject.new(container, args[:name] || 'test_object', *args[:obj] )
  end
  
end
