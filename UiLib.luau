-- Vexium UI Library
-- Client-side UI module. Require this from a LocalScript.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local library = {}

local COLORS = {
	Panel = Color3.fromRGB(43, 43, 43),
	PanelDark = Color3.fromRGB(26, 26, 26),
	Row = Color3.fromRGB(33, 33, 33),
	RowHover = Color3.fromRGB(43, 43, 43),
	Text = Color3.fromRGB(225, 225, 225),
	MutedText = Color3.fromRGB(150, 150, 150),
	Stroke = Color3.fromRGB(59, 59, 59),
	Accent = Color3.fromRGB(39, 46, 89),
	AccentBright = Color3.fromRGB(73, 105, 190),
	SwitchOff = Color3.fromRGB(66, 66, 66),
	Danger = Color3.fromRGB(151, 57, 67),
}

local function make(className, parent, properties)
	local instance = Instance.new(className)
	for property, value in pairs(properties or {}) do
		instance[property] = value
	end
	instance.Parent = parent
	return instance
end

local function round(instance, pixels)
	return make("UICorner", instance, {
		CornerRadius = UDim.new(0, pixels or 6),
	})
end

local function outline(instance, color, transparency)
	return make("UIStroke", instance, {
		Color = color or COLORS.Stroke,
		Transparency = transparency or 0,
		Thickness = 1,
	})
end

local function animate(instance, duration, properties, style, direction)
	if not instance or not instance.Parent then
		return nil
	end

	local tween = TweenService:Create(
		instance,
		TweenInfo.new(duration, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out),
		properties
	)
	tween:Play()
	return tween
end

local function newConnectionBag(window)
	local bag = {
		_connections = {},
	}

	function bag:Connect(signal, callback)
		local connection = signal:Connect(callback)
		table.insert(self._connections, connection)
		return connection
	end

	function bag:DisconnectAll()
		for _, connection in ipairs(self._connections) do
			if connection.Connected then
				connection:Disconnect()
			end
		end
		table.clear(self._connections)
	end

	table.insert(window._bags, bag)
	return bag
end

local function invoke(window, callback, ...)
	if type(callback) ~= "function" then
		return
	end

	local arguments = table.pack(...)
	task.spawn(function()
		local ok, err = xpcall(function()
			callback(table.unpack(arguments, 1, arguments.n))
		end, debug.traceback)
		if not ok then
			warn("[Vexium UI] Callback error:\n" .. tostring(err))
		end
	end)
end

local function normalizeKeyCode(value)
	if typeof(value) == "EnumItem" and value.EnumType == Enum.KeyCode then
		return value
	end
	if type(value) == "string" then
		local keyName = string.gsub(value, "%s+", "")
		local ok, keyCode = pcall(function()
			return Enum.KeyCode[keyName]
		end)
		if ok and keyCode then
			return keyCode
		end
	end
	return nil
end

local function formatNumber(value)
	if math.abs(value - math.round(value)) < 0.000001 then
		return tostring(math.round(value))
	end
	return string.format("%.2f", value)
end

