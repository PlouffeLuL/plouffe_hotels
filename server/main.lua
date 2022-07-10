RegisterNetEvent("plouffe_hotel:sendConfig",function()
    local playerId = source
    local registred, key = Auth:Register(playerId)

    if registred then
        local cbArray = Hotel
        cbArray.Utils.MyAuthKey = key

        TriggerClientEvent("plouffe_hotel:getConfig",playerId,cbArray)
    else
        TriggerClientEvent("plouffe_hotel:getConfig",playerId,nil)
    end
end)

RegisterNetEvent("plouffe_hotel:inhotel",function(data,authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_hotel:inhotel") then
            HotelFnc:RegisterInventory(playerId)
            Server.CurrentInventoryCoords[playerId] = data.inventoryCoords
            Server.CurrentRoomId[playerId] = data.id
            Server.CurrentHotelRooms[data.id].amount = Server.CurrentHotelRooms[data.id].amount + 1
        end
    end
end)

RegisterNetEvent("plouffe_hotel:outofhotel",function(authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_hotel:outofhotel") then
            Server.CurrentInventoryCoords[playerId] = nil
            Server.CurrentHotelRooms[Server.CurrentRoomId[playerId]].amount = Server.CurrentHotelRooms[Server.CurrentRoomId[playerId]].amount - 1
        end
    end
end)

RegisterNetEvent("plouffe_hotel:register_raid",function(state_id,authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_hotel:register_raid") then
            local stash_name = ("hotel_%s"):format(state_id)
            local label = ("Appartement %s"):format(state_id)
            exports.ox_inventory:RegisterStash(stash_name, label, 100, 100000)
        end
    end
end)

RegisterNetEvent("plouffe_hotel:openinventory",function(authkey)
    local playerId = source  
    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_hotel:inhotel") then
            TriggerEvent("hsn-inventory:openmyhotelinventory", playerId)
        end
    end
end)

Callback:RegisterServerCallback("plouffe_hotel:GetCurrenRoomCount", function(source,cb,authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_hotel:GetCurrenRoomCount") then
            if exports.plouffe_society:IsPlayerDisabled(playerId) then
                cb(false,false,false)
            else
                local id = HotelFnc:GetLowerRoomId()
                cb(Server.CurrentHotelRooms[id].amount, id, true)
            end
        end
    end
end)

function HotelFnc:GetLowerRoomId()
    local lowest = Server.CurrentHotelRooms[1].amount
    local cbId = 1
    for k,v in pairs(Server.CurrentHotelRooms) do
        if v.amount < lowest then
            cbId = k
        end
    end

    return cbId
end

function HotelFnc:RegisterInventory(playerId)
    local player = exports.ooc_core:getPlayerFromId(playerId)
    local stash_name = ("hotel_%s"):format(player.state_id)
    local label = ("Appartement %s"):format(player.state_id)
    
    exports.ox_inventory:RegisterStash(stash_name, label, 100, 100000)
end