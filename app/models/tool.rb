class Tool < ActiveRecord::Base
  attr_accessible :job_id, :name, :usage_count

  belongs_to :job
end
