local VERSION = '0.9.1'
local LASTUPDATE = 'Mon Mar  1 15:43:48 2021 UTC'
--os.date("!%c")  UTC time string
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")
local UIS = game:GetService("UserInputService")
local active = false
local rotate = false
local ToolBar = plugin:CreateToolbar("Joint manipulator")
local button = ToolBar:CreateButton('C0/C1 editor', 'edit JointInstance c0 and c1', '') or ToolBar:CreateButton('C0/C1 editor '..VERSION, 'edit JointInstance c0 and c1\nlast update: '..LASTUPDATE, '')

local Handle = Instance.new("SelectionBox")
Handle.LineThickness = 0.09

local CurrentWeld = Instance
local CurrentHandle = Instance

local function ToggleC()
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
		if not rotate then
			if CurrentHandle.Adornee == CurrentWeld.Part0 then
				CurrentWeld.C0*=CFrame.new(vegtor/10)
				ChangeHistoryService:SetWaypoint('Move C0')
			else
				CurrentWeld.C1*=CFrame.new(vegtor/10)
				ChangeHistoryService:SetWaypoint('Move C1')
			end
		elseif rotate then
			if CurrentHandle.Adornee == CurrentWeld.Part0 then
				CurrentWeld.C0*=CFrame.fromAxisAngle(vegtor,0.1)
				ChangeHistoryService:SetWaypoint('Rotate C0')
			else
				CurrentWeld.C1*=CFrame.fromAxisAngle(vegtor,0.1)
				ChangeHistoryService:SetWaypoint('Rotate C1')
			end
		end
	end
end

local function ButtonHandler(k, r)
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
		active = not active
		local Handles = Handle:Clone()
		Handles.Parent = workspace.CurrentCamera
		CurrentHandle = Handles
		CurrentWeld = Selection:Get()[1]
		Handles.Adornee = CurrentWeld.Part0
		CurrentHandle.Color3 = Color3.fromRGB(0, 170, 255)
		if rotate then rotate = not rotate end
		ChangeHistoryService:SetWaypoint('Toggle plugin')
	else
		active = not active
		CurrentHandle = nil
		workspace.CurrentCamera.SelectionBox:Destroy()
		ChangeHistoryService:SetWaypoint('Toggle plugin')
	end
end

UIS.InputBegan:Connect(ButtonHandler)
button.Click:Connect(ButtonEvent)
