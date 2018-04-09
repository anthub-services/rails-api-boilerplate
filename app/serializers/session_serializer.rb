class SessionSerializer
  include FastJsonapi::ObjectSerializer

  set_key_transform :camel_lower

  attribute         :sessionId do |object| object.id end

  attribute         :user do |object|
                      {
                        userId: object.user_id,
                        name: object.user.full_name
                      }
                    end

  attributes        :user_agent,
                    :ip_address,
                    :created_at

  attribute         :signed_out_at do |object|
                      object.updated_at if object.signed_out?
                    end
end
