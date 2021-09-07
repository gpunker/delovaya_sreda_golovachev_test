json.data do
    json.partial! partial: 'users/user', collection: @users, as: :user
end