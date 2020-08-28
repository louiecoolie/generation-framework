local Tool = {}

local ClientEvents = game:GetService("ReplicatedStorage"):WaitForChild("Events", 60)

local Events = {}

for _, event in ipairs(ClientEvents:GetChildren()) do
    ClientEvents:WaitForChild(event.Name, 5)

end

for _, event in ipairs(ClientEvents:GetChildren()) do
	Events[event.Name] = event
	
end


function Tool.GetEvents(events)
    --Events = events
end


function Tool.ToggleEquip(action, input_state, para)


end

function Tool.Forage(action, input_state, input_object)
    local forage_ray =  workspace.Camera:ScreenPointToRay(input_object.Position.X, input_object.Position.Y)

    Events["forage_request"]:FireServer(forage_ray)
end



return Tool