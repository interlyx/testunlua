require "UnLua"

local BP_PlayerController_C = Class()

--function BP_PlayerController_C:UserConstructionScript()
--end

function BP_PlayerController_C:ReceiveBeginPlay()
	self.ForwardVec = UE4.FVector()
	self.RightVec = UE4.FVector()
	self.ControlRot = UE4.FRotator()

	self.BaseTurnRate = 45.0
	self.BaseLookUpRate = 45.0

	-- local Widget = UE4.UWidgetBlueprintLibrary.Create(self, UE4.UClass.Load("/Game/Core/UI/UMG_Main"))
	-- Widget:AddToViewport()

	self.Overridden.ReceiveBeginPlay(self)
end

function BP_PlayerController_C:Turn(AxisValue)
	--print("=============Turn")
	self:AddYawInput(AxisValue)
end

function BP_PlayerController_C:TurnRate(AxisValue)
	local DeltaSeconds = UE4.UGameplayStatics.GetWorldDeltaSeconds(self)
	local Value = AxisValue * DeltaSeconds * self.BaseTurnRate
	self:AddYawInput(Value)
end

function BP_PlayerController_C:LookUp(AxisValue)
	--print("=============LookUp")
	self:AddPitchInput(AxisValue)
end

function BP_PlayerController_C:LookUpRate(AxisValue)
	--print("=============LookUpRate")
	local DeltaSeconds = UE4.UGameplayStatics.GetWorldDeltaSeconds(self)
	local Value = AxisValue * DeltaSeconds * self.BaseLookUpRate
	self:AddPitchInput(Value)
end

function BP_PlayerController_C:MoveForward(AxisValue)
	--print("=============MoveForward")
	-- self.bpintarray:Add(1)
	-- self:BPTestFunc()
	if self.Pawn then
		local Rotation = self:GetControlRotation(self.ControlRot)
		Rotation:Set(0, Rotation.Yaw, 0)
		local Direction = Rotation:ToVector(self.ForwardVec)		-- Rotation:GetForwardVector()
		self.Pawn:AddMovementInput(Direction, AxisValue)
	end
end

function BP_PlayerController_C:MoveRight(AxisValue)
	--print("=============MoveRight")
	-- self.bpintarray:Add(2)
	-- self:BPTestFunc()
	if self.Pawn then
		local Rotation = self:GetControlRotation(self.ControlRot)
		Rotation:Set(0, Rotation.Yaw, 0)
		local Direction = Rotation:GetRightVector(self.RightVec)
		self.Pawn:AddMovementInput(Direction, AxisValue)
	end
end

function BP_PlayerController_C:Fire_Pressed()
	-- print("=============start test string array")
	-- local array = UE4.TArray(FString)
	-- array:Add("FString1")
	-- array:Add("FString2")
	-- array:Add("FString3")
	-- array:Add("FString4")
	-- self:TestArrayString(array)--crash TestArrayString是个run in server的bp event

	print("=============start test int32 array")
	local array = UE4.TArray(int32)
	array:Add(100)
	array:Add(200)
	array:Add(300)
	array:Add(400)
	self:TestArrayInt(array)--crash

	-- if self.Pawn then
	-- 	UE4.UBPI_Interfaces_C.StartFire(self.Pawn)
	-- else
	-- 	UE4.UKismetSystemLibrary.ExecuteConsoleCommand(self, "RestartLevel")
	-- end
end

function BP_PlayerController_C:Fire_Released()
	UE4.UBPI_Interfaces_C.StopFire(self.Pawn)
end

function BP_PlayerController_C:Aim_Pressed()
	print("=============start test string array trigger from bp")
	
	if self.bpintarray:Length() == 0 then
		self.bpintarray:Add(100)
		self.bpintarray:Add(200)
		self.bpintarray:Add(300)
		self.bpintarray:Add(400)
	end
	self:BPTestFunc()--ok


	
	UE4.UBPI_Interfaces_C.UpdateAiming(self.Pawn, true)
end

function BP_PlayerController_C:Aim_Released()
	UE4.UBPI_Interfaces_C.UpdateAiming(self.Pawn, false)
end

return BP_PlayerController_C
