locals {

  # Flatten Function
  # https://www.terraform.io/docs/language/functions/flatten.html

  # For Expressions
  # https://www.terraform.io/docs/language/expressions/for.html

  # This code iterates over the local.identity_groups map and extracts the owners from each group.
  # It creates a new object for each owner, combining the group key and owner value.
  # Finally, it flattens the list of objects into a single flat list and assigns it to the owners variable.

  owners = flatten([

    for identity_group_key, group in local.identity_groups : [
      for owner in group.owners : {
        group = identity_group_key
        owner = owner
      }
    ]
  ])

  environments = flatten([

    for folder_system_key, system in local.folder_systems : [
      for environment in system.environments : {
        system      = folder_system_key
        environment = environment
      }
    ]
  ])

  identity_groups = {
    "my-group" = {
      description  = "value"
      display_name = "value"
      managers     = ["managers"]
      members      = ["members"]
      owners       = ["sue", "frank"]
    }
  }

  folder_systems = {
    system_1 = {
      display_name = "My Folder"
      environments = ["Sandbox", "Non-Production", "Production"]
      parent       = "parent_folder"
    }
  }
}


# Output Values
# https://www.terraform.io/docs/language/values/outputs.html

output "identity_groups_owners" {
  value = { for user in local.owners : "${user.group}.${user.owner}" => user }
}

output "owners" {
  value = local.owners
}

output "environments" {
  value = local.environments
}

output "folder_environments" {
  value = { for k, v in local.environments : k => v }
}
