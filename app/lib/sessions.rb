require 'jwt'

module Sessions
  class << self
    def auth request, token
      decoded = Sessions.verify_token(token).first
      user = User.find_by(email: decoded['email'])

      @request  = request
      @user     = user
      @password = decoded['password']

      auth_response
    end

    def verify_token token
      JWT.decode token, ENV['JWT_SECRET']
    end

    def auth_bearer headers
      token = http_bearer_token headers
      return token if verify_token http_bearer_token(headers)
      nil
    end

    def sign_out request
      sess = Session.find_by token: auth_bearer(request.headers)
      sess.update_attributes signed_out: true
    end

    private

      attr_reader :request,
                  :user,
                  :password

      INVALID_RESPONSE = {
        status: 404,
        json: { message: "The email or password you entered doesn't match any account." }
      }

      BLOCKED_RESPONSE = {
        status: 401,
        json: { message: 'Your account is blocked. Please contact the administrator.' }
      }

      def auth_response
        if user && user.valid_password?(password)
          return sign_user if user.status.eql? 'active'
          return BLOCKED_RESPONSE if user.status.eql? 'blocked'
        end

        INVALID_RESPONSE
      end

      def sign_user
        user_data = {
          userId:        user.id,
          firstName:     user.first_name,
          lastName:      user.last_name,
          email:         user.email,
          role:          user.role,
          status:        user.status,
          redirect:      user.redirect,
          allowedPaths:  user.path.value['allowedPaths'],
          excludedPaths: user.path.value['excludedPaths']
        }

        token = issue_token user_data

        Session.create(
          user: user,
          ip_address: request.remote_addr,
          user_agent: request.user_agent,
          token: token
        )

        json             = { token: token }
        json['redirect'] = user[:redirect] if user[:redirect].present?

        { status: 200, json: json }
      end

      def issue_token user
        user['date'] = DateTime.now

        JWT.encode user, ENV['JWT_SECRET']
      end

      def http_bearer_token headers
        return headers['Authorization'].split(' ').last if headers['Authorization'].present?
        nil
      end
  end
end
