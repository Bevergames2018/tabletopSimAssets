index = 1

textOptions = {
    fontSize = 50,
    color = "rgba(1, 1, 1, 1)",
    alignment = "MiddleCenter",
    fontStyle = "bold"
}


function updateAllStock()
    index = index + 1
    updateStock("AAPL", index)
    updateStock("AMD", index)
    updateStock("IBM", index)
    updateStock("NVDA", index)
    updateStock("RYAAY", index)
end

function resetIndex()
    index = 1
    updateStock("AAPL", index)
    updateStock("AMD", index)
    updateStock("IBM", index)
    updateStock("NVDA", index)
    updateStock("RYAAY", index)
end

function onload()
    self.locked = true
    AAPL = getObjectFromGUID("477b2d")
    AMD = getObjectFromGUID("3d4db1")
    IBM = getObjectFromGUID("77f42a")
    NVDA = getObjectFromGUID("8e3361")
    RYAAY = getObjectFromGUID("4a9cec")

    self.addContextMenuItem("Update stocks", updateAllStock)
    self.addContextMenuItem("Reset stocks", resetIndex)

    self.UI.setAttributes("stockUpdateText", textOptions)
    self.createButton({
        function_owner = self,
        click_function = "updateAllStock",
        position={0, 0.1, 0},
        color = {0, 0, 0, 0},
        height = 750,
        width = 1450,
    })

    updateStock("AAPL", index)
    updateStock("AMD", index)
    updateStock("IBM", index)
    updateStock("NVDA", index)
    updateStock("RYAAY", index)
end

function parseJson(json_str)
    local result = {}

    -- Remove the outer brackets
    json_str = json_str:match("%[(.*)%]")

    -- Iterate through each object in the JSON array
    for obj in json_str:gmatch("{(.-)}") do
        local entry = {}

      -- Extract index
        entry.index = tonumber(obj:match('"index"%s*:%s*(%d+)'))

      -- Extract Open value
        entry.Open = obj:match('"Open"%s*:%s*"([^"]+)"')

        table.insert(result, entry)
    end

    return result
end

function getOpenValueByIndex(data, target_index)
    for _, entry in ipairs(data) do
        if entry.index == target_index then
            return entry.Open
        end
    end
    return nil -- Return nil if the index is not found
end

function updateStock(stockSymbol, target_index)
    WebRequest.get("https://raw.githubusercontent.com/Bevergames2018/tabletopSimAssets/main/liveStockPrices/stocks/" .. stockSymbol .. ".json", function(sym)
        if sym.is_error then
            log(sym.error)
        else
            local stock = sym.text
            -- Parse the JSON data
            local data = parseJson(stock)


            -- Specify the index you want to get the "Open" value from
            stockPrice = (math.floor(getOpenValueByIndex(data, target_index)*100))/100


            if stockPrice then
                if stockSymbol == "AAPL" then AAPL.call('SetValueTo', stockPrice)
                elseif stockSymbol == "AMD" then AMD.call('SetValueTo', stockPrice)
                elseif stockSymbol == "IBM" then IBM.call('SetValueTo', stockPrice)
                elseif stockSymbol == "NVDA" then NVDA.call('SetValueTo', stockPrice)
                elseif stockSymbol == "RYAAY" then RYAAY.call('SetValueTo', stockPrice) end
                
            else
                print("Index " .. target_index .. " not found in data.")
            end
        end
    end)
end
