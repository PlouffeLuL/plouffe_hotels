local Callback = exports.plouffe_lib:Get("Callback")
local Utils = exports.plouffe_lib:Get("Utils")
local Core = nil

function HotelFnc:Start()
    while not Core do
        TriggerEvent('ooc_core:getCore', function(core) Core = core end)
    end

    while not Core.Player:IsPlayerLoaded() do
        Wait(500)
    end

    Hotel.Player = Core.Player:GetPlayerData()

    self:RegisterAllEvents()
    self:ExportsAllZones()
end

function HotelFnc:ExportsAllZones()
    for k,v in pairs(Hotel.Coords) do
        local data = v
        data.aditionalParams = {zone = k}
        exports.plouffe_lib:ValidateZoneData(data)
    end
end

function HotelFnc:RegisterAllEvents()
    RegisterNetEvent("plouffe_hotels:enterroom", function()
        self:Enter()
    end)

    RegisterNetEvent("plouffe_hotels:enterroom_raid", function()
        exports.ooc_dialog:Open({
            rows = {
                {
                    id = 0, 
                    txt = "State id"
                }
            }
        }, function(inputs)
            if not inputs then
                return 
            end
    
            Hotel.Utils.raid_id = tostring(inputs[1].input)
    
            if Hotel.Utils.raid_id and tonumber(Hotel.Utils.raid_id) then
                TriggerServerEvent("plouffe_hotel:register_raid", Hotel.Utils.raid_id, Hotel.Utils.MyAuthKey)
                self:Enter()
            else
                Hotel.Utils.raid_id = nil
            end
        end)
    end)
    
    RegisterNetEvent("plouffe_hotels:hotelaction", function(p)
        if Hotel.Utils.isInHotel then
            self:Action(p.action)
        end
    end)
end

function HotelFnc:ExportInterior()
    for k,v in pairs(Hotel.Room.zone) do
        v.coords = GetOffsetFromEntityInWorldCoords(Hotel.Props[1],Hotel.Room.offSets[k].x,Hotel.Room.offSets[k].y,Hotel.Room.offSets[k].z)
        exports.plouffe_lib:ValidateZoneData(v)
    end
end

function HotelFnc:Enter()
    Callback:Await("plouffe_hotel:GetCurrenRoomCount", function(multi, id, allowed)
        if allowed then
            local isCreated = HotelFnc:CreateModel(id,15 * multi)
            
            if isCreated then
                Hotel.Utils.ped = PlayerPedId()
                Utils:PlayAnim(1000, "anim@mp_player_intmenu@key_fob@","fob_click",48,2.0, 2.0, 500)

                self:ExportInterior()

                Utils:FadeOut(1000,true)
                
                exports.plouffe_lib:ChangeWeatherSync(false)
                exports.plouffe_lib:ChangeTimeSync(false)

                ClearOverrideWeather()
                ClearWeatherTypePersist()
                SetWeatherTypePersist("EXTRASUNNY")
                SetWeatherTypeNow("EXTRASUNNY")
                SetWeatherTypeNowPersist("EXTRASUNNY")

                NetworkOverrideClockTime(22, 22, 0)

                TriggerServerEvent("plouffe_hotel:inhotel", {inventoryCoords = Hotel.Room.zone["inventory"].coords, id = id}, Hotel.Utils.MyAuthKey)
                Wait(100)
                local offset = GetOffsetFromEntityInWorldCoords(Hotel.Props[1],Hotel.Room.offSets["exit"].x,Hotel.Room.offSets["exit"].y,Hotel.Room.offSets["exit"].z)
                SetEntityCoords(Hotel.Utils.ped,offset.x,offset.y,offset.z)
                Wait(100)

                Utils:FadeIn(1000,true)
                Hotel.Utils.isInHotel = true
            end
        else
            Utils:Notify("error","Votre dernier paiment banquaire a été refuser par la banque vous ne pouvez pas accèder a votre chambre", 10000)
        end
    end, Hotel.Utils.MyAuthKey)
end

function HotelFnc:CreateModel(id,multi)
    local obj = Utils:CreateProp(Hotel.Room.model,vector3(Hotel.Room.coords[id].coords.x, Hotel.Room.coords[id].coords.y, Hotel.Room.coords[id].coords.z - multi))
    FreezeEntityPosition(obj,true)  
    table.insert(Hotel.Props, obj)
    return true
end

function HotelFnc:Action(action)
    if action == "exit" then
        self:Exit()
    elseif action == "wardrobe" then
        Core.Skin:OpenWardrobe()
    elseif action == "inventory" then
        local stash_name = ("hotel_%s"):format(Hotel.Utils.raid_id or Hotel.Player.state_id)
        exports.ox_inventory:openInventory("stash", {id=stash_name, type="stash"})
    end
end

function HotelFnc:Exit()
    Hotel.Utils.ped = PlayerPedId()
    Hotel.Utils.raid_id = nil

    Utils:PlayAnim(1000, "anim@mp_player_intmenu@key_fob@","fob_click",48,2.0, 2.0, 500)

    Utils:FadeOut(1000,true)

    exports.plouffe_lib:ChangeWeatherSync(true)
    exports.plouffe_lib:ChangeTimeSync(true)
    exports.plouffe_lib:Refresh(true, true)
    
    TriggerServerEvent("plouffe_hotel:outofhotel", Hotel.Utils.MyAuthKey)
    SetEntityCoords(Hotel.Utils.ped, Hotel.Room.entry.x,Hotel.Room.entry.y,Hotel.Room.entry.z)
    Wait(200)

    Utils:FadeIn(1000,true)

    self:RemoveInterior()
    
    Hotel.Utils.isInHotel = false
end

function HotelFnc:RemoveInterior()
    for k,v in pairs(Hotel.Props) do
        DeleteEntity(v)
    end

    for k,v in pairs(Hotel.Room.zone) do
        exports.plouffe_lib:DestroyZone(v.name)
    end

    Hotel.Props = {}
end