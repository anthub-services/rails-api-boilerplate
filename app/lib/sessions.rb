require 'jwt'

module Sessions
  class << self
    FILTER_OPTIONS = {
      table_id: 'session_id',
      date_from: true,
      date_to: true,
      match: ['user_agent']
    }

    def list params
      sessions = Session.page(params['page']).per(params['limit'])
      sorted   = params[:sorted] || 'session_id:desc'

      sessions = sessions.order(
                   ActiveRecordHelper.set_order(
                     sorted,
                     FILTER_OPTIONS[:table_id]
                   )
                 )

      sessions = sessions.where(
                   ActiveRecordHelper.set_filter(
                     params[:filtered],
                     set_filter_options(params[:filtered])
                   )
                 ) if params[:filtered]

      hash     = SessionSerializer.new(sessions).serializable_hash
      rows     = hash[:data].map do |h| h[:attributes] end

      { pages: sessions.total_pages, rows: rows }
    end

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

      def set_filter_options filtered
        user_where_values = nil

        filtered.split(',').map do |f|
          array = f.split(':')

          if array[0].eql? 'user'
            filter_values     = ActiveRecordHelper.decode_value(array[1])
            user_where_values = ActiveRecordHelper.set_values_tilde filter_values
            break
          end
        end

        filter_options = FILTER_OPTIONS

        if user_where_values.present?
          user = User.where([set_user_where_fields(user_where_values)].concat user_where_values)

          filter_options[:replace] = {
            'user': {
              field: 'user_id',
              value: user.ids,
              type: :integer
            }
          }
        end

        filter_options
      end

      def set_user_where_fields values
        i = 0
        where_tilde = []

        while i < values.count
          where_tilde << "(lower(first_name) || ' ' || lower(last_name)) ~ ?"
          i += 1
        end

        where_tilde.join ' AND '
      end

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
      end
  end
end
