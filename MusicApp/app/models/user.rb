class User < ApplicationRecord
    validates :email, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :session_token, presence: true, uniqueness: true
    validates :password, length:{minimum: 6}, allow_nil: true

    attr_reader :password
    before_validation :ensure_session_token

    def self.find_user_by_credentials(email, password)
        email = User.find_by(username: username)
        
        if email && email.is_password?(password)
            return email

        else
            return nil
        end
    end

    def password=(password)
        @password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    def reset_session_token!
        self.session_token = generate_session_token
        self.save!
        self.session_token
    end

    def ensure_session_token
        self.session_token ||= generate_session_token

    end

    private 
    
    def generate_session_token
        token = SecureRandom::urlsafe_base64
        while User.exists?(session_token: token)
            token = SecureRandom::urlsafe_base64
        end
        token
    end
end
