class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  default_scope -> { order(created_at: :desc) }

  validates :user_id, :content, presence: true

  validates :content, length: { maximum: 140 }

  validates :image,
            content_type: { in: %w[image/jpeg iamge/gif image/png],
                            message: 'Must be a valid image format' },
            size: { less_than: 5.megabytes,
                    message: 'Should be less than 5MB' }

  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end
