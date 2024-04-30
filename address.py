import os
import subprocess
import requests
import json


def scan_ports(ip,message):
    # 执行 RustScan 命令并捕获输出
    result = subprocess.run(['rustscan', '-a', ip, '-r', '10000-20000','--scripts','none'], capture_output=True, text=True)
    # 将输出写入文件
    with open('ports.txt', 'w') as file:
        file.write(result.stdout)
        
    with open('ports.txt', 'r') as file:
        for line in file:
            # 如果以 "open" 开头
            if line.startswith('Open'):
                # 用空格分割
                parts = line.split()
                # 取后面的内容
                content = parts[1:]
                # 将内容连接起来
                content_str = ' '.join(content)
                try:
                    url = f"http://{content_str}"
                    response = requests.request("get", url)
                    result = json.loads(response.text)
                    if response.text==message:
                        print("Alist地址是:http://"+content_str)
                        break
                except:
                    continue

def get_ip():
    ip = requests.get('https://checkip.amazonaws.com').text.strip()
    return ip

def get_message():
    ip = requests.get('http://localhost:10003').text.strip()
    return ip

if __name__ == '__main__':
    ip = get_ip()
    message = get_message()
    scan_ports(ip,message)
