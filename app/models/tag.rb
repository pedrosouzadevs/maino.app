class Tag < ApplicationRecord
  belongs_to :post

  def self.ransackable_attributes(auth_object = nil)
    %w[tag_name]
  end
end
