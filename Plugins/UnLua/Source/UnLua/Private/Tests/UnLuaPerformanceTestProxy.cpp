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

#include "UnLuaPerformanceTestProxy.h"
#include "UnLuaBase.h"


void AUnLuaPerformanceTestProxy::NativeEvent_Implementation()
{
	UE_LOG(LogUnLua, Log, TEXT("NativeEvent:%s"), ANSI_TO_TCHAR(__FUNCTION__));
}

void AUnLuaPerformanceTestProxy::printA()
{
	UE_LOG(LogUnLua, Log, TEXT("printA:%d"), a );
	a++;
}
void AUnLuaPerformanceTestProxy::testBindFunc(int32 myint, float myfloat)
{
	UE_LOG(LogUnLua, Log, TEXT("testBindFunc:%d,%f"), myint, myfloat);
}

void AUnLuaPerformanceTestProxy::NOP()
{

	UClassObject * OBJ = NewObject<UClassObject>();
	OBJ->type = 1;
	Objects.Push(OBJ);
	UClassObject * OBJ2 = NewObject<UClassObject>();
	OBJ2->type = 22;
	Objects.Push(OBJ2);
	UClassObject * OBJ3 = NewObject<UClassObject>();
	OBJ3->type = 333;
	Objects.Push(OBJ3);

	NativeEvent();
	ImplementationEvent();

	TestDelegate.BindUFunction(this, GET_FUNCTION_NAME_CHECKED(AUnLuaPerformanceTestProxy, testBindFunc));
}

void AUnLuaPerformanceTestProxy::Simulate(float DeltaTime)
{
}

int32 AUnLuaPerformanceTestProxy::GetMeshID() const
{
    return MeshID;
}

const FString& AUnLuaPerformanceTestProxy::GetMeshName() const
{
    return MeshName;
}

const FVector& AUnLuaPerformanceTestProxy::GetCOM() const
{
    return COM;
}

int32 AUnLuaPerformanceTestProxy::UpdateMeshID(int32 NewID)
{
    return NewID;
}

FString AUnLuaPerformanceTestProxy::UpdateMeshName(const FString &NewName)
{
    return NewName;
}

bool AUnLuaPerformanceTestProxy::Raycast(const FVector &Origin, const FVector &Direction) const
{
    return true;
}

void AUnLuaPerformanceTestProxy::GetIndices(TArray<int32> &OutIndices) const
{
}

void AUnLuaPerformanceTestProxy::UpdateIndices(const TArray<int32> &NewIndices)
{
}

void AUnLuaPerformanceTestProxy::GetPositions(TArray<FVector> &OutPositions) const
{
}

void AUnLuaPerformanceTestProxy::UpdatePositions(const TArray<FVector> &NewPositions)
{
}

const TArray<FVector>& AUnLuaPerformanceTestProxy::GetPredictedPositions() const
{
    return PredictedPositions;
}

const TArray<UClassObject*>& AUnLuaPerformanceTestProxy::GetObjects() const
{
	return Objects;
}


void AUnLuaPerformanceTestProxy::ServerUpdateStrings_Implementation(const TArray<FString> & NewStrings)
{
	for (int i = 0; i < NewStrings.Num(); i++)
	{
		UE_LOG(LogUnLua, Log, TEXT("function:%s string:%s") , ANSI_TO_TCHAR(__FUNCTION__), *NewStrings[i]);
	}
}

void AUnLuaPerformanceTestProxy::ServerUpdateInts_Implementation(const TArray<int32> & newarray)
{
	for (int i=0;i<newarray.Num();i++)
	{
		FString str = FString::FromInt(newarray[i]);
		UE_LOG(LogUnLua, Log, TEXT("function:%s int:%s"), ANSI_TO_TCHAR(__FUNCTION__), *str);
	}
}

bool AUnLuaPerformanceTestProxy::GetMeshInfo(int32 &OutMeshID, FString &OutMeshName, FVector &OutCOM, TArray<int32> &OutIndices, TArray<FVector> &OutPositions, TArray<FVector> &OutPredictedPositions) const
{
    return true;
}
void AUnLuaPerformanceTestProxy::SetDelegate(FUnLuaPerformanceTestDelegate delegate, int myint, float myfloat)
{
	if (delegate.IsBound())
	{
		TestDelegate = delegate;
		TestDelegate.ExecuteIfBound(myint, myfloat);
	}

}

//#if UE_BUILD_TEST

#include "Misc/DateTime.h"
#include "Misc/FileHelper.h"
#include "UnLuaEx.h"

bool LogPerformanceData(const FString &Message)
{
    FString ProfilingFilePath = FString::Printf(TEXT("%sProfiling/UnLua-Performance-%s.csv"), *FPaths::ConvertRelativePathToFull(FPaths::ProjectSavedDir()), *FDateTime::Now().ToString());
    bool bSuccess = FFileHelper::SaveStringToFile(Message, *ProfilingFilePath);
    return bSuccess;
}

EXPORT_FUNCTION(bool, LogPerformanceData, const FString&)

EXPORT_FUNCTION_EX(Seconds, double, FPlatformTime::Seconds)

//#endif
