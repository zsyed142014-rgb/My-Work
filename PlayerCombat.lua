local Players = game:GetService("Players")

local tool = script.Parent
local handle = tool:WaitForChild("Handle")
local cooldown = 0.5
local lastSwing = 0

local function getNearestPlayer(position, range)
	local nearestCharacter = nil
	local nearestDistance = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			local distance = (character.HumanoidRootPart.Position - position).Magnitude
			if distance < range and distance < nearestDistance then
				nearestCharacter = character
				nearestDistance = distance
			end
		end
	end

	return nearestCharacter
end

local function damageTarget(target, amount)
	if target and target:FindFirstChild("Humanoid") then
		target.Humanoid:TakeDamage(amount)
	end
end

tool.Activated:Connect(function()
	local now = tick()
	if now - lastSwing < cooldown then
		return
	end

	lastSwing = now

	local character = tool.Parent
	if not character or not character:FindFirstChild("HumanoidRootPart") then
		return
	end

	local root = character.HumanoidRootPart
	local target = getNearestPlayer(root.Position, 14)

	if target then
		damageTarget(target, 20)
	end
end)
