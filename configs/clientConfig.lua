Hotel = {}
HotelFnc = {} 
TriggerServerEvent("plouffe_hotel:sendConfig")

RegisterNetEvent("plouffe_hotel:getConfig",function(list)
	if list == nil then
		CreateThread(function()
			while true do
				Wait(0)
				Hotel = nil
				HotelFnc = nil
			end
		end)
	else
		Hotel = list
		HotelFnc:Start()
	end
end)