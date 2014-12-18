class Test < ActiveRecord::Base

  include FriendlyId
  friendly_id :name

  validates_presence_of :name
  validates_uniqueness_of :name

  alias_method :to_param, :friendly_id

end
