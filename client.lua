--[[
##################
#    Oskarr      #
#    MysticRP    #
#   client.lua   #
#      2017      #
##################
--]]


local options = {
    x = 0.1,
    y = 0.2,
    width = 0.2,
    height = 0.04,
    scale = 0.4,
    font = 0,
    menu_title = "Location", -- title menu // titre menu
    menu_subtitle = "Menu", -- subtitle menu // sous titre menu
    color_r = 255, -- R
    color_g = 10, -- G
    color_b = 20,  -- B
}

local caution = false -- don't edit // ne pas toucher

local cautionprice = 20000 -- change by your price // changez par votre prix
local locaPlate = "LOCATION" -- vehicle plate // plaque du vehicule


--- Location
Citizen.CreateThread(
	function()
	--X, Y, Z coords 
		local x = 1142.0096435547 
		local y = -3277.4702148438
		local z = 5.900691986084
		while true do
			Citizen.Wait(0)
			local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
			if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 100.0) then
				DrawMarker(1, x, y, z - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 10, 10,165, 0, 0, 0,0)
				if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 4.0) then
					local ply = GetPlayerPed(-1)
				if IsPedInAnyVehicle(ply, true) then
				    DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ~r~ranger~s~ votre ~b~camion')
					if (IsControlJustReleased(1, 51)) then -- Press E // Appuyez sur E
						local vehicle = GetVehiclePedIsIn(ply, true)
	                    local mulemodel = GetHashKey('mule3')
						local benmodel = GetHashKey('benson')
	                    local isVehicleLocationM = IsVehicleModel(vehicle, mulemodel)
						local isVehicleLocationB = IsVehicleModel(vehicle, benmodel)
						local isLocaPlate = GetVehicleNumberPlateText(vehicle)
                     if isVehicleLocationM or isVehicleLocationB then
					 if isLocaPlate == locaPlate then
						TriggerServerEvent("location:cautionOff", cautionprice)
						Notify("Vous avez récupérer vos ~g~"..cautionprice.."$~s~ de caution pour le ~b~camion")
						caution = false
						DeleteLoca()
					 else
					 Notify("~r~Ce n'est pas un camion de location !")
					 end
					 else
					 Notify("~r~Ce n'est pas un camion !")
					 end
					end
				else						
					DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ~g~louer~s~ un ~b~camion')
					if (IsControlJustReleased(1, 51)) then -- Press E // Appuyez sur E
						LocationMenu()
						Menu.hidden = not Menu.hidden
					end
					Menu.renderGUI(options) 
				end
				end
			end
		end
end)



---- FONCTIONS ----

function Notify(text)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

---------------------
---- Menu

function LocationMenu()
   options.menu_subtitle = "LOCATION"
    ClearMenu()
	Menu.addButton("Louer une Mule", "Mule", nil)
	Menu.addButton("Louer un Benson", "Benson", nil)
end

--------------------------------------------
-- Spawn/Despawn

function Mule()
	Citizen.Wait(0)
	caution = true
	TriggerServerEvent("location:cautionOn", cautionprice)
    Notify("Vous avez laisser ~g~"..cautionprice.."$~s~ de caution pour le ~b~camion")
	local ped = GetPlayerPed(-1)
	local player = PlayerId()
	local vehicle = GetHashKey('mule3')

	RequestModel(vehicle)

	while not HasModelLoaded(vehicle) do
		Wait(1)
	end

	--local plate = math.random(300, 900)
	local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 5.0, 0)
	local spawned_car = CreateVehicle(vehicle, coords, 913.99212646484, -167.31979370117, 74.33235168457, true, false)
	SetVehicleOnGroundProperly(spawned_car)
	SetVehicleNumberPlateText(spawned_car, locaPlate)
	SetVehicleColours(spawned_car, 12, 131)
	SetVehicleExtraColours(spawned_car, 12, 12)
	SetPedIntoVehicle(ped, spawned_car, - 1)
	SetModelAsNoLongerNeeded(vehicle)
	Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(spawned_car))
end

function Benson()
	Citizen.Wait(0)
	caution = true
	TriggerServerEvent("location:cautionOn", cautionprice)
    Notify("Vous avez laisser ~g~"..cautionprice.."$~s~ de caution pour le ~b~camion")
	local ped = GetPlayerPed(-1)
	local player = PlayerId()
	local vehicle = GetHashKey('benson')

	RequestModel(vehicle)

	while not HasModelLoaded(vehicle) do
		Wait(1)
	end

	--local plate = math.random(300, 900)
	local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 5.0, 0)
	local spawned_car = CreateVehicle(vehicle, coords, 913.99212646484, -167.31979370117, 74.33235168457, true, false)
	SetVehicleOnGroundProperly(spawned_car)
	SetVehicleNumberPlateText(spawned_car, locaPlate)
	SetVehicleColours(spawned_car, 12, 131)
	SetVehicleExtraColours(spawned_car, 12, 12)
	SetPedIntoVehicle(ped, spawned_car, - 1)
	SetModelAsNoLongerNeeded(vehicle)
	Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(spawned_car))
end


function DeleteLoca()
   local ply = GetPlayerPed(-1)
   local playerVeh = GetVehiclePedIsIn(ply, false)
   Citizen.Wait(1)
   ClearPedTasksImmediately(ply)
   SetEntityVisible(playerVeh, false, 0)
   SetEntityCoords(playerVeh, 999999.0, 999999.0, 999999.0, false, false, false, true)
   FreezeEntityPosition(playerVeh, true)
   SetEntityAsMissionEntity(playerVeh, 1, 1)
   DeleteVehicle(playerVeh)
end

-----------------
