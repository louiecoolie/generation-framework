local UI = {}

local Roact = require(game:GetService("ReplicatedStorage").Roact)
local Players = game:GetService("Players")


local PlayerGui = Players.LocalPlayer.PlayerGui



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

local hello_ui = Roact.createElement("ScreenGui",{},{
    Layout = Roact.createElement("UIListLayout"),
    hello1 = Roact.createElement(create_element, {
        name = "Joe"
    }),
    hello2= Roact.createElement(create_element, {
        name = "Joe2"
    })
})

Roact.mount(hello_ui, PlayerGui)

return UI