local Generate = {}

local points_container = workspace:FindFirstChild("points_container") or Instance.new("Folder", workspace)
points_container.Name = "points_container"

local generation_number = 0

function Generate.AnimalSpawns(region_center, region_radius, spawn_points, spawn_gap, spawn_animal, spawn_plant)

    local function CreateSpawnPoint(position)
        generation_number += 1

        local spawn_point = Instance.new("Part")
        spawn_point.Name = "spawn_point"
		spawn_point.Anchored =  true
		spawn_point.CanCollide = false
        spawn_point.Position = position
        spawn_point.Transparency = 1
        
        
        local spawn_value = Instance.new("StringValue")
        spawn_value.Name = "spawn_value"
        spawn_value.Value = spawn_animal or "nil"

        local request_value = Instance.new("StringValue")
        request_value.Name = "request_value"
        request_value.Value = "nil"

        local spawn_number = Instance.new("NumberValue")
        spawn_number.Name = "spawn_number"
        spawn_number.Value = generation_number

        local plant_value = Instance.new("StringValue")
        plant_value.Name = "plant_value"
        plant_value.Value = spawn_plant or "nil"

        request_value.Parent = spawn_point
        spawn_value.Parent = spawn_point
        spawn_number.Parent = spawn_point
        plant_value.Parent = spawn_point
        
		spawn_point.Parent = points_container	
	end


    for _ = 1, spawn_points, 1 do
        local min_x, max_x = region_center.x - region_radius, region_center.x + region_radius
        local min_y, max_y = region_center.y - region_radius, region_center.x + region_radius
    
        local random_x, random_y = math.random(min_x, max_x), math.random(min_y, max_y)
		        
		CreateSpawnPoint(Vector3.new(random_x+spawn_gap, 4, random_y+spawn_gap))
		
        print("Created spawn point at: " .. random_x .. " " .. random_y)

    end
end


return Generate