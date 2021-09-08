json.meta do
    json.balance do
        json.balance_start @balance_start
        json.balance_end @balance_end
    end
end
json.data do
    json.partial! partial: 'operations/operation', collection: @operations, as: :operation
end