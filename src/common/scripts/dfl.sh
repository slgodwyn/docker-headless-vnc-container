#!/bin/bash

apt-get update && apt upgrade -y
apt-get install -y perl
apt-get install -y sudo
apt-get install -y wget
apt-get install -y ffmpeg
apt-get install -y unzip
apt-get install ubuntu-drivers-common \
	&& ubuntu-drivers autoinstall

#blacklist the Nouveau driver so it doesn't initialize:
FILE=/etc/modprobe.d/blacklist-nvidia-nouveau.conf
if [ -f "$FILE" ];
then
	bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
	bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
	cat /etc/modprobe.d/blacklist-nvidia-nouveau.conf
	update-initramfs -u
else
   echo "File $FILE does not exist" 
fi

update-initramfs -u

mkdir /tmp/DFL_install
TMP_DIR="/tmp/DFL_install"
DL_CONDA="https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh"
DL_DFL="https://slgodwyn:holliday954@github.com/nagadit/DeepFaceLab_Linux.git"

CONDA_PATHS=("/opt" "/home/default")
CONDA_NAMES=("/ana" "/mini")
CONDA_VERSIONS=("3" "2")
CONDA_BINS=("/bin/conda" "/condabin/conda")
DIR_CONDA="/home/default/anaconda"
CONDA_EXECUTABLE="${DIR_CONDA}/bin/conda"
CONDA_TO_PATH=false
ENV_NAME="deepfacelab"

CONDA_EXECUTABLE="${DIR_CONDA}/bin/conda"
[CONDA_TO_PATH=true

    # Download and install Anaconda3
script_name='anaconda.sh'
env_path='/home/default/anaconda'
# download the installation script
echo "Downloading conda installation script..."
curl $DL_CONDA -s -o $script_name
# create temporary conda installation
echo "conda installation..."
TMPDIR=$TMP_DIR bash $script_name -b -f -p $env_path >> /dev/null
rm $script_name

source $DIR_CONDA/etc/profile.d/conda.sh
$CONDA_EXECUTABLE init bash
exec $SHELL

DEFAULT=/home/default
if [ -d "$DEFAULT" ];
then
	cd $DEFAULT
else
	mkdir $DEFAULT
	chown default:default $DEFAULT
fi

git clone --depth 1 --no-single-branch "$DL_DFL"
cd /home/default/DeepFaceLab_Linux
git clone --depth 1 --no-single-branch https://slgodwyn:holliday954@github.com/iperov/DeepFaceLab.git
curl https://raw.githubusercontent.com/slgodwyn/dfl/main/dfl.yml -o /home/default/dfl.yml
conda env create -f /home/default/dfl.yml

echo "export DFL_WORKSPACE="/home/default/DeepFaceLab_Linux/workspace"" >> /home/default/.bashrc
echo "export DFL_PYTHON="python3.7"" >> /home/default/.bashrc
echo "export DFL_SRC="/home/default/DeepFaceLab_Linux/DeepFaceLab"" >> /home/default/.bashrc
echo "export SCRIPTS="/home/default/DeepFaceLab_Linux/scripts"" >> /home/default/.bashrc

export DFL_WORKSPACE="/home/default/DeepFaceLab_Linux/workspace" 
export DFL_PYTHON="python3.7" 
export DFL_SRC="/home/default/DeepFaceLab_Linux/DeepFaceLab"
export SCRIPTS="/home/default/DeepFaceLab_Linux/scripts"

mkdir $DFL_WORKSPACE
mkdir $DFL_WORKSPACE/data_src
mkdir $DFL_WORKSPACE/data_src/aligned
mkdir $DFL_WORKSPACE/data_src/aligned_debug
mkdir $DFL_WORKSPACE/data_dst
mkdir $DFL_WORKSPACE/data_dst/aligned
mkdir $DFL_WORKSPACE/data_dst/aligned_debug
mkdir $DFL_WORKSPACE/model

cd $DFL_WORKSPACE/model
wget https://github.com/chervonij/DFL-Colab/releases/download/GenericXSeg/GenericXSeg.zip
unzip GenericXSeg.zip -d $DFL_WORKSPACE/model/
cd $DFL_WORKSPACE

