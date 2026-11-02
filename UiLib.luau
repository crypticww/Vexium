-- Vexium UI Library
-- Uses StarterGui.cryptic as its visual source so runtime controls keep the
-- exact properties, images, fonts, and layout from the project mockup.

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local library = {}
local DEFAULT_TOP_BAR_COLOR = Color3.fromRGB(39, 46, 89)

local function make(className, parent, properties)
	local instance = Instance.new(className)
	for property, value in pairs(properties or {}) do
		instance[property] = value
	end
	instance.Parent = parent
	return instance
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
	local bag = { connections = {} }

	function bag:Connect(signal, callback)
		local connection = signal:Connect(callback)
		table.insert(self.connections, connection)
		return connection
	end

	function bag:DisconnectAll()
		for _, connection in ipairs(self.connections) do
			if connection.Connected then
				connection:Disconnect()
			end
		end
		table.clear(self.connections)
	end

	table.insert(window._bags, bag)
	return bag
end

local function invoke(callback, ...)
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

local function addMethod(owner, implementation)
	return function(first, second, third, fourth, fifth)
		if first == owner then
			return implementation(second, third, fourth, fifth)
		end
		return implementation(first, second, third, fourth, fifth)
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

local function findTemplateGui(playerGui)
	local screenGui = playerGui:FindFirstChild("cryptic")
	if screenGui and screenGui:GetAttribute("VexiumLibraryWindow") then
		screenGui = nil
	end

	if not screenGui then
		local template = StarterGui:FindFirstChild("cryptic")
		assert(template and template:IsA("ScreenGui"), "Vexium UI requires StarterGui.cryptic as its visual template.")
		screenGui = template:Clone()
		screenGui.Name = "VexiumUI"
		screenGui.Parent = playerGui
	end

	assert(screenGui:IsA("ScreenGui"), "StarterGui.cryptic must be a ScreenGui.")
	screenGui:SetAttribute("VexiumLibraryWindow", true)
	screenGui.ResetOnSpawn = false
	screenGui.Enabled = true
	return screenGui
end

local function createActivationButton(parent, name, position, size, anchorPoint, zIndex)
	return make("TextButton", parent, {
		Name = name,
		Active = true,
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = position,
		AnchorPoint = anchorPoint or Vector2.zero,
		Selectable = true,
		Size = size,
		Text = "",
		TextTransparency = 1,
		ZIndex = zIndex or 10,
	})
end

