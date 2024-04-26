provider "aws" {}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = "DevOps-Test-Cluster"
  cluster_version = "1.29"

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  vpc_id                   = "vpc-08d1c72334925b655"
  subnet_ids               = ["subnet-08f4060edfcfa0c0e", "subnet-03dde3166047fcbda", "subnet-00fd5f80a7666389b"]
  control_plane_subnet_ids = ["subnet-08f4060edfcfa0c0e", "subnet-03dde3166047fcbda", "subnet-00fd5f80a7666389b"]

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    DevOps-Test-Node = {
      min_size     = 1
      max_size     = 5
      desired_size = 1

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
      iam_role_additional_policies = { AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy" }
    }
    

  }
  
  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true
  tags = {
    Environment = "DevOps"
    Terraform   = "true"
  }
}

