class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  attr_accessor :remember_token

  before_save { self.email = email.downcase }
  before_validation { self.name = name.squish }
  # before_save { email.downcase! } - podemos utilizar bang method para alterar o atributo diretamente
  validates :name, { presence: true, length: { maximum: 50 } }
  validates :email, {
                      presence: true,
                      length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: true,
                    # uniqueness: { case_sensitive: false }, - não mais necessário pq temos before_save. melhor pratica para o db index
                    }
  has_secure_password
  validates :password, { presence: true, length: { minimum: 6 } }

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random roken.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the databse for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
end
