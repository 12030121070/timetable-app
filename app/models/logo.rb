# encoding: utf-8

class Logo < ActiveRecord::Base
  attr_accessible :image
  belongs_to :organization
  has_attached_file :image, :styles => { :thumb => '60x60' }
  validates_attachment :image,
                       :content_type => { :content_type => ['image/jpeg', 'image/jpg', 'image/png'] },
                       :presence => true,
                       :size => { :less_than => 1.megabyte }
  validate :dimensions

private
  def dimensions
    return unless ['image/jpeg', 'image/jpg', 'image/png'].include?(image_content_type)
    temp_file = image.queued_for_write[:original]
    unless temp_file.nil?
      dimensions = Paperclip::Geometry.from_file(temp_file)
      width = dimensions.width
      height = dimensions.height

      if width < 128 && height < 128
        errors['image'] << "слишком маленькая картинка"
      end
    end
  end
end
