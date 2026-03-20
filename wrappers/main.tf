module "wrapper" {
  source = "../"

  for_each = var.items

  name        = try(each.value.name, each.key)
  environment = try(each.value.environment, var.defaults.environment, "")
  label_order = try(each.value.label_order, var.defaults.label_order, ["name", "environment"])
}
