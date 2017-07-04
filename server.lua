--[[
##################
#    Oskarr      #
#    MysticRP    #
#   server.lua   #
#      2017      #
##################
--]]


RegisterServerEvent("location:cautionOn")
AddEventHandler("location:cautionOn", function(cautionprice)
	TriggerEvent('es:getPlayerFromId', source, function(user)
	user:removeMoney(cautionprice)
	end)	
	end)
	
	RegisterServerEvent("location:cautionOff")
AddEventHandler("location:cautionOff", function(cautionprice)
	TriggerEvent('es:getPlayerFromId', source, function(user)
	user:addMoney(cautionprice)
	end)	
	end)