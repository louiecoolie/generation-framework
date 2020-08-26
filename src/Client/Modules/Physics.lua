local Physics = {}

local animal_index = 0
local animal_behavior_duration = 10
local turn = nil
local walk = nil


local move_speed = 0
local float_speed = 0
local turn_angle = 0
local tilt_angle = 0
local roll_angle = 0

local left_turn = false
local right_turn = false
local left_roll = false
local right_roll = false
local forward = false
local backward = false
local move = false
local float = false

local tilt_forward = false
local tilt_backward = false


local sensitivity = 12
local Smoothness = .19
local deltax
local X = 0
local TargX = 0
local Y = 0
local TargY = 0
local DX = 0
local DY = 0

function Physics.CalculateDelta(input_object, physics_gyro)
    --print(input_object)
    --TargY = char.PrimaryPart.Orientation.Y
   -- print(input_object.Delta)

    if input_object.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input_object.delta
        --print(delta.y)
        local y = DY - (delta.y/10)

        DY = (y >= 2 and 2) or (y <= -2 and -2) or y 

        if DY > 1 or DY < -1 then
            Y = Y + (DY - Y) *0.35 
        elseif DY < 1 and DY > -1 then
            Y = 0
        end
       -- Y = Y - delta.y
        print(DY, math.rad(Y), Y)
        if y > sensitivity then
            print("Going up")
           
          --  tilt_forward = true
          --  tilt_backward = false
            --physics_gyro.CFrame = physics_gyro.CFrame * CFrame.Angles(math.rad(DX),0,0)
        elseif y < -sensitivity then
            print("Going down")
         
          --  tilt_backward = true
          --  tilt_forward = false
            --physics_gyro.CFrame = physics_gyro.CFrame * CFrame.Angles(math.rad(DX),0,0)
        else
            print("no change")
          --  tilt_backward = false
          --  tilt_forward = false
            --physics_gyro.CFrame = physics_gyro.CFrame * CFrame.Angles(math.rad(DX),0,0)
        end
    end
end








function Physics.IntrepretInput(action, input_state)
    if action == "left" then
        if input_state == Enum.UserInputState.Begin then
            left_turn = true
        else
            left_turn = false
            turn_angle = 0
        end
    elseif action == "right" then
        if input_state == Enum.UserInputState.Begin then
            right_turn = true
        else
            right_turn = false
            turn_angle = 0
        end
    elseif action == "forward" then
        if input_state == Enum.UserInputState.Begin then
            forward = true
            print("Forward")
        else
            forward = false
            tilt_angle = 0
        end
    elseif action == "backward" then
        if input_state == Enum.UserInputState.Begin then
            backward = true
        else
            backward = false
            tilt_angle = 0
        end

    elseif action == "roll_left" then
        if input_state == Enum.UserInputState.Begin then
            left_roll = true
        else
            left_roll = false
            roll_angle = 0
        end
    elseif action == "roll_right" then
        if input_state == Enum.UserInputState.Begin then
            right_roll = true
        else
            right_roll = false
            roll_angle = 0
        end
    elseif action == "move" then
        if input_state == Enum.UserInputState.Begin then
            move = true
        else
            move = false
            --roll_angle = 0
        end
    elseif action == "float" then
        if input_state == Enum.UserInputState.Begin then
            float = true
        else
            float = false
            --roll_angle = 0
        end
    end
end


function Physics.Control(physics_body, physics_gyro)
    if right_turn then
        turn_angle -= .01
        physics_body.CFrame = physics_body.CFrame * CFrame.Angles(0, math.rad(turn_angle),0)
        physics_gyro.CFrame = physics_body.CFrame
    end

    if left_turn then
        turn_angle += .01
        physics_body.CFrame = physics_body.CFrame * CFrame.Angles(0, math.rad(turn_angle),0)
        physics_gyro.CFrame = physics_body.CFrame
    end

    if forward then
        move_speed = ( move_speed >= 10 and 10 ) or (move_speed + 1)
        physics_body.Velocity = physics_body.CFrame.LookVector * move_speed
        physics_gyro.CFrame = physics_body.CFrame
    else
        if move_speed > 0 then
            move_speed -= 1
            physics_body.Velocity = physics_body.CFrame.LookVector * move_speed
            physics_gyro.CFrame = physics_body.CFrame
        end
    end

    if tilt_forward then
        print("tilt forward")
        tilt_angle += 0.25
        physics_body.CFrame = physics_body.CFrame * CFrame.Angles(math.rad(tilt_angle), 0, 0)
        physics_gyro.CFrame = physics_body.CFrame
    end

    if tilt_backward then
        print("tilt backward")
        tilt_angle -= 0.25
        physics_body.CFrame = physics_body.CFrame * CFrame.Angles(math.rad(tilt_angle), 0,0)
        physics_gyro.CFrame = physics_body.CFrame
    end

    physics_body.CFrame = physics_body.CFrame * CFrame.Angles(math.rad(Y),0,0)
    physics_gyro.CFrame = physics_body.CFrame

end

