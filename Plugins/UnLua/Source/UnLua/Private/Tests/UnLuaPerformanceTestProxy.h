// Tencent is pleased to support the open source community by making UnLua available.
// 
// Copyright (C) 2019 THL A29 Limited, a Tencent company. All rights reserved.
//
// Licensed under the MIT License (the "License"); 
// you may not use this file except in compliance with the License. You may obtain a copy of the License at
//
// http://opensource.org/licenses/MIT
//
// Unless required by applicable law or agreed to in writing, 
// software distributed under the License is distributed on an "AS IS" BASIS, 
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
// See the License for the specific language governing permissions and limitations under the License.

#pragma once

#include "GameFramework/Actor.h"
#include "UnLuaInterface.h"
#include "DelegateCombinations.h"
#include "UnLuaPerformanceTestProxy.generated.h"


UCLASS()
class UClassObject : public UObject
{
	GENERATED_BODY()

public:
	DECLARE_DYNAMIC_DELEGATE_TwoParams(FClassObjectDelegate, const TArray<int32> &, myints, bool, mybool);
	DECLARE_DYNAMIC_DELEGATE_TwoParams(FClassObjectDelegate2, const FVector & ,myvector, bool, mybool);
// 	DECLARE_DYNAMIC_MULTICAST_DELEGATE_TwoParams(FClassObjectMultiDelegate, const TArray<int32> &, myints)
	DECLARE_DYNAMIC_MULTICAST_DELEGATE_TwoParams(FClassObjectMultiDelegate, const FVector &, myvector, bool, mybool);

	UPROPERTY()
	int32 type = 0;

	UPROPERTY()
	FClassObjectDelegate mydelegate;

	UPROPERTY()
	FClassObjectDelegate2 mydelegate2;

	UPROPERTY()
	FClassObjectMultiDelegate mymultidelegate;

};


UCLASS()
class AUnLuaPerformanceTestProxy : public AActor, public IUnLuaInterface
{
    GENERATED_BODY()

public:

	DECLARE_DYNAMIC_DELEGATE_TwoParams(FUnLuaPerformanceTestDelegate, int32, myint, float, myfloat);
	DECLARE_DYNAMIC_MULTICAST_DELEGATE_TwoParams(FUnLuaPerformanceTestMutilDelegate, int32, myint, float, myfloat);

	UFUNCTION(BlueprintPure)
		FUnLuaPerformanceTestDelegate & GetDelegate() { return TestDelegate; };

	UFUNCTION(BlueprintCallable)
		void AddToMultiDelegate(const FUnLuaPerformanceTestDelegate & InDelegate) { TestMultiDelegate.Add(InDelegate); };

	UFUNCTION(BlueprintCallable)
		void BroadcastMultiDelegate(int32 myint, float myfloat) { TestMultiDelegate.Broadcast(myint, myfloat); };

	UFUNCTION(BlueprintCallable)
		void ClearMultiDelegate() { TestMultiDelegate.Clear(); };

	UFUNCTION(BlueprintPure)
		int & GetAAA() { return a; };

	int a = 5;

    UFUNCTION(BlueprintCallable)
    void NOP();

    UFUNCTION(BlueprintCallable)
    void Simulate(float DeltaTime);

    UFUNCTION(BlueprintCallable)
    int32 GetMeshID() const;

    UFUNCTION(BlueprintCallable)
    const FString& GetMeshName() const;

    UFUNCTION(BlueprintCallable)
    const FVector& GetCOM() const;

    UFUNCTION(BlueprintCallable)
    int32 UpdateMeshID(int32 NewID);

    UFUNCTION(BlueprintCallable)
    FString UpdateMeshName(const FString &NewName);

    UFUNCTION(BlueprintCallable)
    bool Raycast(const FVector &Origin, const FVector &Direction) const;

    UFUNCTION(BlueprintCallable)
    void GetIndices(TArray<int32> &OutIndices) const;

    UFUNCTION(BlueprintCallable)
    void UpdateIndices(const TArray<int32> &NewIndices);

    UFUNCTION(BlueprintCallable)
    void GetPositions(TArray<FVector> &OutPositions) const;

    UFUNCTION(BlueprintCallable)
    void UpdatePositions(const TArray<FVector> &NewPositions);

    UFUNCTION(BlueprintCallable)
    const TArray<FVector>& GetPredictedPositions() const;

	UFUNCTION(BlueprintCallable)
	const TArray<UClassObject*>& GetObjects() const;

	UFUNCTION(BlueprintCallable,Server,Reliable)
	void ServerUpdateStrings(const TArray<FString> & NewStrings);

	UFUNCTION(BlueprintCallable, Server, Reliable)
	void ServerUpdateInts(const TArray<int32> & newarray);

    UFUNCTION(BlueprintCallable)
    bool GetMeshInfo(int32 &OutMeshID, FString &OutMeshName, FVector &OutCOM, TArray<int32> &OutIndices, TArray<FVector> &OutPositions, TArray<FVector> &OutPredictedPositions) const;

    virtual FString GetModuleName_Implementation() const override
    {
        return TEXT("UnLuaPerformanceTestProxy");
    }

	UFUNCTION(BlueprintNativeEvent)
		void NativeEvent();

	UFUNCTION(BlueprintImplementableEvent)
		void ImplementationEvent();

	UFUNCTION(BlueprintCallable)
	void SetDelegate(FUnLuaPerformanceTestDelegate delegate, int myint, float myfloat);

	void testBindFunc(int32 myint, float myfloat);

	UFUNCTION(BlueprintCallable)
	void printA();

private:
    UPROPERTY()
    int32 MeshID;

    UPROPERTY()
    FString MeshName;

    UPROPERTY()
    FVector COM;

    UPROPERTY()
    TArray<int32> Indices;

    UPROPERTY()
    TArray<FVector> Positions;

    UPROPERTY()
    TArray<FVector> PredictedPositions;

	UPROPERTY()
	TArray<UClassObject *> Objects;

	UPROPERTY()
	FUnLuaPerformanceTestDelegate TestDelegate;

	FUnLuaPerformanceTestMutilDelegate TestMultiDelegate;
};
