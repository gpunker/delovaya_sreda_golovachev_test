class BalanceHandler
    class BalanceIsLessThanZeroException < StandardError 
        def message
            'Недостаточно средств.'
        end

        def code
            101
        end
    end;
end