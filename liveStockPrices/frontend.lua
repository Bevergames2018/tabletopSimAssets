function onLoad() 
    Stock1 = getObjectFromGUID("477b2d")
    Stock2 = getObjectFromGUID("3d4db1")
    Stock3 = getObjectFromGUID("77f42a")
    Stock4 = getObjectFromGUID("8e3361")
    Stock5 = getObjectFromGUID("4a9cec")

    -- Set an initial delay before the first update
    Wait.time(updateStockValues, 5)
end

function updateStockValues()
    WebRequest.get("http://localhost/values", function(request)
        if request.is_error then
            log(request.error)
        else
            local str = request.text
            local delimiter = " "

            local i = 1
            for substring in str:gmatch("[^" .. delimiter .. "]+") do
                -- Assign each substring to its own variable
                local variableName = "Stock_" .. i
                _G[variableName] = substring  -- Using _G to create global variables dynamically (not recommended in most cases)

                i = i + 1
            end

            Stock1.call('SetValueTo', Stock_1)
            Stock2.call('SetValueTo', Stock_2)
            Stock3.call('SetValueTo', Stock_3)
            Stock4.call('SetValueTo', Stock_4)
            Stock5.call('SetValueTo', Stock_5)
        end

        -- Schedule the next update after 5 seconds
        Wait.time(updateStockValues, 5)
    end)
end
