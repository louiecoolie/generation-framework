local Forage = {}

local function GetMousePoint(mouse_ray)
	local RayMag1 = mouse_ray
	local NewRay = Ray.new(RayMag1.Origin, RayMag1.Direction * 1000)
	local Target, Position = workspace:FindPartOnRay(NewRay)
	return Target, Position
end

function Forage.DetectForage(forage_ray)
    local forage, forage_location = GetMousePoint(forage_ray)
    forage.Anchored = false
    print(forage, forage_location)
end


return Forage