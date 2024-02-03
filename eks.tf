resource "aws_eks_cluster" "cluster" {
    name = "cluster"

    version = "1.28"
    role_arn = aws_iam_role.clusterrole.arn

    vpc_config {
      subnet_ids = flatten([ aws_subnet.publicsubnets[*].id, aws_subnet.privatesubnets[*].id ])
      endpoint_public_access  = true
      endpoint_private_access = true
      public_access_cidrs     = ["0.0.0.0/0"]
    }

    depends_on = [ aws_iam_role_policy_attachment.clusterroleatachment ]

    tags = merge(var.comman_tags,{
        "Name" = "Eks-Cluster"
    })
  
}




resource "aws_iam_role" "clusterrole" {
    name = "clusterrole"
    assume_role_policy = data.aws_iam_policy_document.cluster_assume_role.json
    tags = merge(var.comman_tags,{
        "Name" = "Eks-Cluster-Role"
    })
  
}

resource "aws_iam_role_policy_attachment" "clusterroleatachment" {
    role = aws_iam_role.clusterrole.name
    policy_arn =  "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    

  
}

resource "aws_eks_node_group" "nodegroup" {
    cluster_name    = aws_eks_cluster.cluster.name
    node_group_name = "cluster-nodegroup"
    node_role_arn   = aws_iam_role.workerrole.arn
    subnet_ids      = aws_subnet.privatesubnets[*].id

    scaling_config {
    desired_size = 1
    max_size     = 4
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
  ami_type       = "AL2_x86_64"
  disk_size      = 20
  capacity_type  = "ON_DEMAND"
  instance_types = ["t2.medium"]

  depends_on = [ aws_iam_role_policy_attachment.workerroleatachment ]
  tags = merge(var.comman_tags,{
        "Name" = "Eks-Cluster-Nodegroup"
    })
}

resource "aws_iam_role" "workerrole" {
    name = "workerrole"
    assume_role_policy = data.aws_iam_policy_document.worker_assume_role.json
  tags = merge(var.comman_tags,{
        "Name" = "Eks-Cluster-worker-role"
    })
}

resource "aws_iam_role_policy_attachment" "workerroleatachment" {
    for_each = var.worker_role_policy
    role = aws_iam_role.workerrole.name
    policy_arn =  each.value

  
}