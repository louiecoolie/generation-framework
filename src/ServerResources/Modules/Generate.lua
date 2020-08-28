local Generate = {}

local points_container = workspace:FindFirstChild("points_container") or Instance.new("Folder", workspace)
points_container.Name = "points_container"

local islands_container = workspace:FindFirstChild("islands_container") or Instance.new("Folder", workspace)
islands_container.Name = "islands_container"

local generation_number = 0

function Generate.Spawns(region_center, region_radius, spawn_points, spawn_gap, spawn_animal, spawn_plant)

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
		        
		CreateSpawnPoint(Vector3.new(random_x+spawn_gap, region_center.Y, random_y+spawn_gap))
		
        print("Created spawn point at: " .. random_x .. " " .. random_y)

    end
end

function Generate.Ocean(region_center, region_radius, region_height)
    local water = Region3.new(Vector3.new(-region_radius, -region_height, -region_radius),Vector3.new(region_radius, 0, region_radius))
    water:ExpandToGrid(4)
    workspace:WaitForChild("Terrain"):FillRegion(water, 4, Enum.Material.Water)
    local sand = Region3.new(Vector3.new(-region_radius, -region_height*2, -region_radius),Vector3.new(region_radius, -region_height, region_radius))
    sand:ExpandToGrid(4)
    workspace:WaitForChild("Terrain"):FillRegion(sand, 4, Enum.Material.Sand)
end

function Generate.Island(region_center, region_radius, region_height, complexity)
    local island_object = Instance.new("Model")
    local island_center = Instance.new("Part")
    island_center.Position = region_center
    island_center.Size = Vector3.new(region_radius, region_height*1.5, region_radius)
    island_center.Anchored = true
    island_center.Color = Color3.fromRGB(82, 78, 76)
    local grass = island_center:Clone()
    grass.Size = Vector3.new(grass.Size.X, 1, grass.Size.Z)
    grass.CFrame = CFrame.new(island_center.CFrame.Position)*CFrame.new(0, (island_center.Size.Y/2)+0.5,0)
    grass.Anchored = true
    grass.Color = Color3.fromRGB(94, 139, 100)
    grass.Parent = island_object
    island_center.Parent = island_object
    for i = 1, complexity do
        local island_segment = Instance.new("Part")
        island_segment.Size = Vector3.new(region_radius*1.5, (region_height/1.5)-i, region_radius*1.5)
        island_segment.CFrame = CFrame.new(island_center.Position)*CFrame.Angles(0, math.rad(90)*i,0)*CFrame.new((region_radius/2)+i,0,i)
        island_segment.Anchored = true
        island_segment.Color = Color3.fromRGB(82, 78, 76)

 
        local sand_segment = Instance.new("Part")
        sand_segment.Size = Vector3.new(region_radius*1.2, (region_height/1.5)-i, region_radius*2)
        sand_segment.CFrame = CFrame.new(island_segment.Position)*CFrame.Angles(0, math.rad(90)*i,0)*CFrame.new((region_radius/2)+i,0,i)*CFrame.new(0,-5,0)
        sand_segment.Anchored = true
        sand_segment.Color = Color3.fromRGB(198, 201, 155)

        local grass_segment = island_segment:Clone()
        grass_segment.Size = Vector3.new(grass_segment.Size.X, 1, grass_segment.Size.Z)
        grass_segment.CFrame = CFrame.new(island_segment.CFrame.Position)*CFrame.new(0, (island_segment.Size.Y/2)+0.5,0)
        grass_segment.Anchored = true
        grass_segment.Color = Color3.fromRGB(94, 139, 100)

        sand_segment.Parent = island_object
        grass_segment.Parent = island_object
        island_segment.Parent = island_object
    end

    island_object.Parent = islands_container
end

return Generate