class User < ApplicationRecord
  has_one :add_first
  has_one :add_second
  has_one :add_third
  has_one :add_fourth

  def save?
    save ? true : false
  end
end
