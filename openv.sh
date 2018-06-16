#!/usr/bin/env bash


function usage() {
    echo << EOH 
    Usage:
    $0 <env> <command> [args]

    Where 
      - <env> is login item with 'environment' variables section
      - <command> [args] is command with arguments you want to run 
    
EOH
}

env=$1
shift

# reading config file, extracting settings for specific environment
eval $(
    cat ~/.openvrc |
    jq -r 'select(.env == "'${env}'")|"export domain=\"\(.domain)\" vault_title=\"\(.vault_title)\" item_title=\"\(.item_title)\""'
)

# signing in
export OP_SESSION_${domain}=$(op signin ${domain} --output=raw)
# getting vault uuid by title
export vault_uuid=$(op list vaults | jq -r  '.[]|select(.name == "'${vault_title}'")|.uuid')
# finding item uuid by its title
export item_uuid=$(op list items --vault=${vault_uuid}  | jq -r '.[]|select(.overview.title == "'${item_title}'")|.uuid')

# exporting variables from "environment" section
eval $(op get item ${item_uuid} --vault=${vault_id} | 
    jq -r '.details.sections[]|select(.title == "environment")|.fields[]|"export \(.t)=\(.v)"')

# signing out
op signout

$*

exit $?