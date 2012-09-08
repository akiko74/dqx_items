$:.unshift File.dirname(__FILE__)
require 'test_helper'

class SwiftClientTest < Test::Unit::TestCase
  
  def setup
    @url = "http://foo.bar:1234/auth/v1.0"
    @user = "foo_user"
    @key = "foo_key"
    @token = 'foo_token'
    Net::HTTP.any_instance.stubs(:new).stubs({:port => 1234, :address => 'foo.bar', :class => Net::HTTP})
    @parsed, @conn = SwiftClient.http_connection(@url)
  end
  
  def test_client_exception
    foo = ClientException.new("foobar", :http_status => "404")
    assert_equal "foobar  404", foo.to_s
  end
  
  def test_chunked_connection_wrapper
    file = mock("File")
    file.stubs(:read).returns("this ", "is so", "me da", "ta!", "")
    file.stubs(:eof?).returns(true)
    file.stubs(:eof!).returns(true)
    chunk = ChunkedConnectionWrapper.new(file, 5)
    assert_equal "this ", chunk.read(123)
    assert_equal "is so", chunk.read(123)
    assert_equal "me da", chunk.read(123)
    assert_equal "ta!", chunk.read(123)
    assert_equal true, chunk.eof?
    assert_equal true, chunk.eof!
  end
  
  def test_query
    query = Query.new("foo=bar&baz=quu")
    query.add("chunky", "bacon")
    assert_match /chunky=bacon/, query.to_s
    assert_match /foo=bar/, query.to_s
    assert_match /baz=quu/, query.to_s
    assert query.has_key? "chunky"
    query.delete("chunky")
    assert_equal false, query.has_key?("chunky")
  end
  
  def test_http_connection
    parsed, conn = SwiftClient.http_connection("http://foo.bar:1234/auth/v1.0")
    assert_equal 'http', parsed.scheme
    assert_equal 1234, parsed.port
    assert_equal 'foo.bar', parsed.host
    assert_equal '/auth/v1.0', parsed.path
    assert_equal 'foo.bar', conn.address
    assert_equal 1234, conn.port
    assert_equal Net::HTTP, conn.class
  end
  
  def test_http_connection_with_ssl
    parsed, conn = SwiftClient.http_connection("https://foo.bar:443/auth/v1.0")
    assert_equal 'https', parsed.scheme
    assert_equal 443, parsed.port
    assert_equal 'foo.bar', parsed.host
    assert_equal '/auth/v1.0', parsed.path
    assert_equal 'foo.bar', conn.address
    assert_equal 443, conn.port
    assert_equal Net::HTTP, conn.class
    assert_equal true, conn.use_ssl?
    assert_equal OpenSSL::SSL::VERIFY_NONE, conn.verify_mode
  end
  
  def test_http_connection_with_bad_scheme
    assert_raises(ClientException) do 
      parsed, conn = SwiftClient.http_connection("ftp://foo.bar:443/auth/v1.0")
    end
  end
  
  def test_auth
    response = stub(
      :code => "200", 
      :header => {'x-storage-url' => 'http://foo.bar:1234/v1/AUTH_test', 'x-storage-token' => 'AUTH_test', 'x-auth-token' => 'AUTH_test', 'content-length' => 0, 'date' => 'Tue, 11 Oct 2011 20:54:06 GMT'}
    )
    conn = mock("Net::HTTP")
    conn.stubs(:started?).returns(true)
    conn.stubs(:get).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_nothing_raised do
      storage_url, token, headers = SwiftClient.get_auth(@url, @user, @key)
      assert_equal "http://foo.bar:1234/v1/AUTH_test", storage_url
      assert_equal 'AUTH_test', token
    end
  end
  
  def test_auth_with_snet
    response = stub(
      :code => "200", 
      :header => {'x-storage-url' => 'http://foo.bar:1234/v1/AUTH_test', 'x-storage-token' => 'AUTH_test', 'x-auth-token' => 'AUTH_test', 'content-length' => 0, 'date' => 'Tue, 11 Oct 2011 20:54:06 GMT'}
    )
    conn = mock("Net::HTTP")
    conn.stubs(:started?).returns(true)
    conn.stubs(:get).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_nothing_raised do
      storage_url, token, headers = SwiftClient.get_auth(@url, @user, @key, true)
      assert_equal "http://snet-foo.bar:1234/v1/AUTH_test", storage_url
      assert_equal 'AUTH_test', token
    end
  end
  
  def test_auth_fails
    response = stub(:code => '500', :message => "Internal Server Error")
    conn = mock("Net::HTTP")
    conn.stubs(:address).returns('foobar.com')
    conn.stubs(:port).returns(123)
    conn.stubs(:started?).returns(false)
    conn.stubs(:start).returns(nil)
    conn.stubs(:get).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    
    assert_raise(ClientException) do 
      SwiftClient.get_auth(@url, @user, @key)
    end
  end
  
  #test HEAD account
  def test_head_account
    response = stub(
      :code => "200", 
      :header => {'x-account-object-count' => 123, 'x-account-bytes-used' => 123456, 'x-account-container-count' => 12, 'accept-ranges' => 'bytes', 'content-length' => 12345, 'content-type' => 'application/json; charset=utf-8', 'x-trans-id' => 'txfoobar', 'date' => 'Thu, 13 Oct 2011 21:04:14 GMT'}
    )
    conn = mock("Net::HTTP")
    conn.stubs(:started?).returns(true)
    conn.stubs(:head).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_nothing_raised do
      headers = SwiftClient.head_account(@url, @token)
      assert_equal headers['x-account-object-count'], 123
      assert_equal headers['x-account-bytes-used'], 123456
      assert_equal headers['x-account-container-count'], 12
    end
  end
  
  def test_head_account_fail
    response = stub(
      :code => "500",
      :message => "Internal Error" 
    )
    conn = mock("Net::HTTP")
    conn.stubs(:address).returns("foobar.com")
    conn.stubs(:port).returns(123)
    conn.stubs(:started?).returns(true)
    conn.stubs(:head).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_raise(ClientException) do 
      headers = SwiftClient.head_account(@url, @token)
    end
  end
  
  #test GET account
  def test_get_account
    response = stub(
      :code => "200", 
      :body => '[ { "name":".CDN_ACCESS_LOGS", "count":1, "bytes":1234 }, { "name":"First", "count":2, "bytes":2345 }, { "name":"Second", "count":3, "bytes":3456 }, { "name":"Third", "count":4, "bytes":4567 } ]', 
      :header => {'x-account-object-count' => 123, 'x-account-bytes-used' => 123456, 'x-account-container-count' => 12, 'accept-ranges' => 'bytes', 'content-length' => 12345, 'content-type' => 'application/json; charset=utf-8', 'x-trans-id' => 'txfoobar', 'date' => 'Thu, 13 Oct 2011 21:04:14 GMT'}
    )
    conn = mock("Net::HTTP")
    conn.stubs(:started?).returns(true)
    conn.stubs(:get).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_nothing_raised do
      headers, result = SwiftClient.get_account(@url, @token)
      assert_equal headers, response.header
      assert_equal result, JSON.parse(response.body)
    end
  end
  
  def test_get_account_no_content
    response = stub(
      :code => "204", 
      :body => nil, 
      :header => {'x-account-object-count' => 123, 'x-account-bytes-used' => 123456, 'x-account-container-count' => 12, 'accept-ranges' => 'bytes', 'content-length' => 12345, 'content-type' => 'application/json; charset=utf-8', 'x-trans-id' => 'txfoobar', 'date' => 'Thu, 13 Oct 2011 21:04:14 GMT'}
    )
    conn = mock("Net::HTTP")
    conn.stubs(:started?).returns(true)
    conn.stubs(:get).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_nothing_raised do
      headers, result = SwiftClient.get_account(@url, @token)
      assert_equal headers, response.header
      assert_equal result, []
    end
  end
  
  def test_get_account_marker
    response = stub(
      :code => "200", 
      :body => '[ { "name":"Second", "count":3, "bytes":3456 }, { "name":"Third", "count":4, "bytes":4567 } ]', 
      :header => {'x-account-object-count' => 123, 'x-account-bytes-used' => 123456, 'x-account-container-count' => 12, 'accept-ranges' => 'bytes', 'content-length' => 12345, 'content-type' => 'application/json; charset=utf-8', 'x-trans-id' => 'txfoobar', 'date' => 'Thu, 13 Oct 2011 21:04:14 GMT'}
    )
    conn = mock("Net::HTTP")
    conn.stubs(:started?).returns(true)
    conn.stubs(:get).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_nothing_raised do
      headers, result = SwiftClient.get_account(@url, @token, "First")
      assert_equal headers, response.header
      assert_equal result, JSON.parse(response.body)
    end
  end
  
  def test_get_account_limit
    response = stub(
      :code => "200", 
      :body => '[ { "name":".CDN_ACCESS_LOGS", "count":1, "bytes":1234 }, { "name":"First", "count":2, "bytes":2345 } ]', 
      :header => {'x-account-object-count' => 123, 'x-account-bytes-used' => 123456, 'x-account-container-count' => 12, 'accept-ranges' => 'bytes', 'content-length' => 12345, 'content-type' => 'application/json; charset=utf-8', 'x-trans-id' => 'txfoobar', 'date' => 'Thu, 13 Oct 2011 21:04:14 GMT'}
    )
    conn = mock("Net::HTTP")
    conn.stubs(:started?).returns(true)
    conn.stubs(:get).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_nothing_raised do
      headers, result = SwiftClient.get_account(@url, @token, nil, 2)
      assert_equal headers, response.header
      assert_equal result, JSON.parse(response.body)
    end
  end
  
  def test_get_account_prefix
    response = stub(
      :code => "200", 
      :body => '[ { "name":"First", "count":2, "bytes":2345 } ]', 
      :header => {'x-account-object-count' => 123, 'x-account-bytes-used' => 123456, 'x-account-container-count' => 12, 'accept-ranges' => 'bytes', 'content-length' => 12345, 'content-type' => 'application/json; charset=utf-8', 'x-trans-id' => 'txfoobar', 'date' => 'Thu, 13 Oct 2011 21:04:14 GMT'}
    )
    conn = mock("Net::HTTP")
    conn.stubs(:started?).returns(true)
    conn.stubs(:get).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_nothing_raised do
      headers, result = SwiftClient.get_account(@url, @token, nil, nil, "F")
      assert_equal headers, response.header
      assert_equal result, JSON.parse(response.body)
    end
  end
  
  def test_get_account_full_listing
    response1 = stub(
      :code => "200", 
      :body => '[ { "name":".CDN_ACCESS_LOGS", "count":1, "bytes":1234 }, { "name":"First", "count":2, "bytes":2345 }, { "name":"Second", "count":3, "bytes":3456 }, { "name":"Third", "count":4, "bytes":4567 } ]', 
      :header => {'x-account-object-count' => 123, 'x-account-bytes-used' => 123456, 'x-account-container-count' => 12, 'accept-ranges' => 'bytes', 'content-length' => 12345, 'content-type' => 'application/json; charset=utf-8', 'x-trans-id' => 'txfoobar', 'date' => 'Thu, 13 Oct 2011 21:04:14 GMT'}
    )
    response2 = stub(
      :code => "200", 
      :body => '[ { "name":"Fourth", "count":1, "bytes":1234 }, { "name":"Fifth", "count":2, "bytes":2345 }, { "name":"Sixth", "count":3, "bytes":3456 }, { "name":"Seventh", "count":4, "bytes":4567 } ]', 
      :header => {'x-account-object-count' => 123, 'x-account-bytes-used' => 123456, 'x-account-container-count' => 12, 'accept-ranges' => 'bytes', 'content-length' => 12345, 'content-type' => 'application/json; charset=utf-8', 'x-trans-id' => 'txfoobar', 'date' => 'Thu, 13 Oct 2011 21:04:14 GMT'}
    )
    response3 = stub(
      :code => "200", 
      :body => '[]', 
      :header => {'x-account-object-count' => 123, 'x-account-bytes-used' => 123456, 'x-account-container-count' => 12, 'accept-ranges' => 'bytes', 'content-length' => 12345, 'content-type' => 'application/json; charset=utf-8', 'x-trans-id' => 'txfoobar', 'date' => 'Thu, 13 Oct 2011 21:04:14 GMT'}
    )
    
    conn = mock("Net::HTTP")
    conn.stubs(:started?).returns(true)
    conn.stubs(:get).at_least(3).at_most(3).returns(response1, response2, response3)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_nothing_raised do
      headers, result = SwiftClient.get_account(@url, @token, nil, nil, nil, nil, true)
      assert_equal headers, response1.header
      assert_equal JSON.parse(response1.body) + JSON.parse(response2.body) + JSON.parse(response3.body), result
    end
  end
  
  def test_get_account_fail
    response = stub(
      :code => "500",
      :message => "Internal Error"
    )
    conn = mock("Net::HTTP")
    conn.stubs(:address).returns("foobar.com")
    conn.stubs(:port).returns(123)
    conn.stubs(:started?).returns(true)
    conn.stubs(:get).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_raise(ClientException) do 
      headers = SwiftClient.get_account(@url, @token)
    end
  end
  
  #test POST account
  def test_post_account
    response = stub(:code => 204, :body => nil)
    conn = mock("Net::HTTP")
    conn.stubs(:started?).returns(true)
    conn.stubs(:post).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_nothing_raised do
      SwiftClient.post_account(@url, @token, {"foo" => "bar"})
    end    
  end
  
  def test_post_account_fail
    response = stub(
      :code => "500",
      :message => "Internal Error"
    )
    conn = mock("Net::HTTP")
    conn.stubs(:address).returns("foobar.com")
    conn.stubs(:port).returns(123)
    conn.stubs(:started?).returns(true)
    conn.stubs(:post).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_raise(ClientException) do 
      headers = SwiftClient.post_account(@url, @token, {"foo" => "bar"})
    end
  end
  
  #test HEAD container
  def test_head_container
    response = stub(
      :code => "204", 
      :header => {'x-container-object-count' => 6, 'x-container-meta-baz' => 'que', 'x-container-meta-foo' => 'bar', 'x-container-bytes-used' => 123456, 'accept-ranges' => 'bytes', 'content-length' => 83, 'content-type' => 'text/plain; charset=utf-8', 'x-trans-id' => 'txfoo123', 'date' => 'Thu, 13 Oct 2011 22:29:14 GMT'}
    )
    conn = mock("Net::HTTP")
    conn.stubs(:started?).returns(true)
    conn.stubs(:head).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_nothing_raised do
      headers = SwiftClient.head_container(@url, @token, 'test_container')
      assert_equal headers, response.header
    end
  end
  
  def test_head_container_fail
    response = stub(:code => "500", :message => "failed")
    conn = mock("Net::HTTP")
    conn.stubs(:address).returns("foobar.com")
    conn.stubs(:port).returns(123)
    conn.stubs(:started?).returns(true)
    conn.stubs(:head).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    
    assert_raise(ClientException) do
      headers, result = SwiftClient.head_container(@url, @token, 'test_container')
    end
  end
  
  #test GET container
  def test_get_container
    response = stub(
      :code => "200", 
      :header => {'x-container-object-count' => 6, 'x-container-meta-baz' => 'que', 'x-container-meta-foo' => 'bar', 'x-container-bytes-used' => 123456, 'accept-ranges' => 'bytes', 'content-length' => 83, 'content-type' => 'text/plain; charset=utf-8', 'x-trans-id' => 'txfoo123', 'date' => 'Thu, 13 Oct 2011 22:29:14 GMT'}, 
      :body => '[ { "name":"foo.mp4", "hash":"foo_hash", "bytes":1234567, "content_type":"video/mp4", "last_modified":"2011-06-21T19:49:06.607670" }, { "name":"bar.ogv", "hash":"bar_hash", "bytes":987654, "content_type":"video/ogg", "last_modified":"2011-06-21T19:48:57.504050" }, { "name":"baz.webm", "hash":"baz_hash", "bytes":1239874, "content_type":"application/octet-stream", "last_modified":"2011-06-21T19:48:43.923990" }, { "name":"fobarbaz.html", "hash":"foobarbaz_hash", "bytes":12893467, "content_type":"text/html", "last_modified":"2011-06-21T19:54:36.555070" } ]'
    )
    conn = mock("Net::HTTP")
    conn.stubs(:started?).returns(true)
    conn.stubs(:get).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_nothing_raised do
      headers, result = SwiftClient.get_container(@url, @token, 'test_container')
      assert_equal headers, response.header
      assert_equal result, JSON.parse(response.body)
    end
  end
  
  
  def test_get_container_no_content
    response = stub(
      :code => "204", 
      :body => nil, 
      :header => {'x-container-object-count' => 123, 'x-container-bytes-used' => 123456, 'x-container-object-count' => 12, 'accept-ranges' => 'bytes', 'content-length' => 12345, 'content-type' => 'application/json; charset=utf-8', 'x-trans-id' => 'txfoobar', 'date' => 'Thu, 13 Oct 2011 21:04:14 GMT'}
    )
    conn = mock("Net::HTTP")
    conn.stubs(:started?).returns(true)
    conn.stubs(:get).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_nothing_raised do
      headers, result = SwiftClient.get_container(@url, @token, 'test_container')
      assert_equal headers, response.header
      assert_equal result, []
    end
  end
  
  def test_get_container_marker
    response = stub(
      :code => "200", 
      :body => '[ { "name":"bar.ogv", "hash":"bar_hash", "bytes":987654, "content_type":"video/ogg", "last_modified":"2011-06-21T19:48:57.504050" }, { "name":"baz.webm", "hash":"baz_hash", "bytes":1239874, "content_type":"application/octet-stream", "last_modified":"2011-06-21T19:48:43.923990" }, { "name":"fobarbaz.html", "hash":"foobarbaz_hash", "bytes":12893467, "content_type":"text/html", "last_modified":"2011-06-21T19:54:36.555070" } ]',
      :header => {'x-container-object-count' => 123, 'x-container-bytes-used' => 123456, 'x-container-object-count' => 12, 'accept-ranges' => 'bytes', 'content-length' => 12345, 'content-type' => 'application/json; charset=utf-8', 'x-trans-id' => 'txfoobar', 'date' => 'Thu, 13 Oct 2011 21:04:14 GMT'}
    )
    conn = mock("Net::HTTP")
    conn.stubs(:started?).returns(true)
    conn.stubs(:get).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_nothing_raised do
      headers, result = SwiftClient.get_container(@url, @token, "test_container", "foo.mp4")
      assert_equal headers, response.header
      assert_equal result, JSON.parse(response.body)
    end
  end
  
  def test_get_container_limit
    response = stub(
      :code => "200", 
      :body => '[ { "name":"foo.mp4", "hash":"foo_hash", "bytes":1234567, "content_type":"video/mp4", "last_modified":"2011-06-21T19:49:06.607670" }, { "name":"bar.ogv", "hash":"bar_hash", "bytes":987654, "content_type":"video/ogg", "last_modified":"2011-06-21T19:48:57.504050" } ]',
      :header => {'x-container-object-count' => 123, 'x-container-bytes-used' => 123456, 'x-container-object-count' => 12, 'accept-ranges' => 'bytes', 'content-length' => 12345, 'content-type' => 'application/json; charset=utf-8', 'x-trans-id' => 'txfoobar', 'date' => 'Thu, 13 Oct 2011 21:04:14 GMT'}
    )
    conn = mock("Net::HTTP")
    conn.stubs(:started?).returns(true)
    conn.stubs(:get).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_nothing_raised do
      headers, result = SwiftClient.get_container(@url, @token, 'test_container', nil, 2)
      assert_equal headers, response.header
      assert_equal result, JSON.parse(response.body)
      assert_equal result.length, 2
    end
  end
  
  def test_get_container_prefix
    response = stub(
      :code => "200", 
      :body => '[ { "name":"bar.ogv", "hash":"bar_hash", "bytes":987654, "content_type":"video/ogg", "last_modified":"2011-06-21T19:48:57.504050" }, { "name":"baz.webm", "hash":"baz_hash", "bytes":1239874, "content_type":"application/octet-stream", "last_modified":"2011-06-21T19:48:43.923990" }]',
      :header => {'x-container-object-count' => 123, 'x-container-bytes-used' => 123456, 'x-container-object-count' => 12, 'accept-ranges' => 'bytes', 'content-length' => 12345, 'content-type' => 'application/json; charset=utf-8', 'x-trans-id' => 'txfoobar', 'date' => 'Thu, 13 Oct 2011 21:04:14 GMT'}
    )
    conn = mock("Net::HTTP")
    conn.stubs(:started?).returns(true)
    conn.stubs(:get).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_nothing_raised do
      headers, result = SwiftClient.get_container(@url, @token, 'test_container', nil, nil, "b")
      assert_equal headers, response.header
      assert_equal result, JSON.parse(response.body)
    end
  end

  def test_get_container_full_listing
    response1 = stub(
      :code => "200", 
      :header => {'x-container-object-count' => 6, 'x-container-meta-baz' => 'que', 'x-container-meta-foo' => 'bar', 'x-container-bytes-used' => 123456, 'accept-ranges' => 'bytes', 'content-length' => 83, 'content-type' => 'text/plain; charset=utf-8', 'x-trans-id' => 'txfoo123', 'date' => 'Thu, 13 Oct 2011 22:29:14 GMT'}, 
      :body => '[ { "name":"foo.mp4", "hash":"foo_hash", "bytes":1234567, "content_type":"video/mp4", "last_modified":"2011-06-21T19:49:06.607670" }, { "name":"bar.ogv", "hash":"bar_hash", "bytes":987654, "content_type":"video/ogg", "last_modified":"2011-06-21T19:48:57.504050" }, { "name":"baz.webm", "hash":"baz_hash", "bytes":1239874, "content_type":"application/octet-stream", "last_modified":"2011-06-21T19:48:43.923990" }, { "name":"fobarbaz.html", "hash":"foobarbaz_hash", "bytes":12893467, "content_type":"text/html", "last_modified":"2011-06-21T19:54:36.555070" } ]'
    )
    response2 = stub(
      :code => "200", 
      :header => {'x-container-object-count' => 6, 'x-container-meta-baz' => 'que', 'x-container-meta-foo' => 'bar', 'x-container-bytes-used' => 123456, 'accept-ranges' => 'bytes', 'content-length' => 83, 'content-type' => 'text/plain; charset=utf-8', 'x-trans-id' => 'txfoo123', 'date' => 'Thu, 13 Oct 2011 22:29:14 GMT'}, 
      :body => '[ { "name":"foo2.mp4", "hash":"foo_hash", "bytes":1234567, "content_type":"video/mp4", "last_modified":"2011-06-21T19:49:06.607670" }, { "name":"bar2.ogv", "hash":"bar_hash", "bytes":987654, "content_type":"video/ogg", "last_modified":"2011-06-21T19:48:57.504050" }, { "name":"baz2.webm", "hash":"baz_hash", "bytes":1239874, "content_type":"application/octet-stream", "last_modified":"2011-06-21T19:48:43.923990" }, { "name":"fobarbaz2.html", "hash":"foobarbaz_hash", "bytes":12893467, "content_type":"text/html", "last_modified":"2011-06-21T19:54:36.555070" } ]'
    )
    response3 = stub(
      :code => "200", 
      :header => {'x-container-object-count' => 6, 'x-container-meta-baz' => 'que', 'x-container-meta-foo' => 'bar', 'x-container-bytes-used' => 123456, 'accept-ranges' => 'bytes', 'content-length' => 83, 'content-type' => 'text/plain; charset=utf-8', 'x-trans-id' => 'txfoo123', 'date' => 'Thu, 13 Oct 2011 22:29:14 GMT'}, 
      :body => '[]'
    )
    
    conn = mock("Net::HTTP")
    conn.stubs(:started?).returns(true)
    conn.stubs(:get).at_least(3).at_most(3).returns(response1, response2, response3)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_nothing_raised do
      headers, result = SwiftClient.get_container(@url, @token, 'test_container', nil, nil, nil, nil, nil, true)
      assert_equal headers, response1.header
      assert_equal JSON.parse(response1.body) + JSON.parse(response2.body) + JSON.parse(response3.body), result
    end
  end
  
  def test_get_container_fail
    response = stub(:code => "500", :message => "failed")
    conn = mock("Net::HTTP")
    conn.stubs(:address).returns("foobar.com")
    conn.stubs(:port).returns(123)
    conn.stubs(:started?).returns(true)
    conn.stubs(:get).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    
    assert_raise(ClientException) do
      headers, result = SwiftClient.get_container(@url, @token, 'test_container')
    end
  end
  
  #test PUT container
  def test_put_container
    response = stub(:code => "200")
    conn = mock("Net::HTTP")
    conn.stubs(:started?).returns(true)
    conn.stubs(:put).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    
    assert_nothing_raised do
      headers, result = SwiftClient.put_container(@url, @token, 'test_container')
    end
  end
  
  def test_put_container_fail
    response = stub(:code => "500", :message => "failed")
    conn = mock("Net::HTTP")
    conn.stubs(:address).returns("foobar.com")
    conn.stubs(:port).returns(123)
    conn.stubs(:started?).returns(true)
    conn.stubs(:put).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    
    assert_raise(ClientException) do
      headers, result = SwiftClient.put_container(@url, @token, 'test_container')
    end
  end
  
  #test POST container
  def test_post_container
    response = stub(:code => "200")
    conn = mock("Net::HTTP")
    conn.stubs(:started?).returns(true)
    conn.stubs(:post).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    
    assert_nothing_raised do
      headers, result = SwiftClient.post_container(@url, @token, 'test_container', {'x-container-metadata-foo' => 'bar'})
    end
  end
  
  def test_post_container_fail
    response = stub(:code => "500", :message => "failed")
    conn = mock("Net::HTTP")
    conn.stubs(:address).returns("foobar.com")
    conn.stubs(:port).returns(123)
    conn.stubs(:started?).returns(true)
    conn.stubs(:post).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    
    assert_raise(ClientException) do
      headers, result = SwiftClient.post_container(@url, @token, 'test_container', {'x-container-metadata-foo' => 'bar'})
    end
  end
  
  #test DELETE container
  def test_delete_container
    response = stub(:code => "200", :body => "")
    conn = mock("Net::HTTP")
    conn.stubs(:started?).returns(true)
    conn.stubs(:delete).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    
    assert_nothing_raised do
      SwiftClient.delete_container(@url, @token, 'test_container')
    end
  end

  def test_delete_container_fails
    response = stub(:code => "500", :message => "failed")
    conn = mock("Net::HTTP")
    conn.stubs(:address).returns("foobar.com")
    conn.stubs(:port).returns(123)
    conn.stubs(:started?).returns(true)
    conn.stubs(:delete).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    
    assert_raise(ClientException) do
      SwiftClient.delete_container(@url, @token, 'test_container')
    end
  end
    
  #test HEAD object
  def test_head_object
    response = stub(:code => "204", :header => {'etag' => 'etag_foobarbaz', 'accept-ranges' => 'bytes', 'content-length' => 67773, 'content-type' => 'application/javascript', 'x-trans-id' => 'txfoobar', 'date' => 'Fri, 14 Oct 2011 01:21:42 GMT'})
    conn = mock("Net::HTTP")
    conn.stubs(:port).returns(123)
    conn.stubs(:started?).returns(true)
    conn.stubs(:head).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    
    headers = SwiftClient.head_object(@url, @token, 'test_container', 'test_object')
    assert_equal response.header, headers
  end
  
  def test_head_object_fails
    response = stub(:code => "500", :message => "failed")
    conn = mock("Net::HTTP")
    conn.stubs(:address).returns("foobar.com")
    conn.stubs(:port).returns(123)
    conn.stubs(:started?).returns(true)
    conn.stubs(:head).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    
    assert_raise(ClientException) do
      headers = SwiftClient.head_object(@url, @token, 'test_container', 'test_object')
    end
  end
  
  #test GET object
  def test_get_object
    response = stub(
      :code => "200",
      :header => {'etag' => 'etag_foobarbaz', 'accept-ranges' => 'bytes', 'content-length' => 67773, 'content-type' => 'application/javascript', 'x-trans-id' => 'txfoobar', 'date' => 'Fri, 14 Oct 2011 01:21:42 GMT'},
      :body => "this is the body"
    )
    conn = mock("Net::HTTP")
    conn.stubs(:port).returns(123)
    conn.stubs(:address).returns("foobar.com")
    conn.stubs(:started?).returns(true)
    conn.stubs(:request_get).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    
    assert_nothing_raised do 
      headers, body = SwiftClient.get_object(@url, @token, 'test_container', 'test_object')
      assert_equal response.header, headers
      assert_equal body, "this is the body"
    end
  end
  
  def test_get_object_fails
    response = stub(:code => "404", :message => "object not found", :body => "")
    conn = mock("Net::HTTP")
    conn.stubs(:port).returns(123)
    conn.stubs(:address).returns("foobar.com")
    conn.stubs(:started?).returns(true)
    conn.stubs(:request_get).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    
    assert_raise(ClientException) do
      headers, body = SwiftClient.get_object(@url, @token, 'test_container', 'test_object')
    end
  end
  
  #test PUT object
  def test_put_object
    response = stub(
      :code => "201", 
      :header => {"Content-Length" => 118, "Content-Type" => "text/html; charset=UTF-8", "Etag" => "asfasdfsdafasd2313241ukyhuyhj", "X-Trans-Id" => "txfoo1231231231232123"}, 
      :message => "created", 
      :body => ""
    )
    conn = mock("Net::HTTP")
    conn.stubs(:port).returns(123)
    conn.stubs(:address).returns("foobar.com")
    conn.stubs(:started?).returns(true)
    conn.stubs(:put).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_nothing_raised do
      SwiftClient.put_object(@url, @token, 'test_container', 'test_object', 'some data to put', 16)
    end
  end
  
  def test_put_object_fails
    response = stub(
      :code => "500", 
      :message => "internal server error", 
      :body => ""
    )
    conn = mock("Net::HTTP")
    conn.stubs(:port).returns(123)
    conn.stubs(:address).returns("foobar.com")
    conn.stubs(:started?).returns(true)
    conn.stubs(:put).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_raise(ClientException) do
      SwiftClient.put_object(@url, @token, 'test_container', 'test_object', 'some data to put', 16)
    end
  end
  
  #test POST object
  def test_post_object
    response = stub(
      :code => "201", 
      :header => {"Content-Length" => 118, "Content-Type" => "text/html; charset=UTF-8", "Etag" => "asfasdfsdafasd2313241ukyhuyhj", "X-Trans-Id" => "txfoo1231231231232123", "X-Object-Meta-Foo" => "Bar"}, 
      :message => "created", 
      :body => ""
    )
    conn = mock("Net::HTTP")
    conn.stubs(:port).returns(123)
    conn.stubs(:address).returns("foobar.com")
    conn.stubs(:started?).returns(true)
    conn.stubs(:post).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_nothing_raised do
      headers = SwiftClient.post_object(@url, @token, 'test_container', 'test_object', {"Foo" => "Bar"})
    end
  end
  
  def test_post_object_fails
    response = stub(
      :code => "404", 
      :message => "no such object", 
      :body => ""
    )
    conn = mock("Net::HTTP")
    conn.stubs(:port).returns(123)
    conn.stubs(:address).returns("foobar.com")
    conn.stubs(:started?).returns(true)
    conn.stubs(:post).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_raise(ClientException) do
      SwiftClient.post_object(@url, @token, 'test_container', 'test_object', {"foo" => "bar"})
    end
  end

  #test DELETE object
  def test_delete_object
    response = stub(
      :code => "204", 
      :message => "no content",
      :body => ""
    )
    conn = mock("Net::HTTP")
    conn.stubs(:started?).returns(true)
    conn.stubs(:delete).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_nothing_raised do
      SwiftClient.delete_object(@url, @token, 'test_container', 'test_object')
    end
  end
  
  def test_delete_object_fails
    response = stub(
      :code => "404", 
      :message => "no such object",
      :body => ""
    )
    conn = mock("Net::HTTP")
    conn.stubs(:port).returns(123)
    conn.stubs(:address).returns("foobar.com")
    conn.stubs(:started?).returns(true)
    conn.stubs(:delete).returns(response)
    SwiftClient.expects(:http_connection).returns([@parsed, conn])
    assert_raise(ClientException) do
      SwiftClient.delete_object(@url, @token, 'test_container', 'test_object')
    end
  end
  
  def test_retry_failse
    auth_response = ['http://foo.bar:1234/v1/AUTH_test', 'AUTH_test', {'x-storage-url' => 'http://foo.bar:1234/v1/AUTH_test', 'x-storage-token' => 'AUTH_test', 'x-auth-token' => 'AUTH_test', 'content-length' => 0, 'date' => 'Tue, 11 Oct 2011 20:54:06 GMT'}]
    SwiftClient.expects(:get_auth).returns(auth_response)
    SwiftClient.any_instance.stubs(:http_connection).raises(ClientException.new("foobar"))
    sc = SwiftClient.new(@url, @user, @key)
    sc.get_auth
    assert_raise(ClientException) do 
      sc.get_container("test_container")
    end
  end

  def test_oop_swiftclient
    auth_response = ['http://foo.bar:1234/v1/AUTH_test', 'AUTH_test', {'x-storage-url' => 'http://foo.bar:1234/v1/AUTH_test', 'x-storage-token' => 'AUTH_test', 'x-auth-token' => 'AUTH_test', 'content-length' => 0, 'date' => 'Tue, 11 Oct 2011 20:54:06 GMT'}]
    account_response = [
      {'x-account-object-count' => 123, 'x-account-bytes-used' => 123456, 'x-account-container-count' => 12, 'accept-ranges' => 'bytes', 'content-length' => 12345, 'content-type' => 'application/json; charset=utf-8', 'x-trans-id' => 'txfoobar', 'date' => 'Thu, 13 Oct 2011 21:04:14 GMT'},
      JSON.parse('[ { "name":".CDN_ACCESS_LOGS", "count":1, "bytes":1234 }, { "name":"First", "count":2, "bytes":2345 }, { "name":"Second", "count":3, "bytes":3456 }, { "name":"Third", "count":4, "bytes":4567 } ]')
    ]
    container_response = [
      {'x-container-object-count' => 6, 'x-container-meta-baz' => 'que', 'x-container-meta-foo' => 'bar', 'x-container-bytes-used' => 123456, 'accept-ranges' => 'bytes', 'content-length' => 83, 'content-type' => 'text/plain; charset=utf-8', 'x-trans-id' => 'txfoo123', 'date' => 'Thu, 13 Oct 2011 22:29:14 GMT'}, 
      JSON.parse('[ { "name":"foo.mp4", "hash":"foo_hash", "bytes":1234567, "content_type":"video/mp4", "last_modified":"2011-06-21T19:49:06.607670" }, { "name":"bar.ogv", "hash":"bar_hash", "bytes":987654, "content_type":"video/ogg", "last_modified":"2011-06-21T19:48:57.504050" }, { "name":"baz.webm", "hash":"baz_hash", "bytes":1239874, "content_type":"application/octet-stream", "last_modified":"2011-06-21T19:48:43.923990" }, { "name":"fobarbaz.html", "hash":"foobarbaz_hash", "bytes":12893467, "content_type":"text/html", "last_modified":"2011-06-21T19:54:36.555070" } ]')
    ]
    object_response = [
      {'Last-Modified' => 'Tue, 01 Jan 2011 00:00:01 GMT', 'Etag' => 'somelarge123hashthingy123foobar', 'Accept-Ranges' => 'bytes', 'Content-Length' => 29, 'Content-Type' => 'application/x-www-form-urlencoded', 'X-Trans-Id' => 'txffffffff00000001231231232112321', 'Date' => 'Tue, 01 Jan 2011 00:00:02 GMT', 'foo' => 'bar'},
      "some data that is from swift"
    ]
    SwiftClient.expects(:http_connection).returns(Net::HTTPExceptions, [@parsed, @conn])
    SwiftClient.expects(:get_auth).returns(auth_response)
    SwiftClient.expects(:get_account).returns(account_response)
    SwiftClient.expects(:head_account).returns(account_response[0])
    SwiftClient.expects(:post_account).returns(nil)
    SwiftClient.expects(:get_container).returns(container_response)
    SwiftClient.expects(:head_container).returns(container_response[0])
    SwiftClient.expects(:put_container).returns(nil)
    SwiftClient.expects(:post_container).returns(nil)
    SwiftClient.expects(:delete_container).returns(nil)
    SwiftClient.expects(:get_object).returns(object_response)
    SwiftClient.expects(:head_object).returns(object_response[0])
    SwiftClient.expects(:put_object).returns(nil)
    SwiftClient.expects(:post_object).returns(nil)
    SwiftClient.expects(:delete_object).returns(nil)
    
    assert_nothing_raised do
      sc = SwiftClient.new(@url, @user, @key)
      #test account
      sc.get_auth
      get_a   = sc.get_account
      assert_equal 123456, get_a[0]['x-account-bytes-used']
      assert_equal 123, get_a[0]['x-account-object-count']
      assert_equal 'First', get_a[1][1]['name']
      head_a  = sc.head_account
      assert_equal 123456, head_a['x-account-bytes-used']
      assert_equal 123, head_a['x-account-object-count']
      sc.post_account({'foo'=>'bar'})
      #test container
      get_c   = sc.get_container('test_container')
      assert_equal 'foo.mp4', get_c[1][0]['name']
      assert_equal 6, get_c[0]['x-container-object-count']
      assert_equal 'bar', get_c[0]['x-container-meta-foo']
      head_c  = sc.head_container('test_container')
      assert_equal 6, head_c['x-container-object-count']
      assert_equal 'bar', head_c['x-container-meta-foo']
      sc.put_container('test_container')
      sc.post_container('test_container', {'foo' => 'bar'})
      sc.delete_container('test_container')
      #test object
      get_o   = sc.get_object('test_container', 'test_object')
      assert_equal "some data that is from swift", get_o[1] 
      assert_equal "somelarge123hashthingy123foobar", get_o[0]['Etag']
      head_o  = sc.head_object('test_container', 'test_object')
      assert_equal "somelarge123hashthingy123foobar", head_o['Etag']
      sc.put_object('test_container', 'test_object', 'some data to put up')
      sc.post_object('test_container', 'test_object', {"foo" => "bar"})
      sc.delete_object('test_container', 'test_object')
    end
  end
end