local function addRowListLayout(parent, padding)
	make("UIListLayout", parent, {
		Padding = UDim.new(0, padding or 7),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
	make("UIPadding", parent, {
		PaddingTop = UDim.new(0, 6),
		PaddingBottom = UDim.new(0, 8),
		PaddingLeft = UDim.new(0, 6),
		PaddingRight = UDim.new(0, 6),
	})
end

local function createWidgetFrame(parent, height)
	local frame = make("Frame", parent, {
		BackgroundColor3 = COLORS.Row,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, height),
	})
	round(frame, 6)
	return frame
end

local function createTextLabel(parent, text, properties)
	local defaults = {
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		Text = text or "",
		TextColor3 = COLORS.Text,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
	}
	for property, value in pairs(properties or {}) do
		defaults[property] = value
	end
	return make("TextLabel", parent, defaults)
end

local function createTextButton(parent, text, properties)
	local defaults = {
		AutoButtonColor = false,
		BackgroundColor3 = COLORS.Row,
		BorderSizePixel = 0,
		Font = Enum.Font.Gotham,
		Text = text or "",
		TextColor3 = COLORS.Text,
		TextSize = 13,
	}
	for property, value in pairs(properties or {}) do
		defaults[property] = value
	end
	return make("TextButton", parent, defaults)
end

local function addMethod(owner, implementation)
	return function(first, second, third, fourth, fifth, sixth)
		if first == owner then
			return implementation(second, third, fourth, fifth, sixth)
		end
		return implementation(first, second, third, fourth, fifth, sixth)
	end
end

local function attachHandleMethods(control, setter, getter)
	if setter then
		control.set = addMethod(control, setter)
		control.Set = control.set
	end
	if getter then
		control.get = addMethod(control, getter)
		control.Get = control.get
	end
	return control
end

local function makeWindow(title, topBarColor, toggleKey)
	local player = Players.LocalPlayer
	assert(player, "Vexium UI must be created from a client LocalScript.")

	local playerGui = player:WaitForChild("PlayerGui")
	local screenGui = make("ScreenGui", playerGui, {
		Name = "VexiumUI",
		DisplayOrder = 20,
		IgnoreGuiInset = false,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	})

	local window = {
		_gui = screenGui,
		_bags = {},
		_keybinds = {},
		_destroyed = false,
		_minimized = false,
		_visible = true,
		_activeKeybind = nil,
		_notificationOrder = 0,
		_toastOrder = 0,
	}

	local main = make("Frame", screenGui, {
		Name = "Window",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = COLORS.Panel,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(440, 330),
		ZIndex = 1,
	})
	window._main = main
	round(main, 9)
	outline(main, COLORS.Stroke, 0.1)

	local header = make("Frame", main, {
		Name = "TopBar",
		BackgroundColor3 = typeof(topBarColor) == "Color3" and topBarColor or COLORS.Accent,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 36),
		ZIndex = 2,
	})
	round(header, 9)
	make("Frame", header, {
		Name = "BottomSquare",
		BackgroundColor3 = typeof(topBarColor) == "Color3" and topBarColor or COLORS.Accent,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, -8),
		Size = UDim2.new(1, 0, 0, 8),
		ZIndex = 2,
	})

	local dragHandle = createTextButton(header, "", {
		Name = "DragHandle",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, -116, 1, 0),
		Text = "",
		ZIndex = 3,
	})
	dragHandle.Active = true

	local titleLabel = createTextLabel(dragHandle, tostring(title or "Vexium"), {
		Name = "Title",
		Position = UDim2.new(0, 12, 0, 0),
		Size = UDim2.new(1, -18, 1, 0),
		TextColor3 = Color3.fromRGB(245, 245, 245),
		TextSize = 15,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 4,
	})
	titleLabel.Active = false

	local function makeHeaderButton(name, text, xOffset, backgroundColor)
		local button = createTextButton(header, text, {
			Name = name,
			BackgroundColor3 = backgroundColor or Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0.83,
			Position = UDim2.new(1, xOffset, 0, 5),
			Size = UDim2.fromOffset(27, 26),
			TextColor3 = Color3.fromRGB(250, 250, 250),
			TextSize = 16,
			ZIndex = 5,
		})
		round(button, 5)
		return button
	end

	local minimizeButton = makeHeaderButton("Minimize", "-", -94)
	local maximizeButton = makeHeaderButton("Maximize", "+", -94)
	local unloadButton = makeHeaderButton("Unload", "X", -34, COLORS.Danger)
	maximizeButton.Visible = false

	local nav = make("ScrollingFrame", main, {
		Name = "TabButtonContainer",
		Active = true,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = COLORS.PanelDark,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarImageColor3 = COLORS.AccentBright,
		ScrollBarThickness = 3,
		Position = UDim2.new(0, 10, 0, 45),
		Size = UDim2.new(0, 112, 1, -55),
		ZIndex = 2,
	})
	round(nav, 6)
	outline(nav, COLORS.Stroke, 0.3)
	addRowListLayout(nav, 4)

	local pageHolder = make("Frame", main, {
		Name = "TabHolder",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 132, 0, 45),
		Size = UDim2.new(1, -142, 1, -55),
		ZIndex = 2,
	})

	local notificationHolder = make("Frame", screenGui, {
		Name = "Notifications",
		AnchorPoint = Vector2.new(1, 1),
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		Position = UDim2.new(1, -14, 1, -14),
		Size = UDim2.new(0, 300, 0, 320),
		ZIndex = 30,
	})
	make("UIListLayout", notificationHolder, {
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
	})

	local toastHolder = make("Frame", screenGui, {
		Name = "Toasts",
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		Position = UDim2.new(0.5, 0, 0, 14),
		Size = UDim2.new(0, 340, 0, 200),
		ZIndex = 35,
	})
	make("UIListLayout", toastHolder, {
		Padding = UDim.new(0, 7),
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
	})

	local keyToggle = normalizeKeyCode(toggleKey) or Enum.KeyCode.RightShift
	window.toggleKey = keyToggle

	local currentSizeTween
	local currentDragTween
	local function resizeForViewport()
		local camera = Workspace.CurrentCamera
		local viewport = camera and camera.ViewportSize or Vector2.new(800, 600)
		local viewportWidth = math.max(200, viewport.X)
		local viewportHeight = math.max(180, viewport.Y)
		local width = math.floor(math.min(560, viewportWidth - 24, viewportWidth * 0.88))
		local height = math.floor(math.min(420, viewportHeight - 40, viewportHeight * 0.76))
		width = math.max(190, width)
		height = math.max(160, height)
		if currentSizeTween then
			currentSizeTween:Cancel()
			currentSizeTween = nil
		end

		window._fullSize = UDim2.fromOffset(width, height)
		if window._minimized then
			main.Size = UDim2.fromOffset(width, 36)
		else
			main.Size = window._fullSize
		end

		local sidebarWidth = math.clamp(math.floor(width * 0.29), 78, 132)
		nav.Size = UDim2.new(0, sidebarWidth, 1, -55)
		pageHolder.Position = UDim2.new(0, sidebarWidth + 20, 0, 45)
		pageHolder.Size = UDim2.new(1, -sidebarWidth - 30, 1, -55)
		notificationHolder.Size = UDim2.new(0, math.min(300, math.max(190, viewportWidth - 28)), 0, math.min(320, math.max(150, viewportHeight * 0.5)))
		toastHolder.Size = UDim2.new(0, math.min(340, math.max(190, viewportWidth - 28)), 0, math.min(200, math.max(100, viewportHeight * 0.3)))

		local maxOffsetX = math.max(0, viewportWidth / 2 - width / 2 - 12)
		local maxOffsetY = math.max(0, viewportHeight / 2 - height / 2 - 12)
		main.Position = UDim2.new(
			0.5,
			math.clamp(main.Position.X.Offset, -maxOffsetX, maxOffsetX),
			0.5,
			math.clamp(main.Position.Y.Offset, -maxOffsetY, maxOffsetY)
		)
	end

	local windowBag = newConnectionBag(window)
	local cameraViewportConnection
	local function bindCamera()
		if cameraViewportConnection and cameraViewportConnection.Connected then
			cameraViewportConnection:Disconnect()
		end
		local camera = Workspace.CurrentCamera
		if camera then
			cameraViewportConnection = windowBag:Connect(camera:GetPropertyChangedSignal("ViewportSize"), resizeForViewport)
		end
		resizeForViewport()
	end
	windowBag:Connect(Workspace:GetPropertyChangedSignal("CurrentCamera"), bindCamera)
	bindCamera()

	local function setMinimized(minimized)
		if window._destroyed or window._minimized == minimized then
			return
		end

		window._minimized = minimized
		minimizeButton.Visible = not minimized
		maximizeButton.Visible = minimized
		if not minimized then
			nav.Visible = true
			pageHolder.Visible = true
		end

		if currentSizeTween then
			currentSizeTween:Cancel()
		end
		local target = minimized and UDim2.fromOffset(window._fullSize.X.Offset, 36) or window._fullSize
		currentSizeTween = TweenService:Create(
			main,
			TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
			{ Size = target }
		)
		currentSizeTween:Play()

		if minimized then
			task.delay(0.22, function()
				if window._minimized and not window._destroyed then
					nav.Visible = false
					pageHolder.Visible = false
				end
			end)
		end
	end

	window.minimize = function()
		setMinimized(true)
	end
	window.maximize = function()
		setMinimized(false)
	end
	window.toggle = function()
		if not window._destroyed then
			window._visible = not window._visible
			main.Visible = window._visible
		end
	end
	window.setVisible = function(visible)
		window._visible = not not visible
		main.Visible = window._visible
	end

	local dragging = false
	local activeDragInput
	local dragStart
	local startPosition
	local dragBag = newConnectionBag(window)
	dragBag:Connect(dragHandle.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			activeDragInput = input
			dragStart = input.Position
			startPosition = main.Position
		end
	end)
	dragBag:Connect(dragHandle.InputChanged, function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if activeDragInput then
				activeDragInput = input
			end
		end
	end)
	dragBag:Connect(UserInputService.InputChanged, function(input)
		if not dragging or not dragStart or not startPosition then
			return
		end
		local isMouseDrag = activeDragInput and activeDragInput.UserInputType == Enum.UserInputType.MouseMovement and input.UserInputType == Enum.UserInputType.MouseMovement
		local isTouchDrag = activeDragInput and activeDragInput.UserInputType == Enum.UserInputType.Touch and input == activeDragInput
		if not isMouseDrag and not isTouchDrag then
			return
		end

		local delta = input.Position - dragStart
		local camera = Workspace.CurrentCamera
		local viewport = camera and camera.ViewportSize or Vector2.new(800, 600)
		local absoluteSize = main.AbsoluteSize
		local maxOffsetX = math.max(0, viewport.X / 2 - absoluteSize.X / 2 - 12)
		local maxOffsetY = math.max(0, viewport.Y / 2 - absoluteSize.Y / 2 - 12)
		local targetPosition = UDim2.new(
			startPosition.X.Scale,
			math.clamp(startPosition.X.Offset + delta.X, -maxOffsetX, maxOffsetX),
			startPosition.Y.Scale,
			math.clamp(startPosition.Y.Offset + delta.Y, -maxOffsetY, maxOffsetY)
		)
		if currentDragTween then
			currentDragTween:Cancel()
		end
		currentDragTween = TweenService:Create(main, TweenInfo.new(0.06, Enum.EasingStyle.Linear), { Position = targetPosition })
		currentDragTween:Play()
	end)
	dragBag:Connect(UserInputService.InputEnded, function(input)
		if activeDragInput and (input == activeDragInput or input.UserInputType == Enum.UserInputType.MouseButton1) then
			dragging = false
			activeDragInput = nil
		end
	end)

	local function setKeybindListening(control, isListening)
		if isListening then
			if window._activeKeybind and window._activeKeybind ~= control then
				window._activeKeybind._setListening(false)
			end
			window._activeKeybind = control
			control._setListening(true)
		elseif window._activeKeybind == control then
			window._activeKeybind = nil
			control._setListening(false)
		end
	end

	windowBag:Connect(UserInputService.InputBegan, function(input, gameProcessed)
		if input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		local keyCode = input.KeyCode
		if window._activeKeybind then
			local listeningControl = window._activeKeybind
			if keyCode == Enum.KeyCode.Escape then
				setKeybindListening(listeningControl, false)
			else
				listeningControl.set(keyCode)
				setKeybindListening(listeningControl, false)
			end
			return
		end

		if gameProcessed or UserInputService:GetFocusedTextBox() then
			return
		end
		if keyCode == window.toggleKey then
			window.toggle()
			return
		end
		for _, keybind in ipairs(window._keybinds) do
			if keybind.keyCode == keyCode then
				invoke(window, keybind.callback, keyCode)
			end
		end
	end)

	local function makeNotification(titleText, messageText, duration, isToast)
		if window._destroyed then
			return nil
		end

		local holder = isToast and toastHolder or notificationHolder
		local card = make("Frame", holder, {
			BackgroundColor3 = COLORS.PanelDark,
			BorderSizePixel = 0,
			LayoutOrder = isToast and window._toastOrder or window._notificationOrder,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			ZIndex = isToast and 36 or 31,
		})
		round(card, 8)
		outline(card, COLORS.Stroke, 0.12)
		make("UIPadding", card, {
			PaddingTop = UDim.new(0, isToast and 7 or 9),
			PaddingBottom = UDim.new(0, isToast and 7 or 9),
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
		})
		make("UIListLayout", card, {
			Padding = UDim.new(0, 2),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		if isToast then
			local toastLabel = createTextLabel(card, tostring(messageText or ""), {
				Name = "Message",
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0),
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextSize = 14,
				ZIndex = 37,
			})
			toastLabel.Active = false
		else
			local notificationTitle = createTextLabel(card, tostring(titleText or "Notification"), {
				Name = "Title",
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 20),
				TextSize = 13,
				Font = Enum.Font.GothamSemibold,
				ZIndex = 32,
			})
			notificationTitle.Active = false
			local messageLabel = createTextLabel(card, tostring(messageText or ""), {
				Name = "Message",
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 0),
				TextColor3 = COLORS.MutedText,
				TextSize = 12,
				TextWrapped = true,
				ZIndex = 32,
			})
			messageLabel.Active = false
		end

		local bar = make("Frame", card, {
			BackgroundColor3 = COLORS.AccentBright,
			BorderSizePixel = 0,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, 3),
			ZIndex = isToast and 37 or 32,
		})
		round(bar, 2)
		local lifetime = math.max(0, tonumber(duration) or 3)
		animate(bar, math.max(0.05, lifetime), { Size = UDim2.new(0, 0, 0, 3) }, Enum.EasingStyle.Linear)
		animate(card, 0.18, { BackgroundTransparency = 0 }, Enum.EasingStyle.Quad)

		if isToast then
			window._toastOrder += 1
		else
			window._notificationOrder += 1
		end

		task.delay(lifetime, function()
			if not card.Parent then
				return
			end
			for _, descendant in ipairs(card:GetDescendants()) do
				if descendant:IsA("TextLabel") then
					animate(descendant, 0.16, { TextTransparency = 1 })
				elseif descendant:IsA("Frame") then
					animate(descendant, 0.16, { BackgroundTransparency = 1 })
				end
			end
			animate(card, 0.16, { BackgroundTransparency = 1 })
			task.delay(0.18, function()
				if card.Parent then
					card:Destroy()
				end
			end)
		end)

		return card
	end

	window.sendNotification = addMethod(window, function(notificationTitle, message, duration)
		return makeNotification(notificationTitle, message, duration, false)
	end)
	window.sendToast = addMethod(window, function(message, duration)
		return makeNotification(nil, message, duration, true)
	end)

	local tabs = {}
	local activeTab
	window.createTab = addMethod(window, function(tabName)
		local name = tostring(tabName or ("Tab " .. tostring(#tabs + 1)))
		local tab = {
			name = name,
			_controls = {},
		}
		local navButton = createTextButton(nav, name, {
			Name = "TabButton",
			BackgroundColor3 = COLORS.PanelDark,
			LayoutOrder = #tabs + 1,
			Size = UDim2.new(1, 0, 0, 29),
			TextColor3 = COLORS.MutedText,
			TextSize = 12,
			TextTruncate = Enum.TextTruncate.AtEnd,
			ZIndex = 3,
		})
		round(navButton, 5)
		local indicator = make("Frame", navButton, {
			BackgroundColor3 = COLORS.AccentBright,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 0.2, 0),
			Size = UDim2.new(0, 3, 0.6, 0),
			Visible = false,
			ZIndex = 4,
		})
		round(indicator, 2)

		local page = make("ScrollingFrame", pageHolder, {
			Name = "Tab_" .. tostring(#tabs + 1),
			Active = true,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			ScrollBarImageColor3 = COLORS.AccentBright,
			ScrollBarThickness = 3,
			Size = UDim2.fromScale(1, 1),
			Visible = false,
			ZIndex = 2,
		})
		addRowListLayout(page, 7)
		tab._page = page
		tab._button = navButton
		tab._indicator = indicator

		local function selectTab()
			if activeTab then
				activeTab._page.Visible = false
				activeTab._indicator.Visible = false
				activeTab._button.TextColor3 = COLORS.MutedText
				activeTab._button.BackgroundColor3 = COLORS.PanelDark
			end
			activeTab = tab
			page.Visible = true
			indicator.Visible = true
			navButton.TextColor3 = COLORS.Text
			navButton.BackgroundColor3 = COLORS.Row
			window._activeTab = tab
		end

		local tabBag = newConnectionBag(window)
		tabBag:Connect(navButton.Activated, selectTab)
		if not activeTab then
			selectTab()
		end
		table.insert(tabs, tab)

		local function register(control)
			table.insert(tab._controls, control)
			return control
		end

		tab.createButton = addMethod(tab, function(controlName, callback)
			local button = createTextButton(page, tostring(controlName or "Button"), {
				Name = "Button",
				BackgroundColor3 = COLORS.Row,
				LayoutOrder = #tab._controls + 1,
				Size = UDim2.new(1, 0, 0, 34),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextSize = 13,
				ZIndex = 3,
			})
			round(button, 6)
			outline(button, COLORS.Stroke, 0.55)
			make("UIPadding", button, { PaddingLeft = UDim.new(0, 11), PaddingRight = UDim.new(0, 10) })
			local bag = newConnectionBag(window)
			bag:Connect(button.MouseEnter, function()
				animate(button, 0.12, { BackgroundColor3 = COLORS.RowHover })
			end)
			bag:Connect(button.MouseLeave, function()
				animate(button, 0.12, { BackgroundColor3 = COLORS.Row })
			end)
			bag:Connect(button.Activated, function()
				invoke(window, callback)
			end)
			return register({ instance = button })
		end)

		tab.createToggle = addMethod(tab, function(controlName, callback, initialValue)
			local row = createWidgetFrame(page, 34)
			row.Name = "Toggle"
			row.LayoutOrder = #tab._controls + 1
			local label = createTextLabel(row, tostring(controlName or "Toggle"), {
				Name = "Name",
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.new(1, -64, 1, 0),
				TextTruncate = Enum.TextTruncate.AtEnd,
				ZIndex = 4,
			})
			label.Active = false
			local switch = createTextButton(row, "", {
				Name = "ToggleButton",
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundColor3 = COLORS.SwitchOff,
				Position = UDim2.new(1, -9, 0.5, 0),
				Size = UDim2.fromOffset(36, 20),
				Text = "",
				ZIndex = 4,
			})
			round(switch, 10)
			local knob = make("Frame", switch, {
				Name = "Knob",
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = Color3.fromRGB(230, 230, 230),
				BorderSizePixel = 0,
				Position = UDim2.new(0, 3, 0.5, 0),
				Size = UDim2.fromOffset(14, 14),
				ZIndex = 5,
			})
			round(knob, 8)

			local value = not not initialValue
			local function set(nextValue, notify)
				value = not not nextValue
				animate(switch, 0.14, { BackgroundColor3 = value and COLORS.AccentBright or COLORS.SwitchOff })
				animate(knob, 0.14, { Position = value and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) })
				if notify then
					invoke(window, callback, value)
				end
			end
			set(value, false)
			local bag = newConnectionBag(window)
			bag:Connect(switch.Activated, function()
				set(not value, true)
			end)
			return attachHandleMethods(register({ instance = row }), set, function()
				return value
			end)
		end)

		tab.createDropdown = addMethod(tab, function(controlName, options, callback, initialValue)
			local row = make("Frame", page, {
				Name = "Dropdown",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = false,
				LayoutOrder = #tab._controls + 1,
				Size = UDim2.new(1, 0, 0, 34),
			})
			local headerButton = createTextButton(row, "", {
				Name = "Header",
				BackgroundColor3 = COLORS.Row,
				Size = UDim2.new(1, 0, 0, 34),
				Text = "",
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 3,
			})
			round(headerButton, 6)
			outline(headerButton, COLORS.Stroke, 0.55)
			local optionList = type(options) == "table" and options or {}
			local selected = initialValue
			if selected == nil then
				selected = "Select an option"
			end
			local nameLabel = createTextLabel(headerButton, tostring(controlName or "Dropdown"), {
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.new(0.5, -10, 1, 0),
				TextTruncate = Enum.TextTruncate.AtEnd,
				ZIndex = 4,
			})
			nameLabel.Active = false
			local selectedLabel = createTextLabel(headerButton, tostring(selected), {
				Name = "SelectedOption",
				Position = UDim2.new(0.5, 0, 0, 0),
				Size = UDim2.new(0.5, -31, 1, 0),
				TextColor3 = COLORS.MutedText,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Right,
				ZIndex = 4,
			})
			selectedLabel.Active = false
			local arrow = createTextLabel(headerButton, "v", {
				Position = UDim2.new(1, -26, 0, 0),
				Size = UDim2.fromOffset(20, 34),
				TextColor3 = COLORS.MutedText,
				TextXAlignment = Enum.TextXAlignment.Center,
				ZIndex = 4,
			})
			arrow.Active = false

			local optionScroll = make("ScrollingFrame", row, {
				Name = "Options",
				Active = true,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = COLORS.PanelDark,
				BorderSizePixel = 0,
				CanvasSize = UDim2.new(0, 0, 0, 0),
				Position = UDim2.new(0, 0, 0, 38),
				ScrollBarImageColor3 = COLORS.AccentBright,
				ScrollBarThickness = 3,
				Size = UDim2.new(1, 0, 0, 0),
				Visible = false,
				ZIndex = 7,
			})
			round(optionScroll, 6)
			outline(optionScroll, COLORS.Stroke, 0.2)
			make("UIListLayout", optionScroll, {
				Padding = UDim.new(0, 2),
				SortOrder = Enum.SortOrder.LayoutOrder,
			})
			make("UIPadding", optionScroll, {
				PaddingTop = UDim.new(0, 4),
				PaddingBottom = UDim.new(0, 4),
				PaddingLeft = UDim.new(0, 4),
				PaddingRight = UDim.new(0, 4),
			})

			local isOpen = false
			local function setOpen(open)
				isOpen = not not open
				optionScroll.Visible = isOpen
				arrow.Text = isOpen and "^" or "v"
				local count = math.max(1, math.min(#optionList, 5))
				local height = isOpen and (count * 27 + 8) or 34
				row.Size = UDim2.new(1, 0, 0, height + (isOpen and 4 or 0))
				optionScroll.Size = UDim2.new(1, 0, 0, isOpen and (count * 27 + 8) or 0)
			end
			local function set(value, notify)
				selected = value
				selectedLabel.Text = tostring(value)
				setOpen(false)
				if notify then
					invoke(window, callback, value)
				end
			end

			for index, option in ipairs(optionList) do
				local optionValue = option
				local optionButton = createTextButton(optionScroll, tostring(optionValue), {
					Name = "Option",
					BackgroundColor3 = COLORS.PanelDark,
					LayoutOrder = index,
					Size = UDim2.new(1, 0, 0, 25),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextSize = 12,
					ZIndex = 8,
				})
				make("UIPadding", optionButton, { PaddingLeft = UDim.new(0, 7), PaddingRight = UDim.new(0, 6) })
				round(optionButton, 4)
				local optionBag = newConnectionBag(window)
				optionBag:Connect(optionButton.Activated, function()
					set(optionValue, true)
				end)
			end

			local bag = newConnectionBag(window)
			bag:Connect(headerButton.Activated, function()
				setOpen(not isOpen)
			end)
			local control = register({
				instance = row,
				open = function() setOpen(true) end,
				close = function() setOpen(false) end,
			})
			return attachHandleMethods(control, set, function()
				return selected
			end)
		end)

		local function createSlider(controlName, minimum, maximum, callback, step)
			local minValue = tonumber(minimum) or 0
			local maxValue = tonumber(maximum) or 100
			assert(maxValue >= minValue, "Slider maximum must be greater than or equal to its minimum.")
			local increment = tonumber(step) or 1
			if increment <= 0 then
				increment = 1
			end
			local row = createWidgetFrame(page, 45)
			row.Name = "Slider"
			row.LayoutOrder = #tab._controls + 1
			local label = createTextLabel(row, tostring(controlName or "Slider"), {
				Position = UDim2.new(0, 10, 0, 1),
				Size = UDim2.new(0.72, 0, 0, 18),
				TextSize = 12,
				ZIndex = 4,
			})
			label.Active = false
			local valueLabel = createTextLabel(row, "", {
				Name = "Value",
				Position = UDim2.new(1, -54, 0, 1),
				Size = UDim2.new(0, 44, 0, 18),
				TextColor3 = COLORS.MutedText,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Right,
				ZIndex = 4,
			})
			valueLabel.Active = false
			local track = make("Frame", row, {
				Name = "Track",
				Active = true,
				BackgroundColor3 = Color3.fromRGB(57, 57, 57),
				BorderSizePixel = 0,
				Position = UDim2.new(0, 10, 0, 27),
				Size = UDim2.new(1, -20, 0, 5),
				ZIndex = 4,
			})
			round(track, 4)
			local fill = make("Frame", track, {
				Name = "Fill",
				BackgroundColor3 = COLORS.AccentBright,
				BorderSizePixel = 0,
				Size = UDim2.new(0, 0, 1, 0),
				ZIndex = 5,
			})
			round(fill, 4)
			local knob = make("Frame", track, {
				Name = "Knob",
				Active = true,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(235, 235, 235),
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.fromOffset(13, 13),
				ZIndex = 6,
			})
			round(knob, 8)

			local value = minValue
			local function updateVisuals()
				local alpha = maxValue == minValue and 0 or (value - minValue) / (maxValue - minValue)
				fill.Size = UDim2.new(alpha, 0, 1, 0)
				knob.Position = UDim2.new(alpha, 0, 0.5, 0)
				valueLabel.Text = formatNumber(value)
			end
			local function set(nextValue, notify)
				local number = math.clamp(tonumber(nextValue) or minValue, minValue, maxValue)
				if maxValue > minValue then
					if number > minValue and number < maxValue then
						number = minValue + math.round((number - minValue) / increment) * increment
						number = math.clamp(number, minValue, maxValue)
					end
				end
				local changed = number ~= value
				value = number
				updateVisuals()
				if notify and changed then
					invoke(window, callback, value)
				end
			end
			local function updateFromInput(input)
				local trackWidth = track.AbsoluteSize.X
				if trackWidth <= 0 then
					return
				end
				local alpha = math.clamp((input.Position.X - track.AbsolutePosition.X) / trackWidth, 0, 1)
				set(minValue + (maxValue - minValue) * alpha, true)
			end
			updateVisuals()

			local activeInput
			local sliderBag = newConnectionBag(window)
			local function beginDrag(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					activeInput = input
					updateFromInput(input)
				end
			end
			sliderBag:Connect(track.InputBegan, beginDrag)
			sliderBag:Connect(knob.InputBegan, beginDrag)
			sliderBag:Connect(UserInputService.InputChanged, function(input)
				local mouseDrag = activeInput and activeInput.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseMovement
				local touchDrag = activeInput and activeInput.UserInputType == Enum.UserInputType.Touch and activeInput == input
				if mouseDrag or touchDrag then
					updateFromInput(input)
				end
			end)
			sliderBag:Connect(UserInputService.InputEnded, function(input)
				if activeInput and (input == activeInput or input.UserInputType == Enum.UserInputType.MouseButton1) then
					activeInput = nil
				end
			end)
			return attachHandleMethods(register({ instance = row }), set, function()
				return value
			end)
		end

		tab.createSlider = addMethod(tab, createSlider)
		tab.CreateSlider = tab.createSlider

		tab.createLabel = addMethod(tab, function(text)
			local row = make("Frame", page, {
				Name = "Label",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = #tab._controls + 1,
				Size = UDim2.new(1, 0, 0, 25),
			})
			local label = createTextLabel(row, tostring(text or ""), {
				Name = "Text",
				Position = UDim2.new(0, 4, 0, 0),
				Size = UDim2.new(1, -8, 1, 0),
				TextColor3 = COLORS.MutedText,
				TextSize = 12,
				ZIndex = 3,
			})
			label.Active = false
			local function set(value)
				label.Text = tostring(value or "")
			end
			return attachHandleMethods(register({ instance = row, label = label }), set)
		end)

		tab.createInput = addMethod(tab, function(controlName, callback, placeholder)
			local row = createWidgetFrame(page, 36)
			row.Name = "Input"
			row.LayoutOrder = #tab._controls + 1
			local label = createTextLabel(row, tostring(controlName or "Input"), {
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.new(0.47, -10, 1, 0),
				TextTruncate = Enum.TextTruncate.AtEnd,
				ZIndex = 4,
			})
			label.Active = false
			local textBox = make("TextBox", row, {
				Name = "InputBox",
				BackgroundColor3 = Color3.fromRGB(55, 55, 55),
				BorderSizePixel = 0,
				ClearTextOnFocus = false,
				Font = Enum.Font.Gotham,
				PlaceholderColor3 = COLORS.MutedText,
				PlaceholderText = tostring(placeholder or "Enter text"),
				Position = UDim2.new(0.47, 0, 0.18, 0),
				Size = UDim2.new(0.53, -9, 0.64, 0),
				Text = "",
				TextColor3 = COLORS.Text,
				TextSize = 12,
				ZIndex = 4,
			})
			round(textBox, 12)
			make("UIPadding", textBox, { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })
			local bag = newConnectionBag(window)
			bag:Connect(textBox.FocusLost, function()
				invoke(window, callback, textBox.Text)
			end)
			local function set(value)
				textBox.Text = tostring(value or "")
			end
			local control = register({
				instance = row,
				textBox = textBox,
			})
			return attachHandleMethods(control, set, function()
				return textBox.Text
			end)
		end)

		tab.createKeybind = addMethod(tab, function(controlName, callback, initialKey)
			local row = createWidgetFrame(page, 34)
			row.Name = "Keybind"
			row.LayoutOrder = #tab._controls + 1
			local label = createTextLabel(row, tostring(controlName or "Keybind"), {
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.new(1, -105, 1, 0),
				TextTruncate = Enum.TextTruncate.AtEnd,
				ZIndex = 4,
			})
			label.Active = false
			local keyButton = createTextButton(row, "", {
				Name = "InputBox",
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundColor3 = Color3.fromRGB(54, 54, 54),
				Position = UDim2.new(1, -8, 0.5, 0),
				Size = UDim2.fromOffset(76, 24),
				TextSize = 11,
				ZIndex = 4,
			})
			round(keyButton, 12)
			local keyCode = normalizeKeyCode(initialKey)
			local listening = false
			local function refresh()
				keyButton.Text = listening and "Press key..." or (keyCode and keyCode.Name or "Unbound")
				keyButton.BackgroundColor3 = listening and COLORS.AccentBright or Color3.fromRGB(54, 54, 54)
			end
			local control = {
				instance = row,
				keyCode = keyCode,
				callback = callback,
			}
			function control._setListening(value)
				listening = not not value
				refresh()
			end
			local function set(value)
				keyCode = normalizeKeyCode(value)
				control.keyCode = keyCode
				refresh()
			end
			refresh()
			local bag = newConnectionBag(window)
			bag:Connect(keyButton.Activated, function()
				setKeybindListening(control, true)
			end)
			table.insert(window._keybinds, control)
			attachHandleMethods(control, set, function()
				return keyCode
			end)
			return register(control)
		end)

		-- Return both dot-call and colon-call friendly methods.
		return tab
	end)

	window.destroy = function()
		if window._destroyed then
			return
		end
		window._destroyed = true
		for _, bag in ipairs(window._bags) do
			bag:DisconnectAll()
		end
		if screenGui.Parent then
			screenGui:Destroy()
		end
	end
	window.unload = window.destroy
	window.Destroy = window.destroy
	window.Unload = window.destroy

	local buttonBag = newConnectionBag(window)
	buttonBag:Connect(minimizeButton.Activated, function()
		setMinimized(true)
	end)
	buttonBag:Connect(maximizeButton.Activated, function()
		setMinimized(false)
	end)
	buttonBag:Connect(unloadButton.Activated, function()
		window.destroy()
	end)

	return window
end

library.window = addMethod(library, makeWindow)
library.Window = library.window

return library
