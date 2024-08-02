import subprocess
import requests
import os

gpg_key_file = '/usr/share/keyrings/hashicorp-archive-keyring.gpg'

def remove_gpg_key():
    print(f"Removing old gpg key file: {gpg_key_file}")
    if os.path.exists(gpg_key_file):
        os.remove(gpg_key_file)

def update_packages():
    print("Executing apt-get update")
    cmd = ['apt-get', 'update', '-y']
    output = install_apt(cmd)

def install_packages():
    print("Installing gnupg and software-properties-common")
    cmd = ['apt-get', 'install', '-y', 'gnupg', 'software-properties-common']
    output = install_apt(cmd)

def install_apt(command):
    update = str(subprocess.run(command, capture_output=True).stdout, 'ascii')
    print(f"Output is: {update}")

def configure_gpg_key():
    print("Downloading gpg key")
    gpg_file_url = 'https://apt.releases.hashicorp.com/gpg'
    gpg_key = requests.get(url=gpg_file_url)
    output = gpg_key.content.decode('UTF-8')
    print(f"GPG key data is: {output}")
    download_gpg = subprocess.Popen(('wget', '-O-', 'https://apt.releases.hashicorp.com/gpg'), stdout=subprocess.PIPE)
    create_gpg = subprocess.Popen(('gpg', '--dearmor', '-o', gpg_key_file), stdin=download_gpg.stdout)
    print("Validating the gpg key fingerprint")
    cmd = ['gpg', '--no-default-keyring', '--keyring', gpg_key_file, '--fingerprint']
    validate_gpg = subprocess.run((cmd, capture_output=True).stdout)
    print(f"Validate fingerprint output is: {validate_gpg}")


if __name__ == "__main__":
    update_packages()
    install_packages()
    remove_gpg_key()
    configure_gpg_key()
