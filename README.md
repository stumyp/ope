# Set environment variables with 1Password CLI

## Why

Secrets, password, access keys are not safe to store in plain text on your computer or server. While [1Password](https://1password.com) can help you in many cases, it doesn't have access to control environment variables.

## How

`openv` uses [op](https://support.1password.com/command-line/) to store and retrieve secrets and [jq](https://stedolan.github.io/jq/) to process and extract them. Written in Bash

inspired by [envchain](https://github.com/sorah/envchain)