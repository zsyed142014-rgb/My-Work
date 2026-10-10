local Players = game:GetService("Players")

local function createDamageEffect(target, amount)
	local hitbox = Instance.new("Part")
	hitbox.Name = "DamageEffect"
	hitbox.Size = Vector3.new(1, 1, 1)
	hitbox.Transparency = 1
	hitbox.CanCollide = false
	hitbox.Anchored = true
	hitbox.Position = target.Position
	hitbox.Parent = workspace
	
task.delay(0.15, function()
		hitbox:Destroy()
	end)
	
	if target:FindFirstChild("Humanoid") then
		target.Humanoid:TakeDamage(amount)
	end
end

local function getNearestPlayer(position, range)
	local nearestTarget = nil
	local nearestDistance = math.huge
	
	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			local distance = (character.HumanoidRootPart.Position - position).Magnitude
			if distance < range and distance < nearestDistance then
				nearestTarget = character
				nearestDistance = distance
			end
		end
	end
	
	return nearestTarget
end

local tool = script.Parent
local handle = tool:WaitForChild("Handle")
local cooldown = 0.5
local lastSwing = 0

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
		createDamageEffect(target, 20)
	end
end)
