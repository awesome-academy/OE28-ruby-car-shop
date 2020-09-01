class Image < ApplicationRecord
  attr_accessor :image

  belongs_to :post
  mount_uploader :image,
                 ImageUploader,
                 allow_destroy: true,
                 reject_if: (proc do |param|
                   param[:image].blank? && param[:image_cache].blank? &&
                     param[:id].blank?
                 end)

  validates :image, presence: true
end
