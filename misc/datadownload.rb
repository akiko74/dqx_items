# encoding: utf-8


AWS.config({access_key_id: ENV["AWS_ACCESS_KEY_ID"], secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]})
s3 = AWS::S3.new

dirname = './misc/downloads/'
s3.buckets['dqxdata'].objects.with_prefix('before_modify/dq10').each do |obj|
  File.open(dirname+obj.key, 'wb') do |file|
    obj.read do |chunk|
      file.write(chunk)
    end
  end
end
