# frozen_string_literal: true
class User < ActiveRecord::Base
  has_many :identities, inverse_of: :user, dependent: :destroy

  has_many :ads, foreign_key: :user_owner, dependent: :destroy
  has_many :comments, foreign_key: :user_owner, dependent: :destroy

  has_many :friendships
  has_many :friends, through: :friendships

  has_many :receipts, foreign_key: :receiver_id, dependent: :destroy

  has_many :blockings, foreign_key: :blocker_id, dependent: :destroy

  has_many :started_conversations,
           foreign_key: :originator_id,
           class_name: 'Conversation',
           dependent: :nullify

  has_many :received_conversations,
           foreign_key: :recipient_id,
           class_name: 'Conversation',
           dependent: :nullify

  has_many :sent_messages,
           foreign_key: :sender_id,
           class_name: 'Message',
           dependent: :nullify

  before_save :default_lang

  validates :username, presence: true
  validates :username, uniqueness: { case_sensitive: false },
                       format: { without: /\A([^@]+@[^@]+|[1-9]+)\z/ },
                       length: { maximum: 63 },
                       allow_blank: true,
                       if: :username_changed?

  validates :email, presence: true
  validates :email, uniqueness: true,
                    format: { with: /\A[^@]+@[^@]+\z/ },
                    allow_blank: true,
                    if: :email_changed?

  validates :password, presence: true,
                       confirmation: true,
                       if: :password_required?

  validates :password, length: { in: 5..128 }, allow_blank: true

  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :lockable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  scope :top_overall, -> do
    Rails.cache.fetch("user-overall-ranks-#{Ad.cache_digest}") do
      build_rank(Ad)
    end
  end

  scope :top_last_week, -> do
    Rails.cache.fetch("user-last-week-ranks-#{Ad.cache_digest}") do
      build_rank(Ad.last_week)
    end
  end

  scope :top_city_overall, ->(woeid) do
    Rails.cache.fetch("woeid/#{woeid}/overall-rank-#{Ad.cache_digest}") do
      build_rank(Ad.by_woeid_code(woeid))
    end
  end

  scope :top_city_last_week, ->(woeid) do
    Rails.cache.fetch("woeid/#{woeid}/last-week-rank-#{Ad.cache_digest}") do
      build_rank(Ad.last_week.by_woeid_code(woeid))
    end
  end

  scope :whitelisting, ->(user) do
    joined = joins <<-SQL.squish
      LEFT OUTER JOIN blockings
      ON blockings.blocker_id = users.id AND blockings.blocked_id = #{user.id}
    SQL

    joined.where(blockings: { blocker_id: nil })
  end

  def self.build_rank(ads_scope)
    select(:id, :username, 'COUNT(ads.id) as n_ads')
      .joins(:ads)
      .merge(ads_scope.rank_by(:user_owner))
  end

  def self.new_with_session(params, session)
    oauth_session = session['devise.omniauth_data']
    return super unless oauth_session

    oauth = OmniAuth::AuthHash.new(oauth_session)

    new do |u|
      u.email = params[:email] || oauth.info.email
      u.username = params[:username] || oauth.info.name
      u.identities.build(provider: oauth.provider, uid: oauth.uid)
      u.confirmed_at = Time.zone.now if oauth.info.email
    end
  end

  def password_required?
    (new_record? || password || password_confirmation) && identities.none?
  end

  def name
    username
  end

  def to_s
    username
  end

  def mailboxer_email(_object)
    email
  end

  def unread_conversations_count
    Conversation.unread_by(self).size
  end

  def admin?
    role == 1
  end

  # this method is called by devise to check for "active" state of the model
  def active_for_authentication?
    super && locked != 1
  end

  def unlock!
    update_column('locked', 0)
  end

  def lock!
    update_column('locked', 1)
  end

  def default_lang
    self.lang ||= 'es'
  end

  def friend?(user)
    friendships.find_by(friend_id: user.id)
  end

  def blocking?(user)
    blockings.find_by(blocked_id: user.id)
  end

  def whitelisting?(user)
    blocking?(user).nil?
  end

  # nolotirov2 legacy: auth migration - from zend md5 to devise
  # https://github.com/plataformatec/devise/wiki/How-To:-Migration-legacy-database
  def valid_password?(password)
    if legacy_password_hash.present?
      if ::Digest::MD5.hexdigest(password).upcase == legacy_password_hash.upcase
        self.password = password
        self.legacy_password_hash = nil
        save!
        true
      else
        false
      end
    else
      super
    end
  end

  def reset_password(*args)
    self.legacy_password_hash = nil
    super
  end
end
