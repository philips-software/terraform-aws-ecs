output "blog_url" {
  value = "http://${lower(module.blog.service_url)}"
}
