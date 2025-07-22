Learning and Teaching only.  

pe tools:  
file, strings, floss, die(detect it easy)  
pebear, pestudio, peid, cffexplorer, dependency walker  

######## Set up VC Code + MinGW ########  
1. Install Visual Studio Code.  
(https://code.visualstudio.com/download)  
Install the C/C++ extension for VS Code. You can install the C/C++ extension by searching for 'C++' in the Extensions view (Ctrl+Shift+X).  

2. Installing the MinGW-w64 toolchain  
(https://www.msys2.org/)  
install to C:\msys64, check "Run MSYS2 now"  
in the terminal run:  
pacman -S --needed base-devel mingw-w64-ucrt-x86_64-toolchain  

3. Edit environment variables for your account.  
In your User variables, select the Path variable and then select Edit.  
Select New and add the MinGW-w64 destination folder you recorded during the installation process to the list. If you used the default settings above, then this will be the path:  C:\msys64\ucrt64\bin.  

4. Check your MinGW installation  
gcc --version  
g++ --version  
gdb --version  
<ref: https://code.visualstudio.com/docs/cpp/config-mingw>  

======== minimal exe ========  
cl.exe /nologo /Ox /MT /W0 /GS- /DNDEBUG /Tcsimple.cpp /link /OUT:simple.exe /SUBSYSTEM:CONSOLE /MACHINE:x64
🧵 Compiler Flags  
- /nologo: Suppresses the startup banner and informational messages.
- /Ox: Enables maximum optimization for speed.
- /MT: Links the multithreaded, static version of the runtime library (libcmt.lib).
- /W0: Disables all warning messages.
- /GS-: Disables buffer security checks (stack buffer overrun detection).
- /DNDEBUG: Defines NDEBUG, disabling assert() macros.
- /Tc: Treats the input file as a C source file (not C++).
🔗 Linker Flags  
- /link: Indicates that the following options are for the linker.
- /OUT:simple.exe: Specifies the output executable name.
- /SUBSYSTEM:CONSOLE: Targets a console application.
- /MACHINE:x64: Builds for 64-bit architecture.<br>  
🧪 Result  
This command produces simple.exe, a fast, lightweight, statically linked console app with no debug info or runtime checks—ideal for performance-critical or embedded use cases.
Want to add /NODEFAULTLIB to strip even more or explore /LTCG for link-time code generation?

g++ -s -ffunction-sections -fdata-sections -Wno-write-strings \
    -fno-exceptions -fmerge-all-constants \
    -static-libstdc++ -static-libgcc \
    -o myapp myapp.cpp<br>
🧵 Optimization & Size Reduction  
- -s: Strips symbol information from the output binary, reducing size.
- -ffunction-sections and -fdata-sections: Places each function or data item in its own section. Useful when combined with --gc-sections during linking to remove unused code.
- -fmerge-all-constants: Merges identical constants across translation units to save space.
🚫 Exception & Warning Control  
- -fno-exceptions: Disables C++ exception handling. Speeds up execution and reduces binary size, but you lose try/catch functionality.
- -Wno-write-strings: Suppresses warnings about converting string literals to char*. Handy for legacy code, but use with caution.  
📦 Static Linking  
- -static-libstdc++: Statically links the C++ standard library.
- -static-libgcc: Statically links the GCC runtime library.
