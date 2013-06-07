class Outlet < ActiveRecord::Base
  attr_accessible :uuid, :name, :room, :state
end
