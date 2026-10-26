output "full_names" {
  description = "Full names of the managed repositories."
  value       = module.repositories.full_names
}

output "html_urls" {
  description = "Web URLs of the managed repositories."
  value       = module.repositories.html_urls
}
