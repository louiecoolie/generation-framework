local UI = {}

local Roact = require(game:GetService("ReplicatedStorage").Roact)
local Players = game:GetService("Players")

local ClientEvents = game:GetService("ReplicatedStorage"):WaitForChild("Events", 60)

local player_inventory = {}
local Events = {}

for _, event in ipairs(ClientEvents:GetChildren()) do
    ClientEvents:WaitForChild(event.Name, 5)

end

for _, event in ipairs(ClientEvents:GetChildren()) do
	Events[event.Name] = event
	
end

local PlayerGui = Players.LocalPlayer.PlayerGui

local Inventory = Roact.Component:extend("Inventory")

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



local inventory_handle = Roact.mount(Roact.createElement(Inventory), PlayerGui, "Inventory UI")

Events["inventory_update"].OnClientEvent:Connect(function(number, object)

    player_inventory[object] = number

    inventory_dictionary[object] = Roact.createElement(create_element, {
        name = object,
        count = number
    })
    Roact.unmount(inventory_handle)
    inventory_handle = Roact.mount(Roact.createElement(Inventory), PlayerGui, "Inventory UI")

end)

return UI