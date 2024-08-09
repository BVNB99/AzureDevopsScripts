import requests
import os
import tarfile
import subprocess


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

def apt_update():
    print("Executing apt update")
    cmd = ['apt', 'update']
    output = install_apt(cmd)

def install_packages():
    print("Installing apt-transport-https and software-properties-common")
    cmd = ['apt', 'install', 'apt-transport-https', 'ca-certificates', 'curl', 'software-properties-common', '-y']
    output = install_apt(cmd)

def install_apt(command):
    update = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    print(f"\nOutput is: {update.stdout}")

def install_docker():
    print("Installing docker")
    download_gpg = subprocess.Popen(('curl', '-fsSL', 'https://download.docker.com/linux/ubuntu/gpg'), stdout=subprocess.PIPE)
    create_gpg = subprocess.Popen(('apt-key', 'add', '-'), stdin=download_gpg.stdout)
    command = ['add-apt-repository', 'deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable']
    add_repository = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    update_policy = subprocess.run(['apt-cache', 'policy', 'docker-ce'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    install = subprocess.run(['apt', 'install', 'docker-ce', '-y'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    print(f"\nInstall docker status is: {install.stdout}")
    start_service = subprocess.run(['systemctl', 'start', 'docker'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    check_status = subprocess.run(['systemctl', 'status', 'docker'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    print(f"\nDocker service status is: {check_status.stdout}")
    update_permission = subprocess.run(['chmod', '666', '/var/run/docker.sock'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    docker_version = subprocess.run(['docker', '-v'],  stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    print(f"\nDocker version is: {docker_version.stdout}")
    print("\nInstalling docker compose")
    install_docker_compose = subprocess.Popen(('curl', '-L', 'https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)'), stdut=subprocess.PIPE)
    create_docker_compose = subprocess.Popen(('-o', '/usr/local/bin/docker-compose'), stdin=install_docker_compose.stdout)


if __name__ == "__main__":
    apt_update()
    install_packages()
    install_docker()
    create_agent_directory()
    download_archive_file()
    install_archive_file()
    print("Execute ./config.sh and ./run.sh in " + tar_file_path + " path")
