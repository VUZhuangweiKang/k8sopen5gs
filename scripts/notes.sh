# kubeadm init超时？检查/etc/docker/daemon.json中docker cgroup driver是不是systemd
echo '{"exec-opts": ["native.cgroupdriver=systemd"]}' >> /etc/docker/daemon.json

# run pod on the master node
kubectl taint node open5gs0.k8sopen5gs.docgroup-vu.emulab.net node-role.kubernetes.io/master:NoSchedule-

# 在安装好Calico CNI后需要安装multus-cni
git clone https://github.com/k8snetworkplumbingwg/multus-cni.git && cd multus-cni
cat ./deployments/multus-daemonset-thick-plugin.yml | kubectl apply -f -

# 为MongoDB创建PV是需要视情况修改path, 并将nodeSelectorTerms.matchExpressions.values改为PV所在node名字
kubectl create ns <namespace>
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: free5gc-pv
  labels:
    project: free5gc
spec:
  capacity:
    storage: 8Gi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  local:
    path: /users/VUZK/kubedata
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - open5gs1.k8sopen5gs.docgroup-vu.emulab.net
EOF

# towards5gs-helm中，需要重设global values.yaml中masterIf名字，以及n6network中的IP地址，并且设置free5gc-upf中的n6 IP地址为物理网卡地址