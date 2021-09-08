json.type 'operations'
json.id operation.id
json.attributes do
    json.name operation.name
    json.type operation.op_type
    json.sum operation.total
    json.date operation.operation_date
    json.balance operation.balance
end