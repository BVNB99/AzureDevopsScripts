import requests
import zipfile
import os
import sys

url = 'https://releases.hashicorp.com/terraform/1.9.3/terraform_1.9.3_windows_amd64.zip'
file_name = url.split('/')[-1]
terraform_dir = "C:\\terraform"

def create_directory():
    if not os.path.exists(terraform_dir):
        os.makedirs(terraform_dir)

def download_terraform():
    download_file = requests.get(url, stream=True)
    zip_file_path = "/opt/myagent"
    with open(file_name, "wb") as f:
        for chunk in download_file.iter_content(chunk_size=1024):
            if chunk:
                f.write(chunk)

def install_terraform():
    with zipfile.ZipFile(file_name, "r") as install_file:
        install_file.extractall(path=terraform_dir)

def remove_zip_file():
    if os.path.exists(file_name):
        os.remove(file_name)

def set_environment_variable():
    print("Terraform installation is completed")
    print("Add 'C:\\terraform' to environment variables in My Computer > Advanced System Settings > System Properties > Environment Variables > System variables > Path")

if __name__ == "__main__":
    create_directory()
    download_terraform()
    install_terraform()
    remove_zip_file()
    set_environment_variable()
