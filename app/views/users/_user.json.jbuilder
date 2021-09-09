json.type 'users'
json.id user.id
json.attributes do
    json.name user.name
    json.balance user.balance.to_f
end