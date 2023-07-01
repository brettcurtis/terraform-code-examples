# Input Variables
# https://www.terraform.io/docs/language/values/variables.html#variable-values

variable "admins" {
  type = list(string)
  default = [
    "tony",
    "sue"
  ]
}

variable "members" {
  type = list(string)
  default = [
    "frank",
    "bob"
  ]
}

# Local Values
# https://www.terraform.io/docs/language/values/locals.html

locals {

  # For Expressions
  # https://www.terraform.io/docs/language/expressions/for.html

  # Iterate over the elements of the var.admins variable and create a new map where each element becomes
  # a key in the map with the value "admin"

  admins = {
    for i in var.admins : i => "admin"
  }

  # Iterate over the key-value pairs of local.repositories and create a new map branch_protection that includes
  # only those key-value pairs where the value's enable_branch_protection property is truthy.
  # It allows you to filter and create a subset of the original map based on the condition specified.

  branch_protection = {
    for k, v in local.repositories : k => v if v.enable_branch_protection
  }

  members = {
    for i in var.members : i => "member"
  }

  # Merge Function
  # https://www.terraform.io/docs/language/functions/merge.html

  # Merge the contents of local.admins and local.members maps into a new map called users,
  # combining the key-value pairs from both maps.

  users = merge(local.admins, local.members)

  repositories = {
    "github-test-enable-branch" = {
      description              = "Test Repository"
      enable_branch_protection = true
      topics                   = ["testing"]
    }

    "github-test-disable-branch" = {
      description              = "Test Repository"
      enable_branch_protection = false
      topics                   = ["testing"]
    }
  }

}

# Output Values
# https://www.terraform.io/docs/language/values/outputs.html

output "admins" {
  value = local.admins
}

output "members" {
  value = local.members
}

output "users" {
  value = local.users
}

output "branch_protection" {
  value = local.branch_protection
}
