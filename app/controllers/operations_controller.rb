class OperationsController < ApplicationController
    def index
        @operations = Operation.all

        render :index
    end
end
