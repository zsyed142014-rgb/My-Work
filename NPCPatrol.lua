local Players = game:GetService("Players")

local npc = script.Parent
local humanoid = npc:WaitForChild("Humanoid")
local root = npc:WaitForChild("HumanoidRootPart")
local patrolPoints = {}
local currentIndex = 1
local chaseTarget = nil

for _, child in ipairs(npc:GetChildren()) do
	if child:IsA("Part") and child.Name:match("Patrol") then
		table.insert(patrolPoints, child.Position)
	end
end

if #patrolPoints == 0 then
	table.insert(patrolPoints, root.Position)
end

local function getNearestPlayer(range)
	local nearestCharacter = nil
	local nearestDistance = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			local distance = (character.HumanoidRootPart.Position - root.Position).Magnitude
			if distance < range and distance < nearestDistance then
				nearestCharacter = character
				nearestDistance = distance
			end
		end
	end

	return nearestCharacter
end

local function moveTo(position)
	humanoid:MoveTo(position)
	local started = tick()

	while tick() - started < 2 do
		if (root.Position - position).Magnitude < 2 then
			return true
		end
		task.wait(0.05)
	end

	return false
end

local function patrol()
	humanoid.WalkSpeed = 12

	while humanoid.Health > 0 do
		local target = getNearestPlayer(30)
		if target then
			chaseTarget = target
			return
		end

		if moveTo(patrolPoints[currentIndex]) then
			currentIndex += 1
			if currentIndex > #patrolPoints then
				currentIndex = 1
			end
		end

		task.wait(0.2)
	end
end

local function chase()
	if not chaseTarget or not chaseTarget:FindFirstChild("HumanoidRootPart") then
		chaseTarget = nil
		return
	end

	humanoid.WalkSpeed = 18
	local targetRoot = chaseTarget.HumanoidRootPart

	while humanoid.Health > 0 and chaseTarget and chaseTarget.Parent do
		local target = getNearestPlayer(35)
		if target then
			chaseTarget = target
			targetRoot = chaseTarget.HumanoidRootPart
		end

		if chaseTarget and targetRoot then
			humanoid:MoveTo(targetRoot.Position)
		end

		if (root.Position - targetRoot.Position).Magnitude > 40 then
			chaseTarget = nil
			return
		end

		task.wait(0.1)
	end
end

while humanoid.Health > 0 do
	if chaseTarget then
		chase()
	else
		patrol()
	end
	task.wait(0.1)
end
