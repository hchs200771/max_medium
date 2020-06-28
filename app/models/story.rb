class Story < ApplicationRecord
  acts_as_paranoid

  extend FriendlyId
  friendly_id :slug_candidate, use: :slugged

  include AASM

  # relationships
  belongs_to :user
  has_one_attached :cover_image
  has_many :comments
  has_many :bookmarks

  # validations
  validates :title, presence: true

  # scopes
  default_scope { where(deleted_at: nil) }
  scope :published_stories_with_image, -> { published.with_attached_cover_image.order(created_at: :desc).includes(:user) }

  # instance methods

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
