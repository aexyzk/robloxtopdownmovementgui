local RunService = game:GetService("RunService")

local playerPosition = UDim2.new(0, 0, 0, 0)

local HorizontalAxis = 0
local VerticalAxis = 0

local Left = false
local Right = false
local Up = false
local Down = false

local MovementSpeed = 1

local CancelDiagMov = 1

local PlayerSprite = script.Parent

function bool_to_number(value)
	if value then
		return 1
	else
		return 0
	end
end

local function getInput(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.A then
			Left = input.UserInputState == Enum.UserInputState.Begin
		end
		if input.KeyCode == Enum.KeyCode.D then
			Right = input.UserInputState == Enum.UserInputState.Begin
		end
		if input.KeyCode == Enum.KeyCode.W then
			Up = input.UserInputState == Enum.UserInputState.Begin
		end
		if input.KeyCode == Enum.KeyCode.S then
			Down = input.UserInputState == Enum.UserInputState.Begin
		end
	end
end

local TextureSize = Vector2.new(32, 64) -- Size of your full texture
local CellSize = Vector2.new(16, 16) -- Size of each cell in the grid

local LastDirection = Vector2.new(0, 0)

local function UpdateTexture()
	local rowIndex = 0
	local colIndex = 0
	
	if HorizontalAxis ~= 0 or VerticalAxis ~= 0 then
		colIndex = math.floor(os.clock() * 5) % 2
	else
		continue = 0
	end
	
	if LastDirection.X > 0 then
		rowIndex = 1
	elseif LastDirection.X < 0 then
		rowIndex = 2
	end

	if LastDirection.X == 0 then
		if LastDirection.Y > 0 then
			rowIndex = 3
		elseif LastDirection.Y < 0 then
			rowIndex = 0
		end
	end

	local offset = Vector2.new(colIndex * CellSize.X, rowIndex * CellSize.Y)
	PlayerSprite.ImageRectOffset = offset
	PlayerSprite.ImageRectSize = CellSize
end

game:GetService("UserInputService").InputBegan:Connect(getInput)
game:GetService("UserInputService").InputEnded:Connect(getInput)
	
RunService.RenderStepped:Connect(function(deltaTime)
	HorizontalAxis = (bool_to_number(Right) - bool_to_number(Left));
	VerticalAxis = (bool_to_number(Down) - bool_to_number(Up));
	
	if HorizontalAxis ~= 0 or VerticalAxis ~= 0 then
		LastDirection = Vector2.new(HorizontalAxis, VerticalAxis)
	end

	if HorizontalAxis ~= 0 and VerticalAxis ~= 0 then
		CancelDiagMov = 1.141
	else
		CancelDiagMov = 1
	end
	
	playerPosition = UDim2.new(
		playerPosition.X.Scale + HorizontalAxis * (MovementSpeed / CancelDiagMov) * deltaTime,
		playerPosition.X.Offset,
		playerPosition.Y.Scale + VerticalAxis * (MovementSpeed / CancelDiagMov) * deltaTime,
		playerPosition.Y.Offset
	)
	PlayerSprite.Position = playerPosition;
	UpdateTexture()
end)