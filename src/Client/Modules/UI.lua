local UI = {}

local Roact = require(game:GetService("ReplicatedStorage").Roact)
local Players = game:GetService("Players")
local ClientEvents = game:GetService("ReplicatedStorage"):WaitForChild("Events", 60)

local player_inventory = {}
local inventory_cameras = {}
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
  
    self:setState({
        name = "Inventory",
        count = 0,
        inventory = {},
        splash = "rbxassetid://5667517917",
        background = "rbxassetid://5667517869",
        default_size = 450,
        default_offset = (450/2),

    })
end

local function create_element(properties)
    local name = properties.name
    local count = properties.count
    local item = properties.item

    local model = Instance.new("Model")
    item:Clone().Parent = model
    local text 

    if count then
        text = (name .. " " .. count)
    else
        text = name
    end

    if inventory_cameras[name] == nil then
        local new_camera = Instance.new("Camera")
        new_camera.CFrame = CFrame.new(5,5,5)
        new_camera.Name = name
        new_camera.CFrame = CFrame.new(new_camera.CFrame.Position, Vector3.new(0,0,-5))
        inventory_cameras[name] = new_camera
    end


    return Roact.createElement("Frame",{
        Size = UDim2.new(0,100,0,100),
        BackgroundTransparency = 0,
        BorderColor3 = Color3.new(0.6, 0.5, 0.4),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 2,
        ZIndex = 4
    },{
        Description = Roact.createElement("TextLabel",  {
            Text = text,
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            Size = UDim2.new(1,0,0,10),
            Position = UDim2.new(0,0,.5,40),
            ZIndex = 6
        }),
        View = Roact.createElement("ViewportFrame",{
            Size = UDim2.new(0,100,0,100),
            ZIndex = 5,
            CurrentCamera = inventory_cameras[name]
            --Model = model
        },{
            ItemPart = Roact.createElement("Part", {
                Anchored = true,
                Position = Vector3.new(0,0,-5),
                Color = item.Color,
                Size = item.Size
            }),
            SomeCamera = Roact.createElement("Camera",{})
        
        })
    })
end

local inventory_dictionary = {
    Layout = Roact.createElement("UIGridLayout",{
        FillDirection = Enum.FillDirection.Horizontal,
        FillDirectionMaxCells = 3
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
            InventoryButton = Roact.createElement("TextButton", {
                Size = UDim2.new(0,100,0,50),
                Position = UDim2.new(0,-size/1.5,0,0),
                Text = "Inventory",
                ZIndex = 100


            }),

            CraftButton = Roact.createElement("TextButton", {
                Size = UDim2.new(0,100,0,50),
                Text = "Craft",
                Position = UDim2.new(0,-size/1.5,0,100),
                ZIndex = 100


            }),


            BackpackFrame = Roact.createElement("ImageLabel", {
                Size = UDim2.new(0, size*2, 0, size),
                Image = self.state.background,
                Transparency = 1,
                Position = UDim2.new(.5,-offset*2,.5,-offset),
                BackgroundTransparency = 1,
                ZIndex = 1
            },{
                inventory = Roact.createElement("Frame",{
                    [Roact.Ref] = self.inventoryRef,
                    Size = UDim2.new(0,size/1.1, 0, size/1.8),
                   Position = UDim2.new(.5,-offset/1.1,.5,-offset/1.7),
                    Transparency = 1,
                    ZIndex = 2,
                },
                    
                
                
                  inventory_dictionary
    
    
                )
            }),
            ColorSplash = Roact.createElement("ImageLabel", {
                Size = UDim2.new(0, size*2, 0, size),
                Image = self.state.splash,
                Transparency = 1,
                Position = UDim2.new(.5,-offset*2,.5,-offset),
                BackgroundTransparency = 1,
                ZIndex = 0
            }),
        --    inventory = Roact.createElement("Frame",{
         --       [Roact.Ref] = self.inventoryRef,
          --      Size = UDim2.new(0,size*2, 0, size),
           --     Position =UDim2.new(.5,-offset*2,.5,-offset),
          --      Transparency = 1,
          --      ZIndex = 2,
          --  },
                
            
            
           --   inventory_dictionary


           -- )
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
    self.inventory_open = false
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
                        if self.inventory_open == false then
                            self.inventory_open = true
                            self.backpackRef:getValue().Image = "rbxassetid://5647427383"
                            UI.ToggleInventory("backpack openned", Enum.UserInputState.Begin)
                        elseif self.inventory_open == true then
                            self.inventory_open = false
                            self.backpackRef:getValue().Image = "rbxassetid://5645586537"
                            UI.ToggleInventory("backpack close", Enum.UserInputState.Begin)
                        end
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
            self.inventory_open = true
            backpackImage.Image = "rbxassetid://5647427383"
        else
            self.inventory_open = false
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

ui_connections.passive_inventory = Events["inventory_update"].OnClientEvent:Connect(function(number, object)

    player_inventory[object.Name] = number

    inventory_dictionary[object.Name] = Roact.createElement(create_element, {
        name = object.Name,
        count = number,
        item = object
    })
end)

function UI.ToggleInventory(action, input_state)
    print(action)
    if input_state == Enum.UserInputState.Begin then
        if ui_state.inventory == false then

            ui_handles.inventory_handle = Roact.mount(Roact.createElement(Inventory), PlayerGui, "Inventory UI")
            ui_connections.update_inventory = Events["inventory_update"].OnClientEvent:Connect(function(number, object)

                player_inventory[object.Name] = number
                print(object.Size)
                inventory_dictionary[object.Name] = Roact.createElement(create_element, {
                    name = object.Name,
                    count = number,
                    item = object
                })
                Roact.unmount(ui_handles.inventory_handle)
                ui_handles.inventory_handle = Roact.mount(Roact.createElement(Inventory), PlayerGui, "Inventory UI")
            end)
            ui_state.inventory = true
            --ui_handles.toolbar_handle = Roact.update(ui_handles.toolbar_handle)
        elseif ui_state.inventory == true then
            Roact.unmount(ui_handles.inventory_handle)
            ui_connections.update_inventory:Disconnect()

            ui_state.inventory = false
        end
    end
end

return UI