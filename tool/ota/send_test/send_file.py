import socket
import os
import time

file_name = "beken7251.rbl"
file_size = str(os.path.split(file_name))
# fname1, fname2 = os.path.split(file_name)

client_addr = ('192.168.0.1', 8089)
f = open(file_name, 'rb')
count = 0
flag = 1

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# setup connect
s.connect(client_addr)

while True:
    if count == 0:
        print("file_size is ", file_size.encode())
        # s.send(file_size.encode())
        start = time.time()
        # # s.recv(1024)
        # s.send(fname2.encode())
        # s.send(b"begin")
    for line in f:
        s.send(line)
        print('sending...')
        # time.sleep(0.001)
    # s.send(b'end')
    break

s.close()
end = time.time()
print('cost' + str(round(end - start, 2)) + 's')