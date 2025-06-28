local RunService = game:GetService("RunService")

local RenderDistance = script:WaitForChild("RenderDistance")
local Plr = game.Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera
local Part = Instance.new("Part")

local function CreatePart()
	Part.Size = Vector3.new(20.6, 12.7, 2)
	Part.Anchored = true
	Part.CanCollide = false
	Part.Parent = game.Workspace
	Part.Name = Plr.Name .. "_Viewport"
	script.Parent.Parent.Adornee = Part
end
CreatePart()

Camera.FieldOfView = 90

local function ClonePartsWithinObject(object)
	for _, v in ipairs(object:GetDescendants()) do
		if v:IsA("BasePart") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
			if (v.Position - Plr.Character.PrimaryPart.Position).Magnitude <= RenderDistance.Value then
				v.Archivable = true
				v:Clone().Parent = script.Parent
			end
		end
	end
end
RunService.RenderStepped:Connect(function()
	if Plr.Character then
		Part.CFrame = Camera.CFrame * CFrame.new(0, 0, -5)
		script.Parent.CurrentCamera = Camera
		for _, v in ipairs(script.Parent:GetChildren()) do
			if not v:IsA("Script") then
				v:Destroy()
			end
		end
		for _, obj in ipairs(workspace:GetChildren()) do
			if obj ~= Part and obj ~= Plr.Character and not obj:IsA("Terrain") then
				if obj:IsA("Model") or obj:IsA("Folder") then
					ClonePartsWithinObject(obj)
				elseif obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
					if (obj.Position - Plr.Character.PrimaryPart.Position).Magnitude <= RenderDistance.Value then
						obj.Archivable = true
						obj:Clone().Parent = script.Parent
					end
				end
			end
		end
	end
end)