output "names" {
  description = "Map of repository names keyed by instance name."
  value       = { for k, v in github_repository.this : k => v.name }
}

output "full_names" {
  description = "Map of repository full names (owner/name) keyed by instance name."
  value       = { for k, v in github_repository.this : k => v.full_name }
}

output "html_urls" {
  description = "Map of repository web URLs keyed by instance name."
  value       = { for k, v in github_repository.this : k => v.html_url }
}

output "ssh_clone_urls" {
  description = "Map of SSH clone URLs keyed by instance name."
  value       = { for k, v in github_repository.this : k => v.ssh_clone_url }
}

output "http_clone_urls" {
  description = "Map of HTTPS clone URLs keyed by instance name."
  value       = { for k, v in github_repository.this : k => v.http_clone_url }
}

output "repo_ids" {
  description = "Map of GitHub repository IDs keyed by instance name."
  value       = { for k, v in github_repository.this : k => v.repo_id }
}

output "node_ids" {
  description = "Map of GraphQL node IDs keyed by instance name."
  value       = { for k, v in github_repository.this : k => v.node_id }
}
