local UI = {}

local Roact = require(game:GetService("ReplicatedStorage").Roact)
local Players = game:GetService("Players")
local ClientEvents = game:GetService("ReplicatedStorage"):WaitForChild("Events", 60)

local player_inventory = {}
local Events = {}

local ui_state = {
    inventory = false
}

local ui_handles = {
    inventory_handle = nil
}

local ui_connections = {
    update_inventory = nil
}

for _, event in ipairs(ClientEvents:GetChildren()) do
    ClientEvents:WaitForChild(event.Name, 5)

end

for _, event in ipairs(ClientEvents:GetChildren()) do
	Events[event.Name] = event
	
end

local PlayerGui = Players.LocalPlayer.PlayerGui

local Inventory = Roact.Component:extend("Inventory")
local Toolbar = Roact.Component:extend("Toolbar")

function Inventory:init()
    self.inventoryRef = Roact.createRef()
    -- In init, we can use setState to set up our initial component state.
    self:setState({
        name = "Inventory",
        count = 0,
        inventory = {},
        splash = "rbxassetid://5647359993",
        background = "rbxassetid://5647360086",
        default_size = 300,
        default_offset = 150,

    })
end

local function create_element(properties)
    local name = properties.name
    local count = properties.count

    local text 

    if count then
        text = (name .. " " .. count)
    else
        text = name
    end

    return Roact.createElement("TextLabel", {
        Text = text,
        BackgroundTransparency = 1,
        BorderSizePixel = 2,
        Size = UDim2.new(.2,0,.2,0)
    })
end

local inventory_dictionary = {
    Layout = Roact.createElement("UIListLayout",{
        --Padding = UDim.new(10,10)
        --FillDirection = Enum.FillDirection.Horizontal
    }),
}

function Inventory:render()
    local size = self.state.default_size
    local offset = self.state.default_offset

    return Roact.createElement("ScreenGui",{},{
        inventory_container = Roact.createElement("Frame",{
            Size = UDim2.new(0,100, 0, 100),
            Position = UDim2.new(.5,-50,.5,-100),
            Transparency = 1
        },{
            Backdrop = Roact.createElement("ImageLabel", {
                Size = UDim2.new(0, size, 0, size),
                Image = self.state.background,
                Transparency = 1,
                Position = UDim2.new(.5,-offset,.5,-offset),
                BackgroundTransparency = 1,
                ZIndex = 0
            }),
            ColorSplash = Roact.createElement("ImageLabel", {
                Size = UDim2.new(0, size, 0, size),
                Image = self.state.splash,
                Transparency = 1,
                Position = UDim2.new(.5,-offset,.5,-offset),
                BackgroundTransparency = 1,
                ZIndex = 1
            }),
            inventory = Roact.createElement("Frame",{
                [Roact.Ref] = self.inventoryRef,
                Size = UDim2.new(0,size/1.5, 0, size/1.5),
                Position =UDim2.new(.5,-offset/1.5,.5,-offset/1.5),
                Transparency = 1,
                ZIndex = 1,
            },
                
            
            
              inventory_dictionary


            )
        })
    })

end


function Inventory:didMount()

    local inventoryFrame = self.inventoryRef
   -- print(inventoryFrame)


            
end

function Inventory:willUnmount()
    --ui_connections.update_inventory:Disconnect()
end


function Toolbar:init()
    self:setState({
        frame = "rbxassetid://5645586350",
        backpack = "rbxassetid://5645586537"
    })
    self.clickCount, self.updateClickCount = Roact.createBinding(0)
    self.backpackRef = Roact.createRef()
end

function Toolbar:render()

    return Roact.createElement("ScreenGui", {}, {
        Tools = Roact.createElement("Frame",{
            Size =  UDim2.new(0, 100, 0, 100),
            Position = UDim2.new(.5, -50, 1, -100),
            BackgroundTransparency = 1
        },{
            Backpack = Roact.createElement("Frame", {
                Size = UDim2.new(0, 100, 0, 100),
                BackgroundTransparency = 1
            },{
                Frame = Roact.createElement("ImageLabel", {
                    Size = UDim2.new(0, 100, 0, 100),
                    Image = self.state.frame,
                    BackgroundTransparency = 1,
                    ZIndex = 0
                }),
                Icon = Roact.createElement("ImageLabel", {
                    [Roact.Ref] = self.backpackRef,
                    Size = UDim2.new(0, 50, 0, 50),
                    Image = self.state.backpack,
                    Position = UDim2.new(0,25,0,25),
                    BackgroundTransparency = 1,
                    ZIndex = 1
                }),
                Button = Roact.createElement("TextButton", {
                    Text = "E",
                    Size = UDim2.new(0, 100, 0, 100),
                    BackgroundTransparency = 1,
                    ZIndex = 2,
                    [Roact.Event.Activated] = function()
                        -- When the user clicks the button, the count will be incremented and
                        -- Roact will update any properties that are subscribed to the binding
                       -- self.updateClickCount(self.clickCount:getValue() + 1)
                       
                    end
                })
            })
        })
    })

end

function Toolbar:didMount()
    local function UpdateToolbar()
        local backpackImage = self.backpackRef:getValue()
        print(backpackImage.Image)
        if ui_state.inventory == true then
            backpackImage.Image = "rbxassetid://5647427383"
        else
            backpackImage.Image = "rbxassetid://5645586537"
        end
       
    end
        -- The actual Instance can be retrieved using the `getValue` method


    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.E then
                UpdateToolbar()
            end
        end
    end)

end

ui_handles.toolbar_handle = Roact.mount(Roact.createElement(Toolbar), PlayerGui, "Toolbar UI")

function UI.ToggleInventory(action, input_state)
    print(action)
    if input_state == Enum.UserInputState.Begin then
        if ui_state.inventory == false then
            if ui_connections.passive_inventory then
                 ui_connections.passive_inventory:Disconnect() 
            end

            ui_handles.inventory_handle = Roact.mount(Roact.createElement(Inventory), PlayerGui, "Inventory UI")
            ui_connections.update_inventory = Events["inventory_update"].OnClientEvent:Connect(function(number, object)

                player_inventory[object] = number
            
                inventory_dictionary[object] = Roact.createElement(create_element, {
                   name = object,
                    count = number
                })
                Roact.unmount(ui_handles.inventory_handle)
                ui_handles.inventory_handle = Roact.mount(Roact.createElement(Inventory), PlayerGui, "Inventory UI")
            end)
            ui_state.inventory = true
            --ui_handles.toolbar_handle = Roact.update(ui_handles.toolbar_handle)
        elseif ui_state.inventory == true then
            Roact.unmount(ui_handles.inventory_handle)
            ui_connections.update_inventory:Disconnect()
            ui_connections.passive_inventory = Events["inventory_update"].OnClientEvent:Connect(function(number, object)

                player_inventory[object] = number
            
                inventory_dictionary[object] = Roact.createElement(create_element, {
                   name = object,
                    count = number
                })
            end)
            ui_state.inventory = false
        end
    end
end

return UI