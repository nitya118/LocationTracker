resource "aws_ecr_repository" "repository_ecr" {
	  name = var.ecr_repo_name
	image_scanning_configuration {
	    scan_on_push = false
	  }

	  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "default_policy" {
  repository = aws_ecr_repository.repository_ecr.name
	

	  policy = <<EOF
	{
	    "rules": [
	        {
	            "rulePriority": 1,
	            "description": "Keep only the last ${var.untagged_images} untagged images.",
	            "selection": {
	                "tagStatus": "untagged",
	                "countType": "imageCountMoreThan",
	                "countNumber": ${var.untagged_images}
	            },
	            "action": {
	                "type": "expire"
	            }
	        }
	    ]
	}
	EOF
	

}



/*
data "aws_caller_identity" "current" {}

resource "null_resource" "docker_packaging" {
		
		provisioner "local-exec" {
		command = <<EOF
		aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com
		EOF
	  }
	
	  provisioner "local-exec" {
		working_dir="${path.module}/../../back-end/"
		command = <<EOF
		docker build -t ${aws_ecr_repository.location-tracker.repository_url}:latest .
		EOF
	  }
	
	provisioner "local-exec" {
		working_dir="${path.module}/../../back-end/"
		command = <<EOF
		docker push ${aws_ecr_repository.location-tracker.repository_url}:latest
		EOF
	  }
		

	  triggers = {
	    "run_at" = timestamp()
	  }
	

	  depends_on = [
	    aws_ecr_repository.location-tracker,
	  ]
}
*/

