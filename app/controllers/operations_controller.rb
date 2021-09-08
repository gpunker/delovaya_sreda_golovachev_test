class OperationsController < ApiController
    def create
        parameters = operation_params

        user = User.find(parameters[:user_id])

        @operation = Operation.create!(
            name: parameters[:name],
            op_type: parameters[:type],
            total: parameters[:total],
            operation_date: DateTime.now,
            user: user
        )

        render 'operations/show'
    end

    private
    def operation_params
        params.permit(:name, :type, :total, :user_id)
    end
end