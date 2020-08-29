local Forage = {}

local function GetMousePoint(mouse_ray)
	local RayMag1 = mouse_ray
	local NewRay = Ray.new(RayMag1.Origin, RayMag1.Direction * 1000)
	local Target, Position = workspace:FindPartOnRay(NewRay)
	return Target, Position
end

function Forage.DetectForage(forage_ray)
    local forage, forage_location = GetMousePoint(forage_ray)
    if forage:FindFirstChild("forage_value") then
        local forageable = forage:FindFirstChild("forage_value").Value
        if forageable then
            forage.Size = Vector3.new(forage.Size.X/2, forage.Size.Y/2, forage.Size.Z/2)
            forage.CanCollide = true
            forage.Anchored = false
            forage:FindFirstChild("forage_value").Value = false
        else
            print ("ready to pick up")

        end

    end
    print(forage, forage_location)
end


return Forage