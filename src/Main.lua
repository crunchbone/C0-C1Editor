local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")
local UIS = game:GetService("UserInputService")
local active = false
local rotate = false
local ToolBar = plugin:CreateToolbar("Welder by crunchbone")

local button = ToolBar:CreateButton('C0/C1 editor', 'edit weld c0 and c1', '')

local Handle = Instance.new("Handles")
Handle.Style = Enum.HandlesStyle.Movement
local CurrentWeld = Instance
local CurrentHandle = Instance

local function ToggleC()
	--(active)
	if active then
		if CurrentHandle.Adornee == CurrentWeld.Part0 then
			CurrentHandle.Adornee = CurrentWeld.Part1
		elseif CurrentHandle.Adornee == CurrentWeld.Part1 then
			CurrentHandle.Adornee = CurrentWeld.Part0
		else
			CurrentHandle.Adornee = CurrentWeld.Part0
		end	
	end
end

local function ToggleRot()
	rotate = not rotate
	if rotate then
		CurrentHandle.Color3 = Color3.fromRGB(255, 200, 0)
	else
		CurrentHandle.Color3 = Color3.fromRGB(0, 170, 255)
	end
end

local function Handler(k)
	local vegtor
	--("handler")
	if k.KeyCode == Enum.KeyCode.H or k.KeyCode == Enum.KeyCode.K then --X
		if k.KeyCode == Enum.KeyCode.H then
			vegtor = Vector3.FromNormalId(Enum.NormalId.Left)
		else
			vegtor = Vector3.FromNormalId(Enum.NormalId.Right)
		end
	elseif k.KeyCode == Enum.KeyCode.LeftBracket or k.KeyCode == Enum.KeyCode.RightBracket then --Y
		if k.KeyCode == Enum.KeyCode.LeftBracket then
			vegtor = Vector3.FromNormalId(Enum.NormalId.Top)
		else
			vegtor = Vector3.FromNormalId(Enum.NormalId.Bottom)
		end
	elseif k.KeyCode == Enum.KeyCode.U or k.KeyCode == Enum.KeyCode.J then --Z
		if k.KeyCode == Enum.KeyCode.U then
			vegtor = Vector3.FromNormalId(Enum.NormalId.Front)
		else
			vegtor = Vector3.FromNormalId(Enum.NormalId.Back)
		end
	end
	if active then
		--("g")
		if not rotate then
			if CurrentHandle.Adornee == CurrentWeld.Part0 then
				ChangeHistoryService:SetWaypoint('nil')
				CurrentWeld.C0 = CurrentWeld.C0*CFrame.new(vegtor/10)
				--("C)")
				--(vegtor)
				--(CurrentWeld.C0)
			else
				--("C1")
				--(vegtor)
				ChangeHistoryService:SetWaypoint('nil')
				CurrentWeld.C1 = CurrentWeld.C1*CFrame.new(vegtor/10)
				--(CurrentWeld.C1)
			end
		elseif rotate then
			if CurrentHandle.Adornee == CurrentWeld.Part0 then
				ChangeHistoryService:SetWaypoint('nil')
				CurrentWeld.C0 = CurrentWeld.C0*CFrame.fromAxisAngle(vegtor,1)
				--("C)")
				--(vegtor)
				--(CurrentWeld.C0)
			else
				--("C1")
				--(vegtor)
				ChangeHistoryService:SetWaypoint('nil')
				CurrentWeld.C1 = CurrentWeld.C1*CFrame.fromAxisAngle(vegtor,1)
				--(CurrentWeld.C1)
			end
		end
	end
end

local function ButtonHandler(k, r)
	--("hand")
	if k.KeyCode == Enum.KeyCode.Equals then
		ToggleRot()
	end
	if k.KeyCode == Enum.KeyCode.F then
		ToggleC()
	end
	if k.KeyCode == Enum.KeyCode.U or k.KeyCode == Enum.KeyCode.J or k.KeyCode == Enum.KeyCode.H or k.KeyCode == Enum.KeyCode.K or k.KeyCode == Enum.KeyCode.LeftBracket or k.KeyCode == Enum.KeyCode.RightBracket then	
		Handler(k)
	end
end

local function ButtonEvent()
	if not active then
		ChangeHistoryService:SetWaypoint('nil')
		active = not active
		local Handles = Handle:Clone()
		Handles.Parent = workspace.CurrentCamera
		CurrentHandle = Handles
		CurrentWeld = Selection:Get()[1]
		Handles.Adornee = CurrentWeld.Part0
		CurrentHandle.Color3 = Color3.fromRGB(0, 170, 255)
		if rotate then rotate = not rotate end
	else
		ChangeHistoryService:SetWaypoint('nil')
		active = not active
		CurrentHandle = nil
		workspace.CurrentCamera.Handles:Destroy()
	end
end

UIS.InputBegan:Connect(ButtonHandler)
button.Click:Connect(ButtonEvent)
