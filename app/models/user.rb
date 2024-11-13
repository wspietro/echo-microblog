class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  before_save { self.email = email.downcase }
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
end
