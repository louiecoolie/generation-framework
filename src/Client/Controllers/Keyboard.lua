local Keyboard = {}

local ContextActionService = game:GetService("ContextActionService")

function Keyboard.Bind(action, function_bind, mobile_support, key)
    ContextActionService:BindAction(action, function_bind, mobile_support, key)
end

function Keyboard.Unbind(action)
    ContextActionService:Unbind(action)
end


return Keyboard