local function makeWindow(title, topBarColor, toggleKey)
	local player = Players.LocalPlayer
	assert(player, "Vexium UI must be created from a client LocalScript.")

	local playerGui = player:WaitForChild("PlayerGui")
	local screenGui = findTemplateGui(playerGui)
	local main = screenGui:FindFirstChild("main")
	assert(main and main:IsA("Frame"), "StarterGui.cryptic.main is missing or is not a Frame.")

	local topBar = main:FindFirstChild("TopBar")
	local tabButtonContainer = main:FindFirstChild("TabButtonContainer")
	local tabHolder = main:FindFirstChild("TabHolder")
	assert(topBar and tabButtonContainer and tabHolder, "The cryptic template must contain TopBar, TabButtonContainer, and TabHolder.")

	local tabButtons = tabButtonContainer:FindFirstChild("Holder")
	local firstPage = tabHolder:FindFirstChild("Home")
	assert(tabButtons and firstPage, "The cryptic template must contain TabButtonContainer.Holder and TabHolder.Home.")

	local templateNames = {
		"Button",
		"Toggle",
		"Label",
		"Divider",
		"Input",
		"Slider",
		"Dropdown_Closed",
		"Dropdown_Opened",
		"Keybind",
	}
	local templates = {}
	for _, templateName in ipairs(templateNames) do
		local template = firstPage:FindFirstChild(templateName)
		assert(template, "StarterGui.cryptic.main.TabHolder.Home." .. templateName .. " is missing.")
		templates[templateName] = template:Clone()
	end

	local navButtonTemplate = tabButtons:FindFirstChildWhichIsA("TextButton")
	assert(navButtonTemplate, "StarterGui.cryptic.main.TabButtonContainer.Holder needs a TextButton template.")
	navButtonTemplate = navButtonTemplate:Clone()

	local openedDropdownOptions = templates.Dropdown_Opened:FindFirstChild("Options")
	local optionTemplate
	if openedDropdownOptions then
		for _, child in ipairs(openedDropdownOptions:GetChildren()) do
			if child:IsA("Frame") then
				optionTemplate = child:Clone()
				break
			end
		end
	end
	assert(optionTemplate, "StarterGui.cryptic Dropdown_Opened.Options needs an option Frame template.")

	local notificationSource = screenGui:FindFirstChild("notification")
	local toastSource = screenGui:FindFirstChild("toast")
	assert(notificationSource and toastSource, "StarterGui.cryptic must include notification and toast templates.")
	local notificationTemplate = notificationSource:Clone()
	local toastTemplate = toastSource:Clone()
	notificationSource.Visible = false
	toastSource.Visible = false

	local function clearPageSamples(page)
		local keep = {
			UIListLayout = true,
			UIPadding = true,
			_Title = true,
			_Border = true,
			_Space = true,
		}
		for _, child in ipairs(page:GetChildren()) do
			if not keep[child.Name] then
				child:Destroy()
			end
		end
		page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		page.CanvasSize = UDim2.new(0, 0, 0, 0)
		page.ScrollingDirection = Enum.ScrollingDirection.Y
		page.CanvasPosition = Vector2.zero
	end

	clearPageSamples(firstPage)
	local pageTemplate = firstPage:Clone()
	pageTemplate.Name = "PageTemplate"
	pageTemplate.Visible = false
	pageTemplate.Parent = nil

	for _, child in ipairs(tabButtons:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
	tabButtons.AutomaticCanvasSize = Enum.AutomaticSize.Y
	tabButtons.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabButtons.ScrollingDirection = Enum.ScrollingDirection.Y

	local titleLabel = topBar:FindFirstChild("Title")
	if titleLabel and titleLabel:IsA("TextLabel") then
		titleLabel.Text = tostring(title or "Vexium")
	end
	local accent = typeof(topBarColor) == "Color3" and topBarColor or DEFAULT_TOP_BAR_COLOR
	topBar.BackgroundColor3 = accent
	local extension = topBar:FindFirstChild("TopBar_Extension")
	if extension and extension:IsA("GuiObject") then
		extension.BackgroundColor3 = accent
	end

	local originalMainSize = main.Size
	local originalClipsDescendants = main.ClipsDescendants
	local baseWidth = math.max(1, main.AbsoluteSize.X)
	local baseHeight = math.max(1, main.AbsoluteSize.Y)
	local uiScale = main:FindFirstChildOfClass("UIScale")
	if not uiScale then
		uiScale = make("UIScale", main, { Scale = 1 })
	end

	local window = {
		_gui = screenGui,
		_main = main,
		_bags = {},
		_keybinds = {},
		_destroyed = false,
		_minimized = false,
		_visible = true,
		_activeKeybind = nil,
	}

	local navOverlay = main:FindFirstChild("TabButtonContainer")
	local pagesOverlay = main:FindFirstChild("TabHolder")
	local minimizeIcon = topBar:FindFirstChild("Minimize")
	local maximizeIcon = topBar:FindFirstChild("Maximize")
	local unloadIcon = topBar:FindFirstChild("Exit_Unload")
	assert(minimizeIcon and maximizeIcon and unloadIcon, "The cryptic TopBar must have Minimize, Maximize, and Exit_Unload icons.")

	local minimizeButton = createActivationButton(topBar, "MinimizeAction", minimizeIcon.Position, minimizeIcon.Size, minimizeIcon.AnchorPoint, math.max(10, minimizeIcon.ZIndex + 5))
	local maximizeButton = createActivationButton(topBar, "MaximizeAction", maximizeIcon.Position, maximizeIcon.Size, maximizeIcon.AnchorPoint, math.max(10, maximizeIcon.ZIndex + 5))
	local unloadButton = createActivationButton(topBar, "UnloadAction", unloadIcon.Position, unloadIcon.Size, unloadIcon.AnchorPoint, math.max(10, unloadIcon.ZIndex + 5))
	maximizeButton.Visible = false

	local dragHandle = createActivationButton(
		topBar,
		"DragHandle",
		UDim2.new(0, 0, 0, 0),
		UDim2.new(0.82, 0, 1, 0),
		Vector2.zero,
		math.max(8, topBar.ZIndex + 5)
	)

	local windowBag = newConnectionBag(window)
	local currentCameraConnection
	local currentSizeTween
	local currentDragTween
	local function clampWindowPosition()
		local camera = Workspace.CurrentCamera
		local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
		local absSize = main.AbsoluteSize
		local currentPosition = main.AbsolutePosition
		local left = math.clamp(currentPosition.X, 8, math.max(8, viewport.X - absSize.X - 8))
		local top = math.clamp(currentPosition.Y, 8, math.max(8, viewport.Y - absSize.Y - 8))
		local xOffset = left - (main.Position.X.Scale * viewport.X - main.AnchorPoint.X * absSize.X)
		local yOffset = top - (main.Position.Y.Scale * viewport.Y - main.AnchorPoint.Y * absSize.Y)
		main.Position = UDim2.new(main.Position.X.Scale, xOffset, main.Position.Y.Scale, yOffset)
	end

	local function resizeForViewport()
		local camera = Workspace.CurrentCamera
		local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
		local widthScale = (viewport.X - 24) / baseWidth
		local heightScale = (viewport.Y - 48) / baseHeight
		uiScale.Scale = math.max(0.4, math.min(1, widthScale, heightScale))
		task.defer(clampWindowPosition)
	end

	local function bindCamera()
		if currentCameraConnection and currentCameraConnection.Connected then
			currentCameraConnection:Disconnect()
		end
		local camera = Workspace.CurrentCamera
		if camera then
			currentCameraConnection = windowBag:Connect(camera:GetPropertyChangedSignal("ViewportSize"), resizeForViewport)
		end
		resizeForViewport()
	end
	windowBag:Connect(Workspace:GetPropertyChangedSignal("CurrentCamera"), bindCamera)
	bindCamera()

	local dragging = false
	local dragInput
	local dragStart
	local dragStartPosition
	windowBag:Connect(dragHandle.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragInput = input
			dragStart = input.Position
			dragStartPosition = main.Position
		end
	end)
	windowBag:Connect(dragHandle.InputChanged, function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragInput then
				dragInput = input
			end
		end
	end)
	windowBag:Connect(UserInputService.InputChanged, function(input)
		if not dragging or not dragStart or not dragStartPosition then
			return
		end
		local mouseDrag = dragInput and dragInput.UserInputType == Enum.UserInputType.MouseMovement and input.UserInputType == Enum.UserInputType.MouseMovement
		local touchDrag = dragInput and dragInput.UserInputType == Enum.UserInputType.Touch and dragInput == input
		if not mouseDrag and not touchDrag then
			return
		end

		local camera = Workspace.CurrentCamera
		local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
		local delta = input.Position - dragStart
		local absSize = main.AbsoluteSize
		local startLeft = dragStartPosition.X.Scale * viewport.X + dragStartPosition.X.Offset - main.AnchorPoint.X * absSize.X
		local startTop = dragStartPosition.Y.Scale * viewport.Y + dragStartPosition.Y.Offset - main.AnchorPoint.Y * absSize.Y
		local targetLeft = math.clamp(startLeft + delta.X, 8, math.max(8, viewport.X - absSize.X - 8))
		local targetTop = math.clamp(startTop + delta.Y, 8, math.max(8, viewport.Y - absSize.Y - 8))
		local targetPosition = UDim2.new(
			dragStartPosition.X.Scale,
			targetLeft + main.AnchorPoint.X * absSize.X - dragStartPosition.X.Scale * viewport.X,
			dragStartPosition.Y.Scale,
			targetTop + main.AnchorPoint.Y * absSize.Y - dragStartPosition.Y.Scale * viewport.Y
		)
		if currentDragTween then
			currentDragTween:Cancel()
		end
		currentDragTween = TweenService:Create(main, TweenInfo.new(0.06, Enum.EasingStyle.Linear), { Position = targetPosition })
		currentDragTween:Play()
	end)
	windowBag:Connect(UserInputService.InputEnded, function(input)
		if dragInput and (input == dragInput or input.UserInputType == Enum.UserInputType.MouseButton1) then
			dragging = false
			dragInput = nil
		end
	end)

	local function setMinimized(minimized)
		if window._destroyed or window._minimized == minimized then
			return
		end
		window._minimized = minimized
		minimizeIcon.Visible = not minimized
		minimizeButton.Visible = not minimized
		maximizeIcon.Visible = minimized
		maximizeButton.Visible = minimized

		if currentSizeTween then
			currentSizeTween:Cancel()
		end
		local currentSize = main.Size
		local currentPosition = main.Position
		local targetSize
		if minimized then
			main.ClipsDescendants = true
			navOverlay.Visible = false
			pagesOverlay.Visible = false
			local topBarHeight = topBar.Size.Y.Offset
			targetSize = UDim2.new(originalMainSize.X.Scale, originalMainSize.X.Offset, originalMainSize.Y.Scale, topBarHeight)
		else
			navOverlay.Visible = true
			pagesOverlay.Visible = true
			targetSize = originalMainSize
		end
		local heightDelta = (targetSize.Y.Offset - currentSize.Y.Offset) * uiScale.Scale
		local targetPosition = UDim2.new(
			currentPosition.X.Scale,
			currentPosition.X.Offset,
			currentPosition.Y.Scale,
			currentPosition.Y.Offset + main.AnchorPoint.Y * heightDelta
		)

		currentSizeTween = TweenService:Create(main, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = targetPosition,
			Size = targetSize,
		})
		currentSizeTween:Play()
		if not minimized then
			task.delay(0.23, function()
				if not window._minimized and not window._destroyed then
					main.ClipsDescendants = originalClipsDescendants
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
			screenGui.Enabled = window._visible
		end
	end
	window.setVisible = function(visible)
		window._visible = not not visible
		screenGui.Enabled = window._visible
	end
	window.toggleKey = normalizeKeyCode(toggleKey) or Enum.KeyCode.RightShift
	window.setToggleKey = function(value)
		local keyCode = normalizeKeyCode(value)
		if keyCode then
			window.toggleKey = keyCode
		end
	end

	local tabs = {}
	local activeTab
	local activeNotifications = {}
	local activeToasts = {}

	local function renumberStack(items, template, isToast)
		local basePosition = template.Position
		local verticalSpacing = isToast and (template.Size.Y.Offset + 7) or (template.Size.Y.Offset + 8)
		for index, card in ipairs(items) do
			if card.Parent then
				card.Position = UDim2.new(basePosition.X.Scale, basePosition.X.Offset, basePosition.Y.Scale, basePosition.Y.Offset + (isToast and 1 or -1) * (index - 1) * verticalSpacing)
			end
		end
	end

	local function removeFromStack(items, card, template, isToast)
		for index, existing in ipairs(items) do
			if existing == card then
				table.remove(items, index)
				break
			end
		end
		renumberStack(items, template, isToast)
	end

	local function fadeAndDestroy(card, items, template, isToast)
		if not card.Parent then
			return
		end
		for _, descendant in ipairs(card:GetDescendants()) do
			if descendant:IsA("TextLabel") then
				animate(descendant, 0.16, { TextTransparency = 1 })
			elseif descendant:IsA("Frame") then
				animate(descendant, 0.16, { BackgroundTransparency = 1 })
			elseif descendant:IsA("UIStroke") then
				animate(descendant, 0.16, { Transparency = 1 })
			end
		end
		animate(card, 0.16, { BackgroundTransparency = 1 })
		task.delay(0.18, function()
			removeFromStack(items, card, template, isToast)
			if card.Parent then
				card:Destroy()
			end
		end)
	end

	local function makeNotification(notificationTitle, message, duration, isToast)
		if window._destroyed then
			return nil
		end
		local template = isToast and toastTemplate or notificationTemplate
		local card = template:Clone()
		card.Visible = true
		card.Parent = screenGui
		local items = isToast and activeToasts or activeNotifications
		local titleObject = card:FindFirstChild("title")
		local textObject = card:FindFirstChild("text")
		if isToast then
			if textObject then
				textObject.Text = tostring(message or "")
			end
		else
			if titleObject then
				titleObject.Text = tostring(notificationTitle or "Notification")
			end
			if textObject then
				textObject.Text = tostring(message or "")
			end
		end

		table.insert(items, card)
		renumberStack(items, template, isToast)
		local lifetime = math.max(0, tonumber(duration) or 3)
		task.delay(lifetime, function()
			fadeAndDestroy(card, items, template, isToast)
		end)
		return card
	end

	window.sendNotification = addMethod(window, function(notificationTitle, message, duration)
		return makeNotification(notificationTitle, message, duration, false)
	end)
	window.sendToast = addMethod(window, function(message, duration)
		return makeNotification(nil, message, duration, true)
	end)

	local function bindKeybind(control, keyCode)
		control.keyCode = keyCode
		control.inputBox.Text = control._listening and "Press key..." or (keyCode and keyCode.Name or "Key")
	end

	local function stopListening(control)
		if window._activeKeybind == control then
			window._activeKeybind = nil
		end
		control._listening = false
		control.inputBox.Text = control.keyCode and control.keyCode.Name or "Key"
	end

	local function startListening(control)
		if window._activeKeybind and window._activeKeybind ~= control then
			stopListening(window._activeKeybind)
		end
		window._activeKeybind = control
		control._listening = true
		control.inputBox.Text = "Press key..."
	end

	windowBag:Connect(UserInputService.InputBegan, function(input, gameProcessed)
		if input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end
		local keyCode = input.KeyCode
		if window._activeKeybind then
			local control = window._activeKeybind
			if keyCode == Enum.KeyCode.Escape then
				control.inputBox:ReleaseFocus()
				stopListening(control)
			elseif keyCode ~= Enum.KeyCode.Unknown then
				bindKeybind(control, keyCode)
				control.inputBox:ReleaseFocus()
				stopListening(control)
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
				invoke(keybind.callback, keyCode)
			end
		end
	end)

	windowBag:Connect(minimizeButton.Activated, function()
		setMinimized(true)
	end)
	windowBag:Connect(maximizeButton.Activated, function()
		setMinimized(false)
	end)
	windowBag:Connect(unloadButton.Activated, function()
		window.destroy()
	end)

	window.createTab = addMethod(window, function(tabName)
		local name = tostring(tabName or ("Tab " .. tostring(#tabs + 1)))
		local page
		if #tabs == 0 then
			page = firstPage
			page.Name = "Tab_1"
		else
			page = pageTemplate:Clone()
			page.Name = "Tab_" .. tostring(#tabs + 1)
			page.Visible = false
			page.Parent = tabHolder
		end

		local pageTitle = page:FindFirstChild("_Title")
		if pageTitle and pageTitle:IsA("TextLabel") then
			pageTitle.Text = name
		end
		page.Visible = false
		local navButton = navButtonTemplate:Clone()
		navButton.Name = "TabButton_" .. tostring(#tabs + 1)
		navButton.Text = name
		navButton.LayoutOrder = #tabs + 1
		navButton.Visible = true
		navButton.Parent = tabButtons

		local tab = {
			name = name,
			_page = page,
			_button = navButton,
			_controls = {},
			_nextLayoutOrder = 3,
		}

		local function selectTab()
			for _, existingTab in ipairs(tabs) do
				existingTab._page.Visible = false
			end
			page.Visible = true
			activeTab = tab
			window._activeTab = tab
		end

		local tabBag = newConnectionBag(window)
		tabBag:Connect(navButton.Activated, selectTab)
		if not activeTab then
			selectTab()
		end
		table.insert(tabs, tab)

		local function cloneControl(templateName, order)
			local control = templates[templateName]:Clone()
			control.LayoutOrder = order or tab._nextLayoutOrder
			control.Visible = true
			tab._nextLayoutOrder = math.max(tab._nextLayoutOrder, control.LayoutOrder + 1)
			control.Parent = page
			return control
		end

		local function register(control)
			table.insert(tab._controls, control)
			return control
		end

		local function cloneHitbox(parent, name, position, size, anchorPoint, zIndex)
			return createActivationButton(parent, name, position, size, anchorPoint, zIndex)
		end

		tab.createButton = addMethod(tab, function(controlName, callback)
			local row = cloneControl("Button")
			row.Name = "Button"
			local nameLabel = row:FindFirstChild("Name")
			if nameLabel and nameLabel:IsA("TextLabel") then
				nameLabel.Text = tostring(controlName or "Button")
			end
			local hitbox = cloneHitbox(row, "Action", UDim2.new(0, 0, 0, 0), UDim2.fromScale(1, 1), Vector2.zero, row.ZIndex + 5)
			local bag = newConnectionBag(window)
			bag:Connect(hitbox.Activated, function()
				invoke(callback)
			end)
			return register({ instance = row, button = hitbox })
		end)

		tab.createToggle = addMethod(tab, function(controlName, callback, initialValue)
			local row = cloneControl("Toggle")
			row.Name = "Toggle"
			local nameLabel = row:FindFirstChild("Name")
			local toggleBack = row:FindFirstChild("ToggleBtnBack")
			if nameLabel and nameLabel:IsA("TextLabel") then
				nameLabel.Text = tostring(controlName or "Toggle")
			end
			assert(toggleBack and toggleBack:IsA("GuiObject"), "Toggle template is missing ToggleBtnBack.")
			local value = not not initialValue
			local originalColor = toggleBack.BackgroundColor3
			local function set(nextValue, notify)
				value = not not nextValue
				animate(toggleBack, 0.14, { BackgroundColor3 = value and accent or originalColor })
				if notify then
					invoke(callback, value)
				end
			end
			local hitbox = cloneHitbox(row, "ToggleAction", UDim2.new(0, 0, 0, 0), UDim2.fromScale(1, 1), Vector2.zero, row.ZIndex + 5)
			local bag = newConnectionBag(window)
			bag:Connect(hitbox.Activated, function()
				set(not value, true)
			end)
			set(value, false)
			return attachHandleMethods(register({ instance = row, button = hitbox }), set, function()
				return value
			end)
		end)

		tab.createLabel = addMethod(tab, function(text)
			local row = cloneControl("Label")
			row.Name = "Label"
			local nameLabel = row:FindFirstChild("Name")
			if nameLabel and nameLabel:IsA("TextLabel") then
				nameLabel.Text = tostring(text or "")
			end
			local function set(value)
				if nameLabel then
					nameLabel.Text = tostring(value or "")
				end
			end
			return attachHandleMethods(register({ instance = row, label = nameLabel }), set)
		end)

		tab.createDivider = addMethod(tab, function()
			local row = cloneControl("Divider")
			row.Name = "Divider"
			return register({ instance = row })
		end)

		tab.createInput = addMethod(tab, function(controlName, callback, placeholder)
			local row = cloneControl("Input")
			row.Name = "Input"
			local nameLabel = row:FindFirstChild("Name")
			local textBox = row:FindFirstChild("InputBox")
			if nameLabel and nameLabel:IsA("TextLabel") then
				nameLabel.Text = tostring(controlName or "Input")
			end
			assert(textBox and textBox:IsA("TextBox"), "Input template is missing InputBox.")
			textBox.Text = ""
			textBox.PlaceholderText = tostring(placeholder or "")
			local bag = newConnectionBag(window)
			bag:Connect(textBox.FocusLost, function()
				invoke(callback, textBox.Text)
			end)
			local function set(value)
				textBox.Text = tostring(value or "")
			end
			local control = register({ instance = row, textBox = textBox })
			return attachHandleMethods(control, set, function()
				return textBox.Text
			end)
		end)

		tab.createKeybind = addMethod(tab, function(controlName, callback, initialKey)
			local row = cloneControl("Keybind")
			row.Name = "Keybind"
			local nameLabel = row:FindFirstChild("Name")
			local textBox = row:FindFirstChild("InputBox")
			if nameLabel and nameLabel:IsA("TextLabel") then
				nameLabel.Text = tostring(controlName or "Keybind")
			end
			assert(textBox and textBox:IsA("TextBox"), "Keybind template is missing InputBox.")
			local keyCode = normalizeKeyCode(initialKey)
			local control = {
				instance = row,
				inputBox = textBox,
				keyCode = keyCode,
				callback = callback,
				_listening = false,
			}
			textBox.ClearTextOnFocus = false
			textBox.Text = keyCode and keyCode.Name or "Key"

			local function set(value)
				keyCode = normalizeKeyCode(value)
				control.keyCode = keyCode
				if not control._listening then
					textBox.Text = keyCode and keyCode.Name or "Key"
				end
			end
			local bag = newConnectionBag(window)
			bag:Connect(textBox.Focused, function()
				startListening(control)
			end)
			bag:Connect(textBox.FocusLost, function()
				if window._activeKeybind == control then
					window._activeKeybind = nil
				end
				control._listening = false
				textBox.Text = keyCode and keyCode.Name or "Key"
			end)
			table.insert(window._keybinds, control)
			return attachHandleMethods(register(control), set, function()
				return keyCode
			end)
		end)

		tab.createSlider = addMethod(tab, function(controlName, minimum, maximum, callback, step)
			local minValue = tonumber(minimum) or 0
			local maxValue = tonumber(maximum) or 100
			assert(maxValue >= minValue, "Slider maximum must be greater than or equal to its minimum.")
			local increment = tonumber(step) or 1
			if increment <= 0 then
				increment = 1
			end
			local row = cloneControl("Slider")
			row.Name = "Slider"
			local nameLabel = row:FindFirstChild("Name")
			local track = row:FindFirstChild("slider_bg")
			local dot = track and track:FindFirstChild("slider_dot")
			local valueLabel = row:FindFirstChild("Value_Label")
			if nameLabel and nameLabel:IsA("TextLabel") then
				nameLabel.Text = tostring(controlName or "Slider")
			end
			assert(track and dot and valueLabel, "Slider template is missing its track, dot, or value label.")

			local value = minValue
			local function updateVisuals()
				local alpha = maxValue == minValue and 0 or (value - minValue) / (maxValue - minValue)
				dot.Position = UDim2.new(alpha, 0, 0.5, 0)
				valueLabel.Text = formatNumber(value)
			end
			local function set(nextValue, notify)
				local number = math.clamp(tonumber(nextValue) or minValue, minValue, maxValue)
				if maxValue > minValue and number > minValue and number < maxValue then
					number = minValue + math.round((number - minValue) / increment) * increment
					number = math.clamp(number, minValue, maxValue)
				end
				local changed = number ~= value
				value = number
				updateVisuals()
				if notify and changed then
					invoke(callback, value)
				end
			end
			local function updateFromInput(input)
				local width = track.AbsoluteSize.X
				if width <= 0 then
					return
				end
				local alpha = math.clamp((input.Position.X - track.AbsolutePosition.X) / width, 0, 1)
				set(minValue + (maxValue - minValue) * alpha, true)
			end
			updateVisuals()

			local activeInput
			local bag = newConnectionBag(window)
			local function startDrag(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					activeInput = input
					updateFromInput(input)
				end
			end
			bag:Connect(track.InputBegan, startDrag)
			bag:Connect(dot.InputBegan, startDrag)
			bag:Connect(UserInputService.InputChanged, function(input)
				local mouseDrag = activeInput and activeInput.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseMovement
				local touchDrag = activeInput and activeInput.UserInputType == Enum.UserInputType.Touch and input == activeInput
				if mouseDrag or touchDrag then
					updateFromInput(input)
				end
			end)
			bag:Connect(UserInputService.InputEnded, function(input)
				if activeInput and (input == activeInput or input.UserInputType == Enum.UserInputType.MouseButton1) then
					activeInput = nil
				end
			end)

			return attachHandleMethods(register({ instance = row }), set, function()
				return value
			end)
		end)
		tab.CreateSlider = tab.createSlider

		tab.createDropdown = addMethod(tab, function(controlName, options, callback, initialValue)
			local optionList = type(options) == "table" and options or {}
			local order = tab._nextLayoutOrder
			local closed = cloneControl("Dropdown_Closed", order)
			local opened = cloneControl("Dropdown_Opened", order)
			closed.Name = "Dropdown_Closed"
			opened.Name = "Dropdown_Opened"
			opened.Visible = false
			local closedName = closed:FindFirstChild("Name")
			local closedPick = closed:FindFirstChild("Pick")
			local openName = opened:FindFirstChild("Name")
			local openPick = opened:FindFirstChild("Pick")
			local optionScroll = opened:FindFirstChild("Options")
			if closedName then closedName.Text = tostring(controlName or "Dropdown") end
			if openName then openName.Text = tostring(controlName or "Dropdown") end
			assert(closedPick and openPick and optionScroll, "Dropdown template is missing Name, Pick, or Options.")
			optionScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
			optionScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

			local selected = initialValue
			if selected == nil then
				selected = "Dropdown"
			end
			closedPick.Text = tostring(selected)
			openPick.Text = tostring(selected)

			for _, child in ipairs(optionScroll:GetChildren()) do
				if child:IsA("Frame") then
					child:Destroy()
				end
			end
			local extraHeight = math.max(0, #optionList - 2) * 30
			if extraHeight > 0 then
				opened.Size = UDim2.new(opened.Size.X.Scale, opened.Size.X.Offset, opened.Size.Y.Scale, opened.Size.Y.Offset + extraHeight)
				optionScroll.Size = UDim2.new(optionScroll.Size.X.Scale, optionScroll.Size.X.Offset, optionScroll.Size.Y.Scale, optionScroll.Size.Y.Offset + extraHeight)
			end

			local value = selected
			local function setOpen(isOpen)
				closed.Visible = not isOpen
				opened.Visible = isOpen
			end
			local function set(nextValue, notify)
				value = nextValue
				closedPick.Text = tostring(nextValue)
				openPick.Text = tostring(nextValue)
				setOpen(false)
				if notify then
					invoke(callback, nextValue)
				end
			end

			for index, option in ipairs(optionList) do
				local optionValue = option
				local optionFrame = optionTemplate:Clone()
				optionFrame.Name = "Option_" .. tostring(index)
				optionFrame.LayoutOrder = index
				optionFrame.Visible = true
				optionFrame.Parent = optionScroll
				local optionLabel = optionFrame:FindFirstChild("Name")
				if optionLabel and optionLabel:IsA("TextLabel") then
					optionLabel.Text = tostring(optionValue)
				end
				local optionHitbox = cloneHitbox(optionFrame, "SelectOption", UDim2.new(0, 0, 0, 0), UDim2.fromScale(1, 1), Vector2.zero, optionFrame.ZIndex + 5)
				local optionBag = newConnectionBag(window)
				optionBag:Connect(optionHitbox.Activated, function()
					set(optionValue, true)
				end)
			end

			local closedHitbox = cloneHitbox(closed, "OpenDropdown", UDim2.new(0, 0, 0, 0), UDim2.fromScale(1, 1), Vector2.zero, closed.ZIndex + 5)
			local openedHitbox = cloneHitbox(opened, "CloseDropdown", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 30), Vector2.zero, opened.ZIndex + 4)
			local bag = newConnectionBag(window)
			bag:Connect(closedHitbox.Activated, function()
				setOpen(true)
			end)
			bag:Connect(openedHitbox.Activated, function()
				setOpen(false)
			end)

			local control = register({ instance = closed, openedInstance = opened })
			return attachHandleMethods(control, set, function()
				return value
			end)
		end)

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
		if currentSizeTween then
			currentSizeTween:Cancel()
		end
		if currentDragTween then
			currentDragTween:Cancel()
		end
		if screenGui.Parent then
			screenGui:Destroy()
		end
	end
	window.unload = window.destroy
	window.Destroy = window.destroy
	window.Unload = window.destroy

	windowBag:Connect(screenGui.Destroying, function()
		if window._destroyed then
			return
		end
		window._destroyed = true
		for _, bag in ipairs(window._bags) do
			bag:DisconnectAll()
		end
	end)

	return window
end

library.window = addMethod(library, makeWindow)
library.Window = library.window

return library
