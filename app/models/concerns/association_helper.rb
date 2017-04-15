module AssociationHelper
  extend ActiveSupport::Concern

  included do
    belongs_to :user
  end

  def check!
    if self.title.blank? && self.body.blank? && self.text.blank?
      self.delete
    else
      self.save
    end
  end
end