# Set environment variables with 1Password CLI

## Why

Secrets, password, access keys are not safe to store in plain text on your computer or server. While [1Password](https://1password.com) can help you in many cases, it doesn't have access to control environment variables.

## How

`openv` uses [op](https://support.1password.com/command-line/) to store and retrieve secrets and [jq](https://stedolan.github.io/jq/) to process and extract them. Written in Bash

```
    Usage:
    openv <env> <command> [args]

    Where
      - <env> is item with 'environment' variables section
      - <command> [args] is command with arguments you want to run
```

`openv` requires specially created item which has section named `environment`. In that section you define variables. Each field name and value will be variables name and value. Once all variables are read they are exported to child process where `<command>` is executed.

### Config file

Config file is simple JSON file located in `$HOME/.openvrc`

```
{
"domain": "<domain>",
"vault_title": "<v_title>",
"item_title": "<i_title>",
"env": "<env_name>"
}
```

Where:

- domain is what you use to `op signin <domain>`
- vault_title is the title of the vault where item is located
- item_title is title of the item with "environment" section
- env is any arbitrary string you want to name your environment

## TODO

- create items from the tool itself
- ask again for failed password
- use already authenticated session

inspired by [envchain](https://github.com/sorah/envchain)
