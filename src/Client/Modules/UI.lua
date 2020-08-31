local UI = {}

local Roact = require(game:GetService("ReplicatedStorage").Roact)
local Players = game:GetService("Players")


local PlayerGui = Players.LocalPlayer.PlayerGui

local Inventory = Roact.Component:extend("Inventory")

function Inventory:init()
    -- In init, we can use setState to set up our initial component state.
    self:setState({
        name = "Inventory"
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
    return Roact.createElement("TextLabel", {
        Text = name,
        Size = UDim2.new(.2,0,.2,0)
    })
end

function Inventory:render()
    local default_name = self.state.name

    return Roact.createElement("ScreenGui",{},{
    Layout = Roact.createElement("UIListLayout"),
    hello1 = Roact.createElement(create_element, {
        name = default_name
    }),
    hello2= Roact.createElement(create_element, {
        name = "Joe2"
    })
})

end

local inventory_handle = Roact.mount(Roact.createElement(Inventory), PlayerGui, "Inventory UI")

return UI