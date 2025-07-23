/*
https://sid4hack.medium.com/malware-development-part-3-669bebef79c4
C:\mal_pe>cl /EHsc /W4 mal_dev_00.cpp
Microsoft (R) C/C++ Optimizing Compiler Version 19.44.35211 for x64
Copyright (C) Microsoft Corporation.  All rights reserved.

mal_dev_00.cpp
Microsoft (R) Incremental Linker Version 14.44.35211.0
Copyright (C) Microsoft Corporation.  All rights reserved.

/out:mal_dev_00.exe
mal_dev_00.obj

C:\mal_pe>g++ mal_dev_00.cpp

C:\mal_pe>
*/
#include <iostream>
#include <windows.h>
#include <process.h>
int main() {
	
	// Create process information structure
	PROCESS_INFORMATION pi;
	// Create startup information structure
	STARTUPINFO si;
	
	ZeroMemory(&si, sizeof(si));
	si.cb= sizeof(si);
	
	// Specify the command to be executed (e.g., Notepad)
	TCHAR command[] = TEXT("notepad.exe");
	
	// Create a new process
	if (!CreateProcess(NULL, command, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi)) { 
		std::cerr << "Failed to create process. Error code: " << GetLastError() << std::endl;
		return 1;
	}
	std::cout << "Process created successfully!" << std::endl;
	

	// Wait for the process to finish executing 
	WaitForSingleObject(pi.hProcess, INFINITE);

	// close process and thread handles
	CloseHandle(pi.hProcess);
	CloseHandle(pi.hThread);
	return 0;
}


