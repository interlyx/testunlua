require "UnLua"

local UnLuaPerformanceTestProxy = Class()

function UnLuaPerformanceTestProxy:TestObjectDelegate(myints,mybool)
	for i = 1, myints:Length() do
		print("myintarray:" .. myints:Get(i))
	end
	print(mybool)
end

function UnLuaPerformanceTestProxy:TestObjectDelegate2(myvector,mybool)
	print(myvector.X)
	print(myvector.Y)
	print(myvector.Z)
	print(mybool)
end

function UnLuaPerformanceTestProxy:TestDelegatePrint(myint,myfloat)
	print("myint:" .. myint)
	print("myfloat:" .. myfloat)
end

function UnLuaPerformanceTestProxy:NativeEvent()
	print("this is lua native event")
	--self.Overridden.NativeEvent(self)--crash
end


function UnLuaPerformanceTestProxy:ImplementationEvent()
	print("this is lua Implementation event")
	self.Overridden.ImplementationEvent(self)
end

function UnLuaPerformanceTestProxy:ReceiveBeginPlay()
	local N = 1000000
	local Multiplier = 1000000000.0 / N
	local RawObject = self.Object

	-- warm up
	self:NOP()


	self:AddToMultiDelegate({self,UnLuaPerformanceTestProxy.TestDelegatePrint})
	self:BroadcastMultiDelegate(100,123.123)
	self:ClearMultiDelegate()

	-- local delegate = self:GetDelegate()
	-- delegate:Execute(345,345.234)
	-- delegate:Execute(111,3456.234)
	-- delegate:Execute(222,3457.234)
	-- delegate:Unbind()

	-- local a = self:GetAAA()
	-- print(a)
	-- self:printA()
	-- a = a + 100
	-- print(a)
	-- self:printA()

	-- -- warm up
	-- for i=1, 1 do
	-- 	self:NOP()
	-- end
	
	RawObject:SetDelegate({self,UnLuaPerformanceTestProxy.TestDelegatePrint},999,999.7765)
	RawObject.TestDelegate:Unbind()


	RawObject.TestDelegate:Bind(self,UnLuaPerformanceTestProxy.TestDelegatePrint)
	RawObject.TestDelegate:Execute(345,345.234)
	RawObject.TestDelegate:Execute(111,3456.234)
	RawObject.TestDelegate:Execute(222,3457.234)
	RawObject.TestDelegate:Unbind()

	local TestStrings = UE4.TArray(UE4.FString)
	for i=1, 10 do
		local str = "str" .. i
		TestStrings:Add(str)
	end
	StartTime = Seconds()
	for i=1, 10 do
		self:ServerUpdateStrings(TestStrings)
	end
	EndTime = Seconds()

	local TestInts = UE4.TArray(int32)
	for i=1, 10 do
		TestInts:Add(i)
	end
	StartTime = Seconds()
	for i=1, 10 do
		self:ServerUpdateInts(TestInts)
	end
	EndTime = Seconds()

	local Objects = UE4.TArray(UE4.UClassObject)
	StartTime = Seconds()
	for i=1, 10 do
		self:GetObjects(Objects)
	end
	print("object lenth:" .. Objects:Length())
	for i=1,Objects:Length() do
		local obj = Objects:Get(i)

		local COM = UE4.FVector(1.1, 1.2, 1.3)
		local strcom = tostring(COM)--ok
		print(strcom)

		local COM2 = UE4.FVector()
		local strcom2 = tostring(COM2)
		--local strcom = tostring(UE4.FVector)--crash
		print(strcom2)

		print("===01")
		obj.mymultidelegate:Add(self,UnLuaPerformanceTestProxy.TestObjectDelegate2)
		print("===02")
		obj.mymultidelegate:Broadcast(COM,true)
		print("===03")
		obj.mymultidelegate:Broadcast(COM,false)--crash
		print("===04")
		obj.mymultidelegate:Broadcast(COM,false)
		print("===05")
		obj.mymultidelegate:Broadcast(COM,false)
		print("===06")
		obj.mymultidelegate:Broadcast(COM,true)
		print("===07")
		obj.mymultidelegate:Broadcast(COM,false)
		print("===08")
		obj.mymultidelegate:Broadcast(COM,false)
		print("===09")
		obj.mymultidelegate:Broadcast(COM,false)
		print("===00")
		obj.mymultidelegate:Clear()

		for i=1,10 do
			print("===1")
			obj.mydelegate:Bind(self,UnLuaPerformanceTestProxy.TestObjectDelegate)
			print("===2")
			obj.mydelegate:Execute(TestInts,true)--循环第二次执行到这里的时候崩溃
			print("===3")
			obj.mydelegate:Execute(TestInts,false)
			print("===4")
			obj.mydelegate:Unbind()
		end


		print("===11")
		obj.mydelegate2:Bind(self,UnLuaPerformanceTestProxy.TestObjectDelegate2)
		print("===22")
		obj.mydelegate2:Execute(COM,true)
		print("===33")
		obj.mydelegate2:Execute(COM,false)
		print("===44")
		obj.mydelegate2:Unbind()

		print(Objects:Get(i).type)
	end
	EndTime = Seconds()
	
	-- local StartTime = Seconds()
	-- for i=1, N do
	-- 	local MeshID = RawObject.MeshID
	-- end
	-- local EndTime = Seconds()
	-- local Message = "read int32 ; " .. tostring((EndTime - StartTime) * Multiplier)

	-- StartTime = Seconds()
	-- for i=1, N do
	-- 	RawObject.MeshID = i
	-- end
	-- EndTime = Seconds()
	-- Message = Message .. "\n" ..  "write int32 ; " .. tostring((EndTime - StartTime) * Multiplier)

	-- StartTime = Seconds()
	-- for i=1, N do
	-- 	local MeshName = RawObject.MeshName
	-- end
	-- EndTime = Seconds()
	-- Message = Message .. "\n" ..  "read FString ; " .. tostring((EndTime - StartTime) * Multiplier)

	-- StartTime = Seconds()
	-- for i=1, N do
	-- 	RawObject.MeshName = "9527"
	-- end
	-- EndTime = Seconds()
	-- Message = Message .. "\n" ..  "write FString ; " .. tostring((EndTime - StartTime) * Multiplier)

	-- StartTime = Seconds()
	-- for i=1, N do
	-- 	local COM = RawObject.COM
	-- end
	-- EndTime = Seconds()
	-- Message = Message .. "\n" ..  "read FVector ; " .. tostring((EndTime - StartTime) * Multiplier)

	-- local COM = UE4.FVector(1.0, 1.0, 1.0)
	-- StartTime = Seconds()
	-- for i=1, N do
	-- 	RawObject.COM = COM
	-- end
	-- EndTime = Seconds()
	-- Message = Message .. "\n" ..  "write FVector ; " .. tostring((EndTime - StartTime) * Multiplier)

	-- StartTime = Seconds()
	-- for i=1, N do
	-- 	local Positions = RawObject.Positions
	-- end
	-- EndTime = Seconds()
	-- Message = Message .. "\n" ..  "read TArray<FVector> ; " .. tostring((EndTime - StartTime) * Multiplier)

	-- local PredictedPositions = UE4.TArray(UE4.FVector)
	-- StartTime = Seconds()
	-- for i=1, N do
	-- 	RawObject.PredictedPositions = PredictedPositions
	-- end
	-- EndTime = Seconds()
	-- Message = Message .. "\n" ..  "write TArray<FVector> ; " .. tostring((EndTime - StartTime) * Multiplier)

	-- StartTime = Seconds()
	-- for i=1, N do
	-- 	self:NOP()
	-- end
	-- EndTime = Seconds()
	-- Message = Message .. "\n" ..  "void NOP() ; " .. tostring((EndTime - StartTime) * Multiplier)

	-- StartTime = Seconds()
	-- for i=1, N do
	-- 	self:Simulate(0.0167)
	-- end
	-- EndTime = Seconds()
	-- Message = Message .. "\n" .. "void Simulate(float) ; "..tostring((EndTime - StartTime) * Multiplier)

	-- StartTime = Seconds()
	-- for i=1, N do
	-- 	local MeshID = self:GetMeshID()
	-- end
	-- EndTime = Seconds()
	-- Message = Message .. "\n" .. "int32 GetMeshID() const ; "..tostring((EndTime - StartTime) * Multiplier)

	-- StartTime = Seconds()
	-- for i=1, N do
	-- 	local MeshName = self:GetMeshName()
	-- end
	-- EndTime = Seconds()
	-- Message = Message .. "\n" .. "const FString& GetMeshName() const ; "..tostring((EndTime - StartTime) * Multiplier)

	-- StartTime = Seconds()
	-- for i=1, N do
	-- 	self:GetCOM(COM)
	-- 	--local COMCopy = self:GetCOM(COM)
	-- end
	-- EndTime = Seconds()
	-- Message = Message .. "\n" .. "const FVector& GetCOM() const ; "..tostring((EndTime - StartTime) * Multiplier)

	-- StartTime = Seconds()
	-- for i=1, N do
	-- 	local NewMeshID = self:UpdateMeshID(1024)
	-- end
	-- EndTime = Seconds()
	-- Message = Message .. "\n" .. "int32 UpdateMeshID(int32) ; "..tostring((EndTime - StartTime) * Multiplier)

	-- StartTime = Seconds()
	-- for i=1, N do
	-- 	local NewMeshName = self:UpdateMeshName("1024")
	-- end
	-- EndTime = Seconds()
	-- Message = Message .. "\n" .. "FString UpdateMeshName(const FString&) ; "..tostring((EndTime - StartTime) * Multiplier)

	-- local Origin = UE4.FVector(1.0, 1.0, 1.0)
	-- local Direction = UE4.FVector(1.0, 0.0, 0.0)
	-- StartTime = Seconds()
	-- for i=1, N do
	-- 	local bHit = self:Raycast(Origin, Direction)
	-- end
	-- EndTime = Seconds()
	-- Message = Message .. "\n" .. "bool Raycast(const FVector&, const FVector&) const ; "..tostring((EndTime - StartTime) * Multiplier)

	-- local Indices = UE4.TArray(0)
	-- StartTime = Seconds()
	-- for i=1, N do
	-- 	self:GetIndices(Indices)
	-- end
	-- EndTime = Seconds()
	-- Message = Message .. "\n" .. "void GetIndices(TArray<int32>&) const ; "..tostring((EndTime - StartTime) * Multiplier)

	-- for i=1, 1024 do
	-- 	Indices:Add(i)
	-- end
	-- StartTime = Seconds()
	-- for i=1, N do
	-- 	self:GetIndices(Indices)
	-- end
	-- EndTime = Seconds()
	-- Message = Message .. "\n" .. "void GetIndices(TArray<int32>&) const with 1024 items ; "..tostring((EndTime - StartTime) * Multiplier)

	-- StartTime = Seconds()
	-- for i=1, N do
	-- 	self:UpdateIndices(Indices)
	-- end
	-- EndTime = Seconds()
	-- Message = Message .. "\n" .. "void UpdateIndices(const TArray<int32>&) ; "..tostring((EndTime - StartTime) * Multiplier)

	-- local Positions = UE4.TArray(UE4.FVector)
	-- StartTime = Seconds()
	-- for i=1, N do
	-- 	self:GetPositions(Positions)
	-- end
	-- EndTime = Seconds()
	-- Message = Message .. "\n" .. "void GetPositions(TArray<FVector>&) const ; "..tostring((EndTime - StartTime) * Multiplier)

	-- for i=1, 1024 do
	-- 	Positions:Add(UE4.FVector(i, i, i))
	-- end
	-- StartTime = Seconds()
	-- for i=1, N do
	-- 	self:GetPositions(Positions)
	-- end
	-- EndTime = Seconds()
	-- Message = Message .. "\n" .. "void GetPositions(TArray<FVector>&) const with 1024 items ; "..tostring((EndTime - StartTime) * Multiplier)

	-- StartTime = Seconds()
	-- for i=1, N do
	-- 	self:UpdatePositions(Positions)
	-- end
	-- EndTime = Seconds()
	-- Message = Message .. "\n" .. "void UpdatePositions(const TArray<FVector>&) ; "..tostring((EndTime - StartTime) * Multiplier)

	-- StartTime = Seconds()
	-- for i=1, N do
	-- 	self:GetPredictedPositions(PredictedPositions)
	-- end
	-- EndTime = Seconds()
	-- Message = Message .. "\n" .. "const TArray<FVector>& GetPredictedPositions() const ; "..tostring((EndTime - StartTime) * Multiplier)

	-- StartTime = Seconds()
	-- for i=1, N do
	-- 	local ID, Name, bResult = self:GetMeshInfo(0, "", COM, Indices, Positions, PredictedPositions)
	-- end
	-- EndTime = Seconds()
	-- Message = Message .. "\n" .. "bool GetMeshInfo(int32&, FString&, FVector&, TArray<int32>&, TArray<FVector>&, TArray<FVector>&) const ; "..tostring((EndTime - StartTime) * Multiplier)

	-- StartTime = Seconds()
	-- for i=1, N do
	-- 	local HitResult = UE4.FHitResult()
	-- end
	-- EndTime = Seconds()
	-- Message = Message .. "\n" .. "FHitResult() ; "..tostring((EndTime - StartTime) * Multiplier)

	-- LogPerformanceData(Message)
end

return UnLuaPerformanceTestProxy
