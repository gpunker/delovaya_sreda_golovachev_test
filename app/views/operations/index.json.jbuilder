json.meta do
    json.balance do
        json.balance_start @balance_start.to_f
        json.balance_end @balance_end.to_f
    end
    json.page do
        json.total @meta_total_count
        json.count @meta_count
        json.next_page @meta_next_page
        json.prev_page @meta_prev_page
        json.current_page @page_number
    end
end
json.data do
    json.partial! partial: 'operations/operation', collection: @operations, as: :operation
end