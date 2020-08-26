local Camera = {}

local Sensitivity = .8
local Smoothness = .19
local deltax
local X = 0
local TargX = 0
local Y = 0
local TargY = 0
local DX = 0
local DY = 0
--local CamPos,TargetCamPos = cam.CoordinateFrame.p,cam.CoordinateFrame.p 
--local pointFocus = char:WaitForChild("HumanoidRootPart")
--local X,TargX = 0,0
--local Y,TargY = 0,char.HumanoidRootPart.Orientation.Y


function Camera.Mode(camera, mode_setting)
    print(mode_setting)
    if mode_setting == "locked" then
        
        camera.CameraType = Enum.CameraType.Scriptable
        game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.LockCenter
        print("yis")
    end
end

function Camera.CalculateDelta(input_object, char)
    --print(input_object)
    --TargY = char.PrimaryPart.Orientation.Y
   -- print(input_object.Delta)
    if input_object.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = Vector2.new(input_object.Delta.x/Sensitivity,input_object.Delta.y/Sensitivity) * Smoothness
        --local delta = Vector2.new(inputObject.Delta.x/Sensitivity,inputObject.Delta.y/Sensitivity) * Smoothness
		local x = TargX - delta.y 
		TargX = (x >= 40 and 40)  or (x <= -55 and -55) or x 
		TargY = (TargY - delta.x) %360 
        
        X = X + (TargX - X) *0.35 
			
        local dist = TargY - Y
        dist = math.abs(dist) > 180 and dist - (dist / math.abs(dist)) * 360 or dist 
        Y = (Y + dist *0.20) %360
        --print(delta)
        --X = TargX - delta.y 
        --TargX = (X >= 40 and 40)  or (X <= -55 and -55) or X 
        --TargY = (TargY - delta.x) %360 
        
        --X = X + (TargX - X) *0.35 
        
        --local dist = TargY - Y
       -- dist = math.abs(dist) > 180 and dist - (dist / math.abs(dist)) * 360 or dist 
        --Y = (Y + dist) %360
        --Y = TargY - delta.x
        --TargY = (Y >= 40 and 40) or (Y <= -55 and -55) or Y

        --Y = Y + (TargY - Y) *0.35
        --print(TargX, TargY, X, Y)

      --  print(math.rad(X))
        --print(math.rad(Y))
    
        --deltax = delta.x
        --print(math.rad(Y))
        --print(math.rad(X))
        if (math.rad(X)) > 0.65 and not(deltax == 0) then
            DX += 2
        elseif (math.rad(X)) < -0.65 and not(deltax == 0) then
            DX -= 2
        end	

        if (math.rad(Y)) > 0.70 then
            DY += 2
        elseif (math.rad(Y)) < -0.70 then
            DY -= 2
        end	
        --print(DX)
        --return TargX, TargY, X, Y
    end
end


function Camera.Update(camera, camera_mode, char, input_object)
    --local TargX, TargY, X, Y = Camera.CalculateDelta(input_object, char)
    camera.CameraType = Enum.CameraType.Scriptable
    game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.LockCenter

    local CamPos,TargetCamPos = camera.CoordinateFrame.p, camera.CoordinateFrame.p 
   -- game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.LockCenter

    if camera_mode == "fly" then
        


        --char.PrimaryPart.Velocity = Vector3.new(0,0,0)
        --char.PrimaryPart.CFrame = CFrame.new(char.PrimaryPart.Position)
        ---char.PrimaryPart.CFrame = CFrame.new(char.PrimaryPart.Position)*CFrame.Angles(math.rad(DX),0,0)
        --char:SetPrimaryPartCFrame(CFrame.new(char.PrimaryPart.Position))
       -- X = X + (TargX - X) *0.35 
        
       -- local dist = TargY - Y
       -- dist = math.abs(dist) > 180 and dist - (dist / math.abs(dist)) * 360 or dist 
       -- Y = (Y + dist *0.20) %360

       -- camera.CFrame = char.PrimaryPart.CFrame*CFrame.new(8,0,16)

        camera.CFrame = char.PrimaryPart.CFrame*CFrame.new(0,0,5)--*CFrame.Angles(0,math.rad(Y),0)
        --camera.CoordinateFrame = CFrame.new(char.PrimaryPart.Position)*CFrame.Angles(math.rad(DX),0,0)*CFrame.new(4,0,8)
        --camera.CoordinateFrame = camera.CFrame*CFrame.Angles(0, math.rad(DY), 0)
        --camera.CoordinateFrame = CFrame.new(char.PrimaryPart.Position)*CFrame.Angles(0,0,0)*CFrame.Angles(math.rad(X),0,0)*CFrame.Angles(math.rad(DX),0,0)*CFrame.new(4,0,15)
        
    elseif camera_mode == "human" then
        
        char:FindFirstChild("Head").Transparency = 1
        char:FindFirstChild("UpperTorso").Transparency = 1

        CamPos = CamPos + (TargetCamPos - CamPos) *0.28 
        X = X + (TargX - X) *0.35 
        local dist = TargY - Y
        dist = math.abs(dist) > 180 and dist - (dist / math.abs(dist)) * 360 or dist 
        Y = (Y + dist *0.20) %360
        
        camera.CoordinateFrame = CFrame.new(char.PrimaryPart.Position) 
        * CFrame.Angles(0,math.rad(Y),0) * CFrame.new(0,1 + (-math.rad(X)*2),1 + (math.rad(X)*2)) 
        * CFrame.Angles(math.rad(X),0,0)
        * CFrame.new(-1,0,-1.6) -- offset

        char.PrimaryPart.CFrame = CFrame.new(char.PrimaryPart.Position)*CFrame.Angles(0,math.rad(Y),0)
        char:FindFirstChild("UpperTorso"):FindFirstChild("Waist").C0 = CFrame.new(0,0.1,0) * CFrame.Angles(math.rad(X),0,0)
        
    end
end

function Camera.BindMouse()
    game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.LockCenter
end

return Camera