local Forage = {}

local Events = game:GetService("ReplicatedStorage"):FindFirstChild("Events", 60)

local Inventories = game:GetService("ServerStorage"):FindFirstChild("Inventories") or Instance.new("Folder", game:GetService("ServerStorage"))
Inventories.Name = "Inventories"

local function AddItem(player_inventory, item, player)
    local player_item = player_inventory:FindFirstChild(item.Name)
    if player_item then
        player_item.Count.Value = player_item.Count.Value + 1
        Events:FindFirstChild("inventory_update"):FireClient(player, player_item.Count.Value, item.Name)
        item:Destroy()
    else
        local new_item = Instance.new("Folder", player_inventory)
        new_item.Name = item.Name
        local item_value = Instance.new("ObjectValue")
        local count_value = Instance.new("NumberValue")
        
        item_value.Name = item.Name
        count_value.Name = "Count"

        item_value.Value = item
        count_value.Value = 1

        item_value.Parent = new_item 
        count_value.Parent = new_item
        Events:FindFirstChild("inventory_update"):FireClient(player, count_value.Value, item_value.Name)
        item:Destroy()
    end

end

local function GetMousePoint(mouse_ray)
	local RayMag1 = mouse_ray
	local NewRay = Ray.new(RayMag1.Origin, RayMag1.Direction * 1000)
	local Target, Position = workspace:FindPartOnRay(NewRay)
	return Target, Position
end

function Forage.DetectForage(player, forage_ray)
    local forage, forage_location = GetMousePoint(forage_ray)
    if forage then
        if forage:FindFirstChild("forage_value") then
            local forageable = forage:FindFirstChild("forage_value").Value
            if forageable then
                forage.Size = Vector3.new(forage.Size.X/2, forage.Size.Y/2, forage.Size.Z/2)
                forage.CanCollide = true
                forage.Anchored = false
                forage:FindFirstChild("forage_value").Value = false
            else
                
                local player_inventory = Inventories:FindFirstChild(player.Name)
                if player_inventory then
                    print ("ready to pick up")
                    AddItem(player_inventory, forage, player)
                else
                    local player_folder = Instance.new("Folder", Inventories)
                    player_folder.Name = player.Name
                    AddItem(player_folder, forage, player)
                end

            end

        end
    end
end


return Forage