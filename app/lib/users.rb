module Users
  class << self
    FILTER_OPTIONS = {
      table_id: 'user_id',
      date_from: true,
      date_to: true
    }

    EMAIL_EXISTS = {
      email_exists: true,
      message: 'Email already exists.'
    }

    def list params
      users  = User.page(params['page']).per(params['limit'])
      sorted = params[:sorted] || 'user_id:asc'

      users  = users.order(
                ActiveRecordHelper.set_order(
                  sorted,
                  FILTER_OPTIONS[:table_id]
                )
              )

      users  = users.where(
                ActiveRecordHelper.set_filter(
                  params[:filtered],
                  FILTER_OPTIONS
                )
              ) if params[:filtered]

      hash   = UserSerializer.new(users).serializable_hash
      rows   = hash[:data].map do |h| h[:attributes] end

      { pages: users.total_pages, rows: rows }
    end

    def create params
      user = User.find_by email: params[:email]

      return EMAIL_EXISTS if user

      password          = rand 111111...999999
      password_property = { password: password, password_confirmation: password }
      user_result       = User.create user_properties(params).merge(password_property)
      user_path_result  = Path.create user: user_result, value: user_path_properties(params)[:value]

      return if !(user_result && user_path_result)

      # TODO: Create process in sending temporary password to the new user

      { created: true, user_id: user_result.id }
    end

    def find user_id
      user = User.find user_id

      return if !user

      hash = UserSerializer.new(user).serializable_hash
      hash[:data][:attributes]
    end

    def update params
      user = User.find params[:id]

      return if !user
      return EMAIL_EXISTS if !valid_email? user, params[:email]

      user_result = user.update_attributes user_properties(params)
      user_path_result = user.path.update_attributes user_path_properties(params)

      return { updated: true } if user_result && user_path_result
    end

    private

      def valid_email? user, email
        user.update_attributes email: email
      end

      def user_properties params
        {
          first_name: params[:firstName],
          last_name:  params[:lastName],
          email:      params[:email],
          role:       params[:role],
          status:     params[:status],
          redirect:   params[:redirect]
        }
      end

      def user_path_properties params
        {
          value: {
            allowedPaths: params[:allowedPaths],
            excludedPaths: params[:excludedPaths]
          }
        }
      end
  end
end
