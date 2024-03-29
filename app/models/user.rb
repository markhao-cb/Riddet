# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  validates :username, :password_digest, :session_token, presence: true
  validates :username, :session_token, uniqueness: true
  validates :password, length: { minimum: 6 , allow_nil: true}

  after_initialize :ensure_session_token
  attr_reader :password

  has_many :subs, foreign_key: :moderator_id
  has_many :posts, foreign_key: :author_id

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
    self.session_token
  end

  def self.find_user_by_credential(user_params)
    password = user_params[:password]
    username = user_params[:username]
    user = User.find_by(username:username)
    if user && user.is_password?(password)
      user
    else
      nil
    end
  end
end
