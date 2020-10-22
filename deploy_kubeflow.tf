resource "null_resource" "deploy_kubeflow" {

  depends_on = [
    module.eks
  ]

  provisioner "local-exec" {
   command = "aws --region ${var.region} eks update-kubeconfig --name ${local.cluster_name}"
  }

  provisioner "local-exec" {
    command = "sh scripts/deploy_kubeflow.sh"
  }
  
  provisioner "local-exec" {
    when    = destroy
    command = "sh scripts/destroy_aws_nlb.sh"
  }
}

