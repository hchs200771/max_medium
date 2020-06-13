class Story < ApplicationRecord
  include AASM
  extend FriendlyId
  friendly_id :slug_candidate, use: :slugged

  # relationships
  belongs_to :user
  has_one_attached :cover_image

  # validations
  validates :title, presence: true

  # scopes
  default_scope { where(deleted_at: nil) }
  scope :published_stories_with_image, -> { published.with_attached_cover_image.order(created_at: :desc).includes(:user) }

  # instance methods
  def destroy
    update(deleted_at: Time.current)
  end

  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize(transliterations: :russian).to_s
  end

  aasm(column: 'status', no_direct_assignment: true) do
    state :draft, initial: true
    state :published   # 產生published 類別方法來撈出所有狀態是published的story(像是自動設定了 scope)

    event :publish do
      transitions from: :draft, to: :published
      after do
        puts '發布成功'
      end
    end

    event :unpublish do
      transitions from: :published, to: :draft
    end
  end

  private
  def slug_candidate
    [
      :title,
      [:title, SecureRandom.hex[0, 8]]
    ]
  end
end
