##########################################
###  Common
##########################################
project = "jena"
region  = "ap-northeast-2"
env     = "dev"

##########################################
###  EKS Config
##########################################
eks_cluster_name                       = "jena-eks"
eks_endpoint_url                       = ""
eks_cluster_certificate_authority_data = ""

##########################################
###  Helm Chart Config
##########################################
helm_release_name   = "karpenter"
helm_chart_name     = "karpenter"
helm_chart_version  = "v0.27.3"
helm_repository_url = "oci://public.ecr.aws/karpenter"

##########################################
###  Karpenter
##########################################
create_namespace = true
namespace        = "karpenter"

# 해당 zone에 controller가 있어야 node provisioning 할 수 있음.
replica_count = 2

tolerations = [{
  key      = "role"
  operator = "Equal"
  value    = "ops"
  effect   = "NoSchedule"
}]

affinity = {
  nodeAffinity = {
    requiredDuringSchedulingIgnoredDuringExecution = {
      nodeSelectorTerms = [{
        matchExpressions = [{
          key      = "role"
          operator = "In"
          values   = ["ops"]
        }]
      }]
    }
  }
}

node_selector = {
  role = "ops"
}

resources = {
  limits = {
    cpu    = "200m"
    memory = "512Mi"
  },
  requests = {
    cpu    = "200m"
    memory = "512Mi"
  }
}

##########################################
###  Provisioner CRDs
##########################################
crds = {
  ops_node = <<YAML
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: ops-provisioner
spec:
  requirements:
    - key: "karpenter.k8s.aws/instance-category"
      operator: In
      values: ["t", "m", "r"]    
    - key: "karpenter.k8s.aws/instance-cpu"
      operator: In
      values: ["4", "8", "16", "32"]      
    - key: "karpenter.sh/capacity-type"
      operator: In
      values: ["spot", "on-demand"]
    - key: "topology.kubernetes.io/zone"
      operator: In
      values: ["ap-northeast-2a", "ap-northeast-2c"]  
  limits:
    resources:
      cpu: "100"
  labels:
    role: ops 
    provision: karpenter
    overprovisioning: ops  
  taints:
    - key: role
      effect: NoSchedule 
      value: ops     
  consolidation:
    enabled: false  
  ttlSecondsAfterEmpty: 30
  ttlSecondsUntilExpired: 2592000

  provider:
    subnetSelector:
      aws-ids: "subnet-0c6405113c8c6c9ff,subnet-0272f0cc333aceec8"
    securityGroupSelector:
      aws-ids: "sg-0f20ce994969820df,sg-0d776a7a2005d054a"
    tags:
      Name: ops-karpenter-provision  
    blockDeviceMappings:
    - deviceName: /dev/xvda
      ebs:
        volumeSize: 100Gi
        volumeType: gp3    
        deleteOnTermination: true
YAML 

  test_node = <<YAML
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: test-provisioner
spec:
  requirements:
    - key: "karpenter.k8s.aws/instance-category"
      operator: In
      values: ["t", "m", "r"]    
    - key: "karpenter.k8s.aws/instance-cpu"
      operator: In
      values: ["4", "8", "16", "32"]      
    - key: "karpenter.sh/capacity-type"
      operator: In
      values: ["spot", "on-demand"]
    - key: "topology.kubernetes.io/zone"
      operator: In
      values: ["ap-northeast-2a", "ap-northeast-2c"]      
  limits:
    resources:
      cpu: "100"
  labels:
    role: test 
    provision: karpenter
    overprovisioning: test  
  taints:
    - key: role
      effect: NoSchedule 
      value: test     
  consolidation:
    enabled: false     
  ttlSecondsAfterEmpty: 30
  ttlSecondsUntilExpired: 2592000

  provider:
    subnetSelector:
      aws-ids: "subnet-0c6405113c8c6c9ff,subnet-0272f0cc333aceec8"
    securityGroupSelector:
      aws-ids: "sg-0f20ce994969820df,sg-0d776a7a2005d054a"
    tags:  
      Name: test-karpenter-provision      
    blockDeviceMappings:
    - deviceName: /dev/xvda
      ebs:
        volumeSize: 100Gi
        volumeType: gp3    
        deleteOnTermination: true   
YAML
}