json.type 'operations'
json.id operation.id
json.attributes do
    json.name operation.name
    json.type operation.op_type
    json.sum operation.total.to_f
    json.date operation.operation_date
    json.balance operation.balance.to_f
end