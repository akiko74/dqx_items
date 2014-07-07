#encoding: utf-8

AWS.config({access_key_id: ENV["AWS_ACCESS_KEY_ID"], secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]})
s3 = AWS::S3.new

Dir::entries('./misc/downloads/before_modify').each do |filename|
  unless filename == '.' || filename == '..'
  file = open('./misc/downloads/before_modify/' + filename)
  obj = s3.buckets['dqxdata'].objects['uploads/'+filename]
  obj.write(Pathname.new(file.path))
  end
end
