class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :is_participating_this_month, :peers
end
