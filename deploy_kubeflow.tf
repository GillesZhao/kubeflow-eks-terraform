resource "null_resource" "deploy_kubeflow" {

  depends_on = [
    module.eks
  ]

  provisioner "local-exec" {
   command = "aws --region ${var.region} eks update-kubeconfig --name ${local.cluster_name}"
  }

  provisioner "local-exec" {
    command = "sh deploy_kubeflow.sh"
  }

}

