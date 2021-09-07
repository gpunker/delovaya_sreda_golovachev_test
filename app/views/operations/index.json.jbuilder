json.data do
    json.partial! partial: 'operations/operation', collection: @operations, as: :operation
end