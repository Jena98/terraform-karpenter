# karpenter

- [karpenter](https://github.com/aws/karpenter)


## 사전 조건

SPOT 처음 사용 하는 경우 필요
```sh
aws iam create-service-linked-role --aws-service-name spot.amazonaws.com || true
```

## 주의 사항
- Karpenter를 삭제하면 Karpenter가 Provisioning한 Node가 NotReady 상태가 된다.
- karpenter가 프로비저닝한 노드에 karpenter를 설치하면 안된다. 즉, karpenter는 노드그룹 노드에 설치해야한다.

## Install / Uninstall by Terraform

```sh
terraform init

terraform plan -var-file=example/example.tfvars

terraform apply -var-file=example/example.tfvars -auto-approve

terraform destroy -var-file=example/example.tfvars -auto-approve
```


## Provisioner CRD 예시 
```yaml
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
```
- [Provisioner](https://karpenter.sh/v0.18.1/provisioner/)
- [AWSNodeTemplate](https://karpenter.sh/v0.18.1/aws/provisioning/#awsnodetemplate)


## Configuration

|파라미터|타입|기본값|설명|
|--------|--------|--------|--------|
|project|string|""|프로젝트 코드명|
|env|string|""|프로비전 구성 환경 </br>(예시: dev, stg, qa, prod, ...)|
|region|string|""|리전명|
|backend_s3_bucket_name|string|""|terraform s3버킷명|
|eks_s3_key|string|""|eks backend에 대한 s3 키파일|
|infra_network_s3_key|string|""|infra-network(vpc/subnets) backend에 대한 s3 키파일|
|eks_cluster_name|string|""|EKS클러스터명|
|eks_endpoint_url|string|""|EKS Endpoint URL|
|eks_cluster_certificate_authority_data|string|""|EKS CA Data|
|eks_oidc_provider_arn|string|""|EKS OIDC Provider ARN|
|eks_oidc_provider_url|string|""|EKS OIDC Provider URL|
|eks_auth_token|string|""|EKS Auth Token</br>* eks_cluster_name 설정하면 자동 설정됨|
|helm_release_name|string|""|helm release명|
|helm_chart_name|string|""|helm 차트명|
|helm_chart_version|string|""|helm 차트버전|
|helm_repository_url|string|""|helm repository url|
|create_namespace|bool|true|namespace 생성여부|
|namespace|string|"karpenter"|namespace명|
|replica_count|number|2|replica 갯수|
|karpenter_values|object|{}|karpenter helm values 설정|
|node_selector|map|{}|nodeSelect설정(yaml)<br><pre>node_selector = {<br>  role: ops<br>}</pre>|
|affinity|map|{}|affinity설정(yaml)<br><pre>affinity = {<br>  nodeAffinity = {<br>    requiredDuringSchedulingIgnoredDuringExecution = {<br>      nodeSelectorTerms = [{<br>        matchExpressions = [{<br>          key = "role"<br>          operator =  "In"<br>          values = ["ops"]<br>        }]<br>      }]<br>    }<br>  }<br>}</pre>|
|tolerations|map|{}|tolerations설정(yaml)<br><pre>tolerations = [{<br>  key = "role"<br>  operator = "Equal"<br>  value = "ops"<br>  effect = "NoSchedule"<br>}]</pre>|