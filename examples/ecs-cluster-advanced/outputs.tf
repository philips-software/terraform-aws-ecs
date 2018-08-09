output "blog_url" {
  description = "URL to the deployed blog"
  value       = "http://${lower(module.blog.alb_dns_name)}"
}
