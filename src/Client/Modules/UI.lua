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
    -- In init, we can use setState to set up our initial component state.
    self:setState({
        name = "Inventory",
        count = 0,
        inventory = {}
    })
end

--local function HelloUI(props)
  --  local name = props.name
  --  return Roact.createElement("ScreenGui", {},{
      --  TimeLabel = Roact.createElement("TextLabel",{
      --      Size = UDim2.new(.2,0,.2,0),
      --      Text = "Hello, " .. name
       -- })
   -- })
--end

--local hello_element = Roact.createElement(HelloUI, {
   -- name = "Joe"
--})
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
        Size = UDim2.new(.2,0,.2,0)
    })
end

local inventory_dictionary = {
    Layout = Roact.createElement("UIListLayout"),
    hello1 = Roact.createElement(create_element, {
        name = "Inventory"
    })
}

function Inventory:render()

    --for item, count in ipairs(inventory) do
       -- inventory_dictionary[item] = Roact.createElement(create_element, {
           -- value = count
       -- })
    --end

    return Roact.createElement("ScreenGui",{},inventory_dictionary)

end


function Inventory:didMount()
          
end

function Toolbar:init()
    self:setState({
        frame = "rbxassetid://5645586350",
        backpack_close = "rbxassetid://5645586537"
    })
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
                    Size = UDim2.new(0, 50, 0, 50),
                    Image = self.state.backpack_close,
                    Position = UDim2.new(0,25,0,25),
                    BackgroundTransparency = 1,
                    ZIndex = 1
                })
            })
        })
    })

end

ui_handles.toolbar_handle = Roact.mount(Roact.createElement(Toolbar), PlayerGui, "Toolbar UI")

function UI.ToggleInventory(action, input_state)
    print(action)
    if input_state == Enum.UserInputState.Begin then
        if ui_state.inventory == false then
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
        elseif ui_state.inventory == true then
            Roact.unmount(ui_handles.inventory_handle)
            ui_connections.update_inventory:Disconnect()
            ui_state.inventory = false
        end
    end
end

return UI