
# A dummy resource to prove the pipeline works for the assignment
resource "local_file" "environment_proof" {
  content  = "Infrastructure deployed successfully by GitLab CI/CD"
  filename = "${path.module}/deployment-proof.txt"
} 