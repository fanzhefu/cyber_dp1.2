/*
https://sid4hack.medium.com/malware-development-part-5-dll-injection-into-the-process-bc7f8b63b45b

*/
#include <windows.h>
#pragma comment (lib, "user32.lib")
BOOL APIENTRY DllMain (HMODULE hModule, DWORD nReason, LPVOID lpReserved) { 
	switch (nReason) {
		case DLL_PROCESS_ATTACH:
		MessageBox( hWnd: NULL, IpText: "Hello, DP1.2 Students!", IpCaption: "Message", uType: MB_OK); 
		break;
		case DLL_PROCESS_DETACH:
		break;
		case DLL_THREAD_ATTACH:
		break;
		case DLL_THREAD_DETACH:
		break;
	}
	return TRUE;

}