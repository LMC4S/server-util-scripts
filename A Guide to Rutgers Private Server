
---
title: A Guide to Rutgers GPU Server
author: Ziyue Wang
date: November 11th, 2023
https://github.com/LMC4S/server-util-scripts
---


# 1. Prerequisite 

A VPN connection to Rutgers' private network is required to connect to the server. If you have not setup the VPN, go to vpn.rutgers.com to configure and follow the instructions. On MacOS I would recommand download the "Cisco Secure Client". Once the Cisco Anyconnect (or Secure Client) is installed, it would ask for
* VPN server address: vpn.rutgers.edu
* username: <netid>
* password1: <rutgers_password>
* password2: <Duo authenticator number> or simply use the word "push" to push a approval request to your Duo Mobile app on your phone. 

Once your computer is connected to Rutgers' secure network, you are in the same local network with the GPU server and can connect it using ssh. If you are using MacOS you can use the built-in app "Terminal" which provides command line interface for Bash, if you are using Windows I recommand downloading the "Git Bash" and use that as the terminal (https://gitforwindows.org). 

A side note, Bash is a shell script and is the default shell for Ubuntu, all the shell scripts that we are going to use are Bash scripts. On you local machine, you will be using Bash to connect to the GPU server via SSH protocal (https://www.digitalocean.com/community/tutorials/how-to-use-ssh-to-connect-to-a-remote-server) and syncing files from/to GPU server via rsync (https://www.digitalocean.com/community/tutorials/how-to-use-rsync-to-sync-local-and-remote-directories) or scp ([Secure copy protocol](https://en.wikipedia.org/wiki/Secure_copy_protocol); once connected and get "inside" the server, you will be using Bash to communicate with/operate/control the GPU server.

# 2. Connect to server

In the terminal on your local machine, use the following code to connect to server.

```{Bash}
ssh <netid>@<server_id>.sas-busch.rutgers.edu
```
The “<server_id>” in the server address “<server_id>.sas-busch.rutgers.edu" is a sequence of number/letters like "sas1234a5678b9c", to be obtained from server owner. If the service address is correct then you will be asked for your Rutgers password to login. Once provided your password, you will see the following welcome message from the Ubuntu GPU server:

```{Bash}
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.14.0-1059-oem x86_64)

3 devices have a firmware upgrade available.
Run `fwupdmgr get-upgrades` for more information.

Last login: Sat Nov 11 16:50:01 2023 from <your ip>
```

# 3. Set up your conda environment 
A personal folder "<your_netid>" that only you have read & write access will be automatically created at “/home/<your_netid>”. This personal folder will be the default path every time you login. Note that although you have a personal folder, you are still sharing the resources with other users, which includes the base softwares installed. You will not be granted admin access so it's impossible (and not recommended) to install softwares directly to the system. As it may do harm to the server and may affect other users' programs. Ask the server owner if you really need to install a software that requires admin access. 

A common approach would be configuring your own computation environment that will only be available to you. For machine learning research it is sufficient to use the conda (https://docs.conda.io/projects/miniconda/en/latest/) and pip (https://pypi.org/project/pip/) package managers and create a conda environment that oversees all your python modules. Get latest version of miniconda from official website.

```{Bash}
# Download and run miniconda installer
wget "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" -O conda.sh

sh conda.sh

# Then keep pressing ENTER to read through the license to proceed
```

The installation of conda does not require admin access and it is only available to you thus it won't corrupt other users' environment. Once conda is installed, create and config a conda environment and install essential python modules within this environment. The pip package manager mentioned above comes with python and does not need to be manually installed.

```
conda create --name <your_env_name>   # create a environment with a name 
conda config --set auto_activate_base false.  # turn off the default base environment 

conda activate <env-name>   # activate your environment
```

Once your environment is activated, you will see an indicator in the command-line interface like "(your_env_name) <netid>@<server_id>:~$". Next install essential packages:

```
conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia
conda install numpy pandas scipy scikit-learn tensorboard matplotlib plotly
pip install jupyterlab
 ```
 
 This will install pytorch and other popular machine learning modules. Check the latest pytorch version install script on https://pytorch.org.  
 
# 4. Check that Nvidia CUDA toolkit is installed

Nvidia GPU driver and CUDA toolkit should already be installed on the server for all users. Check it by running:

```
nvidia-smi
```

If GPU drivers are in place and CUDA tools are ready, you will see a monitoring log like

```
Sat Nov 11 18:37:44 2023
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 525.105.17   Driver Version: 525.105.17   CUDA Version: 12.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA RTX A4000    Off  | 00000000:17:00.0 Off |                  Off |
| 39%   40C    P0    35W / 140W |      0MiB / 16376MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  NVIDIA RTX A4000    Off  | 00000000:73:00.0 Off |                  Off |
| 37%   41C    P0    34W / 140W |      0MiB / 16376MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   2  NVIDIA RTX A4000    Off  | 00000000:A6:00.0 Off |                  Off |
| 34%   45C    P0    37W / 140W |      0MiB / 16376MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   3  NVIDIA RTX A4000    Off  | 00000000:D5:00.0 Off |                  Off |
| 32%   50C    P0    36W / 140W |      0MiB / 16376MiB |      2%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
```

Also, you can check current CUDA version and test the successful installation of CUDA-enabled pytorch by running the following scripts:

```
conda activate <your_env_name> 
python3 -c 'from torch.version import cuda; print(cuda)' 
conda deactivate   # optional, this will deactivate your environment 
```

# 5. Running scripts
Now you are ready to:
* deploy scripts to server, leave it running, and come back to collect result using rsync, and
* interactively develop on it through the Jupyter Lab as if it's your local machine.

## a) Run scripts
To run a scripts, simply run:
```
python your_script.py
``` 
Don't forget to activate your environment and have the script downloaded on the server. It's strongly recommended to keep/manage all your scripts on GitHub and sync (clone) it to server, instead of uploading from your local machine. See https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository for tutorials. For example,

```
git clone https://github.com/LMC4S/robust-sparsePCA-pytorch.git
``` 
This will create a folder and download the GitHub repository to it, anything you have in the GitHub Repository will be ready to go on GPU server in this folder. To further sync the changes and learn more about repository management using git, see https://github.com/git-guides.

You can also specific which GPU to use for a specific python script:
```
CUDA_VISIBLE_DEVICES=0,1,2,3 python your_gpu_python_script.py # all four gpus

CUDA_VISIBLE_DEVICES=0 python your_gpu_python_script.py # the first gpu
```

Check gpu status using the "nvidia-smi" command. 

One thing to notice is that the script you executed by running "python your_script.py" will be terminated once you close the connection to the server, which makes it inconvenient for deploying jobs that need extended period of time to finish. A tip here is, you can use a trick in Bash to "throw" the job to the backend and it will run until finished whether you are connected or not, **(CAUTION)** the risk is you need additional steps to stop this job once it is send to server, and the script could be in a infinite loop and running forever if not written as intended. See https://www.digitalocean.com/community/tutorials/nohup-command-in-linux for reference. 

```
# DO NOT RUN if you are not 100% sure the script is valid
nohup python your_script.py & 
```

This will send the script to run in a "hidden" way and does not need monitoring from your active connection. To terminate this "hidden" python job, you need to find its pid:

```
ps -ef | grep python
```

This will show you all active "python" jobs. **(CAUTION)** Next find the one you submitted and kill it with its pid:

```
kill 123456 
```
Make sure you are closing the correct python script. You may also see other users' python job here, do not interfere python jobs of other users. 

For better automation to run a batch of jobs, for example tuning for hyper-parameters, I personally would write a train.py that takes parameter arguments as inputs (see https://docs.python.org/3/library/argparse.html), and write a for loop in bash to automatically execute train.py on different set of parameters. An example is available at https://github.com/LMC4S/robust-sparsePCA-pytorch/blob/main/run.sh, although it is overly complicated and may not be necessary. 


## b) Interactively develop on GPU server
It's also possible to run a GUI on your local machine's browser, edit and run code interactively on GPU server. See https://docs.anaconda.com/free/anaconda/jupyter-notebooks/remote-jupyter-notebook/. First connect to server again with port forwarding: 

```
ssh -L 8080:127.0.0.1:8080 <netid>@<server_id>.sas-busch.rutgers.edu
```
This will expose the port 8080 on GPU server to your local machine's port 8080, so you can access the service within local network of GPU server thru port 8080. This port number can be picked by your preference but to avoid conflictions let's just keep it to be 8080. This command will connect you to the GPU server similarly to the "ssh" command we see in the beginning, keep this terminal open, and run 

```
jupyter lab --no-browser --port=8080
```

Leave this terminal open, on your local machine, open a browser and go to address "http://localhost:8080" and you should be able to see the Jupyter Lab service. It is hosted on the GPU server and you can upload/edit files interactively, and run python in your browser utilizing the resources on GPU server ([Get Started — JupyterLab 4.0.8 documentation](https://jupyterlab.readthedocs.io/en/stable/getting_started/overview.html)).

# 6. Collect result
Let's say you've had a job submitted and saved the output in a folder "~/result" on GPU server. A convenient way to download this entire folder is using the rsync (on MacOS or Linux local machine) or scp (on Windows). 

```
rsync -trlvpz <netid>@<server_id>.sas-busch.rutgers.edu:/path/to/folder/ <local folder>
```
For example, to download/sync the "my_output" folder located at "/home/ab123/my_output" on server "sas1234a5678b9c" to my local machine's "/Users/my_mac_user/server_run", simply run

```
rsync -trlvpz ab123@sas1234a5678b9c.sas-busch.rutgers.edu:/home/ab123/my_output /Users/my_mac_user/server_run
```
This command works in both direction after swapping the position of two folders. **(CAUTION)** For uploading please be careful before running the command because it can overwrite what you already had in the target folder on server. 

On Windows, try the following scp command in the Git Bash terminal
```
scp -r ab123@sas1234a5678b9c.sas-busch.rutgers.edu:/path/to/folder/  C:\\Users\\User\\\server_run
```

# 7. Utility commands
Some useful Bash commands to run on server.

```
top
```

This will show all active processes on the server and provide CPU and memory usage monitoring. It's convenient to run this command and take a brief look at the status of your jobs here.

```
nvidia-smi
```
As described in previous sections, this command is used to monitor GPU usage and CUDA processes running status.

```
ls
```
List current folder structure. Or use “dir” for detailed information.

```
cd <folder>
cd ~
cd ..
```
Move to the target folder; move to default user folder; go back to parent folder. 

```
rm <folder>
rm -rf <folder>
```
Remove a folder; **(CAUTION)** Force remove everything recursively inside the folder.