function Physics.Update(physics_body, physics_gyro)
    --physics_body.Velocity = Vector3.new(0,0,0)
    if float then
        float_speed += 1
        physics_body.Velocity = physics_body.CFrame.UpVector * move_speed
        physics_gyro.CFrame = physics_body.CFrame
        --physics_body.Position = Vector3.new(physics_body.Position.X, physics_body.Position.Y + float_speed, physics_body.Position.Z)
    else
        if float_speed > 0 then
            float_speed -= 1
            physics_body.Velocity = physics_body.CFrame.UpVector * move_speed
            physics_gyro.CFrame = physics_body.CFrame
           -- physics_body.Position = Vector3.new(physics_body.Position.X, physics_body.Position.Y + float_speed, physics_body.Position.Z)
        end
    end

    if move then
        move_speed += 1
        physics_body.Velocity = physics_body.CFrame.LookVector * move_speed
        physics_gyro.CFrame = physics_body.CFrame
    else
        if move_speed > 0 then
            move_speed -= 1
            physics_body.Velocity = physics_body.CFrame.LookVector * move_speed
            physics_gyro.CFrame = physics_body.CFrame
        end
    end

    if right_turn then
        turn_angle -= .01
        physics_body.CFrame = physics_body.CFrame * CFrame.Angles(0, math.rad(turn_angle),0)
        physics_gyro.CFrame = physics_body.CFrame
    end
    
    if left_turn then
        turn_angle += .01
        physics_body.CFrame = physics_body.CFrame * CFrame.Angles(0, math.rad(turn_angle),0)
        physics_gyro.CFrame = physics_body.CFrame
    end

    if forward then
        tilt_angle += .01
        physics_body.CFrame = physics_body.CFrame * CFrame.Angles(math.rad(tilt_angle), 0, 0)
        physics_gyro.CFrame = physics_body.CFrame
    end

    if backward then
        tilt_angle -= .01
        physics_body.CFrame = physics_body.CFrame * CFrame.Angles(math.rad(tilt_angle), 0,0)
        physics_gyro.CFrame = physics_body.CFrame
    end

    if right_roll then
        roll_angle -= 0.01
        physics_body.CFrame = physics_body.CFrame * CFrame.Angles(0, 0,math.rad(roll_angle))
        physics_gyro.CFrame = physics_body.CFrame
    end

    if left_roll then
        roll_angle += 0.01
        physics_body.CFrame = physics_body.CFrame * CFrame.Angles(0,0,math.rad(roll_angle))
        physics_gyro.CFrame = physics_body.CFrame
    end
    
    
    physics_gyro.CFrame = physics_body.CFrame
    --print(physics_gyro)
   -- print(physics_body.CFrame)
end

function Physics.UpdateAnimals(animal_list, player_body)

    --print(animal_list[animal_index])
   for _, object in pairs(animal_list) do
      local animal = object.Value
      
      local animal_distance = (player_body.Position - animal.PrimaryPart.Position).Magnitude
      local animal_body = animal.PrimaryPart
      local update_cframe = animal_body.CFrame * CFrame.Angles(-math.rad(animal_body.Orientation.X),0,-math.rad(animal_body.Orientation.Z))
      animal:SetPrimaryPartCFrame(update_cframe)
      --print(animal_distance)
      if animal_distance < 10 then
            local first_cframe = CFrame.new(animal_body.CFrame.Position, player_body.Position)
            --print(player_body.Orientation)
            --local second_cframe = CFrame.new(player_body.Position,animal_body.CFrame.Position)
            local rotated_cframe = animal_body.CFrame * CFrame.Angles(-math.rad(animal_body.Orientation.X),math.rad(player_body.Orientation.Y-animal_body.Orientation.Y),-math.rad(animal_body.Orientation.Z))
            animal:SetPrimaryPartCFrame(rotated_cframe)
            animal_body.Velocity = animal_body.Velocity + (-first_cframe.LookVector * 20)
      else
            local turn_chance = math.random(0,1000)
            local walk_chance = math.random(0,1000)

            local turn_cframe = animal_body.CFrame * CFrame.Angles(-math.rad(animal_body.Orientation.X),math.rad(1),-math.rad(animal_body.Orientation.Z))
            if turn_chance > 999 then
                --print("turn")
                if turn == false then
                    turn = true
                else
                    turn = false 
                end
                
                
            end

            if walk_chance > 99 then
                if walk == true then
                    walk = false
                else
                    walk = true
                end
                
            end


            if walk then
                animal_body.Velocity = animal_body.Velocity + (animal_body.CFrame.LookVector * 2)
            end

            if turn then
                animal:SetPrimaryPartCFrame(turn_cframe)
            end


      end

   end
end

function Physics.AnimalBehavior(behavior, animal, player_body)
    local animal_body = animal.PrimaryPart
    
    if behavior == "Run" then
        local first_cframe = CFrame.new(animal_body.CFrame.Position, player_body.Position)
        
        local rotated_cframe = animal_body.CFrame * CFrame.Angles(-math.rad(animal_body.Orientation.X),math.rad(player_body.Orientation.Y-animal_body.Orientation.Y),-math.rad(animal_body.Orientation.Z))
        animal:SetPrimaryPartCFrame(rotated_cframe)
        animal_body.Velocity = -first_cframe.LookVector * 20
    end
end


return Physics