#!/bin/bash

# 定义了一个函数来检查上一个命令是否成功执行
check_last_command() {
    if [ $? -eq 0 ]; then
        echo "Command executed successfully."
    else
        echo "Command failed."
    fi
}

# 设置SSH代理并添加私钥
setup_ssh() {
    cd ~/.ssh
    eval $(ssh-agent -s)
    check_last_command
    ssh-add firesim.pem
    check_last_command
    cd ~
}

# 启动clash-for-linux
start_cfw() {
    cd ~/clash-for-linux/
    sudo bash start.sh
    check_last_command
    source /etc/profile.d/clash.sh
    proxy_on
    cd ~
}

shutdown_cfw() {
    cd ~/clash-for-linux/
    sudo bash shutdown.sh
    check_last_command
    proxy_off
    cd ~
}

# 激活conda环境
conda_init() {
    conda activate /home/rain/firesim/.conda-env/
    conda env list
}

# 初始化firesim
firesim_init() {
    cd ~/firesim
    source sourceme-manager.sh --skip-ssh-setup
    cd ~
}

# 确保提供了一个参数
if [ $# -eq 0 ]; then
    echo "Usage: $0 {ssh|startcfw|condainit|firesiminit|all}"
fi

# 根据第一个参数执行不同的操作
case "$1" in
    ssh)
        setup_ssh
        ;;
    startcfw)
        start_cfw
        ;;
    shutdowncfw)
        shutdown_cfw
        ;;
    condainit)
        conda_init
        ;;
    firesiminit)
        firesim_init
        ;;
    all)
        setup_ssh
        start_cfw
        conda_init
        firesim_init
        ;;
    *)
        echo "Invalid option: $1"
        echo "Usage: $0 {ssh|startcfw|condainit|firesiminit|all}"
        ;;
esac


