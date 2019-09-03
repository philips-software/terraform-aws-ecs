output "blog_url" {
  description = "URL to the deployed blog"
  value       = lower(module.blog.service_url)
}

