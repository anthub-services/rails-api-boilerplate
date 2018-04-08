class UserSerializer
  include FastJsonapi::ObjectSerializer

  set_key_transform :camel_lower

  attribute         :userId do |object| object.id end

  attributes        :first_name,
                    :last_name,
                    :email,
                    :role,
                    :status,
                    :redirect,
                    :created_at

  attribute         :allowedPaths do |object| object.path.value['allowedPaths'] end
  attribute         :excludedPaths do |object| object.path.value['excludedPaths'] end
end
