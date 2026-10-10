local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local inventory = {}
local maxSlots = 20

for i = 1, maxSlots do
	inventory[i] = {Name = nil, Amount = 0}
end

local function addItem(itemName, amount)
	amount = amount or 1

	for i = 1, maxSlots do
		if inventory[i].Name == itemName then
			inventory[i].Amount += amount
			return true
		end
	end

	for i = 1, maxSlots do
		if inventory[i].Name == nil then
			inventory[i] = {Name = itemName, Amount = amount}
			return true
		end
	end

	return false
end

local function removeItem(itemName, amount)
	amount = amount or 1

	for i = 1, maxSlots do
		if inventory[i].Name == itemName then
			inventory[i].Amount -= amount
			if inventory[i].Amount <= 0 then
				inventory[i] = {Name = nil, Amount = 0}
			end
			return true
		end
	end

	return false
end

local function getItemAmount(itemName)
	for i = 1, maxSlots do
		if inventory[i].Name == itemName then
			return inventory[i].Amount
		end
	end

	return 0
end

local function useItem(itemName)
	if getItemAmount(itemName) > 0 then
		removeItem(itemName, 1)
		return true
	end

	return false
end

UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if input.KeyCode == Enum.KeyCode.I then
		print("Inventory open")
	end
end)

_G.Inventory = {
	Add = addItem,
	Remove = removeItem,
	GetAmount = getItemAmount,
	Use = useItem,
	Slots = maxSlots,
	Data = inventory,
}

return _G.Inventory
