# This is outdated tool

This tool can only work with 1Password CLI version 1 and does not do all the cool things it could do. I will post an update with the correct version sometime soon.

# Set environment variables with 1Password CLI

## Why

Secrets, password, access keys are not safe to store in plain text on your computer or server. While [1Password](https://1password.com) can help you in many cases, it doesn't have access to control environment variables.

## How

`ope` uses [op](https://support.1password.com/command-line/) to store and retrieve secrets and [jq](https://stedolan.github.io/jq/) to process and extract them. Written in Bash

```
    Usage:
    ope <env> <command> [args]

    Where
      - <env> is item with 'environment' variables section
      - <command> [args] is command with arguments you want to run
```

`ope` requires specially created item which has section named `environment`. In that section you define variables. Each field name and value will be variables name and value. Once all variables are read they are exported to child process where `<command>` is executed.

### Example

![item screenshot](http://com-agilebits-users.s3.amazonaws.com/tim/shots/2018-06-15-23-31-30.png)

```
ope opetest env | grep OP_ENV
Enter the password for user user@domain.com at domain.1password.com:
OP_ENV2=test value 2
OP_ENV1=test value 1
```

### Config file

Config file is simple JSON file located in `$HOME/.operc`

```
{
"domain": "<domain>",
"vault_title": "<v_title>",
"item_title": "<i_title>",
"env": "<env_name>"
}
```

or

```
{
"domain": "<domain>",
"vault_uuid": "xxx",
"item_uuid": "xxx",
"env": "<env_name>"
}
```

Where:

- domain is what you use to `op signin <domain>`
- vault_title is the title of the vault where item is located
- vault_uuid is the UUID of the vault where item is located (overrides vault_title, if both present)
- item_title is title of the item with "environment" section
- item_uuid is UUID of the item with "environment" section (overrides item_title, if both present)
- env is any arbitrary string you want to name your environment

Using titles instead of UUIDs is a little bit slower but has better readability
## TODO

- create items from the tool itself
- ask again for failed password
- use already authenticated session

inspired by [envchain](https://github.com/sorah/envchain)
