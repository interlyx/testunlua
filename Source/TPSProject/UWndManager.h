// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "UObject/NoExportTypes.h"
#include "Engine/StreamableManager.h"
#include "Blueprint//UserWidget.h"
#include "UWndManager.generated.h"

/**
 * 
 */
UCLASS()
class TPSPROJECT_API UUWndManager : public UObject
{
	GENERATED_BODY()

		UFUNCTION()
		static UUWndManager * Get();
		UFUNCTION()
		UUserWidget * OpenWnd(FString idBPWnd);

public:
	FStreamableManager m_streamableManager;
};
