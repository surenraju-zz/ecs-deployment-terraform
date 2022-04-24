locals {
  app_definitions = merge(
    {
     "NIFI_WEB_HTTP_PORT" = "8080",
    })
}