output "blog_url" {
  value = "${lower(module.blog.service_url)}"
}
