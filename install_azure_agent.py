import requests
import os
import tarfile


url = 'https://vstsagentpackage.azureedge.net/agent/3.242.1/vsts-agent-linux-x64-3.242.1.tar.gz'
download_file = requests.get(url, stream=True)
file_name = url.split('/')[-1]
tar_file_path = "/opt/myagent"

def create_agent_directory():
    if not os.path.exists(tar_file_path):
        os.makedirs(tar_file_path)


def download_archive_file():
    with open(file_name, "wb") as f:
        for chunk in download_file.iter_content(chunk_size=1024):
            if chunk:
                f.write(chunk)


def install_archive_file():
    with tarfile.open(file_name) as untar_file:
        untar_file.extractall(path=tar_file_path)


if __name__ == "__main__":
    create_agent_directory()
    download_archive_file()
    install_archive_file()
    print("Execute ./config.sh and ./run.sh in " + tar_file_path + " path")
    
