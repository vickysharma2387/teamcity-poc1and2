output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "instance_id" {
  value = aws_launch_template.ecs_launch_template.id
}
