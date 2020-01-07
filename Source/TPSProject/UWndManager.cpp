// Fill out your copyright notice in the Description page of Project Settings.


#include "UWndManager.h"
#include "Engine/World.h"


UUWndManager * UUWndManager::Get()
{
	static UUWndManager * mgr = NewObject<UUWndManager>(GWorld);
	return mgr;
}

UUserWidget * UUWndManager::OpenWnd(FString idBPWnd)
{

	UObject * pObj = m_streamableManager.LoadSynchronous(idBPWnd);
	UClass * pClass = Cast<UClass>(pObj);

	UUserWidget * pWnd = CreateWidget<UUserWidget>(GWorld.GetReference(),pClass);

	return pWnd;
}
