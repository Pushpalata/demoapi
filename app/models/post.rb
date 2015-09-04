class Post < ActiveRecord::Base

  validates :name, :uid, :presence => true

  before_validation :set_uid, :on => :create

  def set_uid
    self.uid = rand(36**7...36**25).to_s(36)
  end
  
end
