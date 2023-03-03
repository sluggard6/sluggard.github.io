---
layout: post
title: k8s集群搭建记录
date: 2023-03-03
categories: blog
tags: [k8s]
description: 
---

# k8s集群搭建记录

## 前置说明
- 文中服务器操作系统为ubuntu22.04
- 所有机器已安装docker-engine

***
## 安装容器运行时(CRI)

### 转发IPv4并让iptables看到桥接流量

- 执行下述指令：

```
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# 设置所需的 sysctl 参数，参数在重新启动后保持不变
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# 应用 sysctl 参数而不重新启动
sudo sysctl --system
```

- 通过运行一下指令确认bn_netfilter和overlay模块被加载：

```
lsmod | grep br_netfilter
lsmod | grep overlay
```

- 通过运行以下指令确认 net.bridge.bridge-nf-call-iptables、net.bridge.bridge-nf-call-ip6tables 和 net.ipv4.ip_forward 系统变量在你的 sysctl 配置中被设置为 1：

```
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward
```

#### 确认cgroup驱动
- 执行以下命令

```
docker info | grep -i cgroup
```

- 结果显示

```
Cgroup Driver: systemd
 Cgroup Version: 2
  cgroupns

```

#### 安装cri-dockerd

- 下载代码并使用docker建立golang编译环境

```
git clone https://github.com/Mirantis/cri-dockerd.git
docker run -it --rm -v $PWD/cri-dockerd:/usr/src/cri-dockerd -w /usr/src/cri-dockerd golang:latest
```

- 以下命令在容器内执行

```
# 设置golang依赖下载代理
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct
go env -w GOFLAGS=-buildvcs=false
# 原编译代码
mkdir bin
go build -o bin/cri-dockerd
# 推出容器
exit
```

- 继续执行以下命令

```
cd cri-dockerd
mkdir -p /usr/local/bin
sudo install -o root -g root -m 0755 bin/cri-dockerd /usr/local/bin/cri-dockerd
sudo cp -a packaging/systemd/* /etc/systemd/system
sudo sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
sudo systemctl daemon-reload
sudo systemctl enable cri-docker.service
sudo systemctl enable --now cri-docker.socket
```
***
## 阿里云源安装kubeadm

- 安装kubeadm kubelet kubectl

```
sudo apt update && apt install -y apt-transport-https

sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg http://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] http://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt install -y kubelet kubeadm kubectl
# 锁定版本
sudo apt-mark hold kubelet kubeadm kubectl
```

- 验证安装和版本

```
kubeadm version
kubelet --version
kubectl version
```

#### 创建集群

- 关闭swap

```
swapoff -a
```

- 下载镜像

```
# 拉取默认镜像通过阿里云
sudo kubeadm config images pull --image-repository registry.aliyuncs.com/google_containers --cri-socket unix:///var/run/cri-dockerd.sock
# 额外拉一个
docker pull registry.aliyuncs.com/google_containers/pause:3.6
# 修改tag
docker images|grep "registry.aliyuncs.com/google_containers"|sed 's/registry.aliyuncs.com\/google_containers/registry.k8s.io/g'|awk '{print "docker tag"" " $3" "$1":"$2}'|sh
```

- 初始化集群

```
sudo kubeadm init --image-repository registry.aliyuncs.com/google_containers --cri-socket unix:///var/run/cri-dockerd.sock
```

- 如果失败，使用下面命令删除集群重新再来

```
sudo kubeadm reset --cri-socket unix:///var/run/cri-dockerd.sock
```

- 建立普通用户权限

```
mkdir -p ~/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```


