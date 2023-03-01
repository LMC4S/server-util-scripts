# Ubuntu server pytorch env config and other utility scripts. 

Install essential packages for pytorch dev env and file server.

```
sudo apt update 
```

## ssh server

```
sudo apt install openssh-server
sudo ufw allow ssh

sudo systemctl enable ssh
```

## (Optional) docker

Get docker engine (not the desktop) from official docker repo.
```
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt install docker-ce

sudo systemctl enable docker 
```

Add current user as super user in docker group.

```
sudo usermod -aG docker ${USER}
su - ${USER}
```

Check installation.

```
sudo systemctl status docker
docker run hello-world
```

(Optional) Setup auto-run for certain docker container.

```
docker update --restart unless-stopped <container-name>
```

## Miniconda and torch env

Get latest version of miniconda from official website.

```
cd ~/Downloads 
wget "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" -o conda.sh
sh conda.sh
# Then press ENTER for like 100 times to read the license for no reason 
```

Config env and install essentail python modules. 

```
conda create --name <env-name> 
conda config --set auto_activate_base false

conda activate <env-name>
conda install pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia
conda install numpy pandas scipy tensorboardX matplotlib plotly
pip install jupyterlab

pip install pyspark
pip install pyspark[sql]
pip install pyspark[pandas_on_spark]
# conda install openjdk
 ```
 
## Nvidia CUDA toolkit 
 
 Nvidia gpu driver and CUDA toolkit should be installed along with the Ubuntu 22.04 LTS if you choose to install the full version instead of the minimum version. Check it by:

```
nvidia-smi
```

If Ubuntu is installed in minimum version, then install gcc, nvidia driver, and CUDA toolkit.

```
sudo apt install gcc
```

Just to make sure it's a clean install.

```
# DO NO RUN
# sudo apt-get purge *nvidia*
# sudo apt autoremove
```

Search for available drivers and install. A reboot is necessary after installation.

```
apt search nvidia-driver

sudo apt install nvidia-driver-525
# sudo reboot
```

Check installation after reboot.

```
nvidia-smi

conda activate <torch-env>
python3 -c 'from torch.version import cuda; print(cuda)' 
conda deactivate
```

## (Optional) Samba for general purpose file server

Install package and check installation.
```
sudo apt install samba
systemctl status smbd
```

Edit config file:

```
sudo nano /etc/samba/smb.conf
```

Add your shared folder config to the bottom of the file.

```
[my_shared_folder]
    comment = Shared Folder from Server
    path = <path-to-folder>
    read only = no
    writable = yes
    browsable = yes
    valid users = @username
```

Then restart the service, update firewall rules, and (optional) enable it at login. 

```
sudo systemctl restart smbd
sudo ufw allow samba

sudo systemctl enable smbd
```

In case the drives that you want to share on server are not mounted, here is a short cheat sheet for mounting drives. First check the all mounted/unmounted drives in your system, find the name of the **partition** that you are trying to share and mount it.

```
lsblk

sudo mkdir /mnt/shared_drive
sudo mount /dev/<partition-name-like-nvme01p2>
```
