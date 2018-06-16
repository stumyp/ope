#!/usr/bin/env bash


usage() {
    
echo "Usage:"
echo "$0 <env> <command> [args]"
echo ""
echo "Where"
echo "    - <env> is item with 'environment' variables section"
echo "    - <command> [args] is command with arguments you want to run"
    
exit 0
}

[ -z "$2" ] && usage

env=$1
shift

# reading config file, extracting settings for specific environment
eval $(
    cat ~/.openvrc |
    jq -r 'select(.env == "'${env}'")|"export domain=\"\(.domain)\" vault_title=\"\(.vault_title)\" item_title=\"\(.item_title)\" vault_uuid=\"\(.vault_uuid)\"  item_uuid=\"\(.item_uuid)\""'
)

# signing in
[ -z "$domain" ] && usage
export OP_SESSION_${domain}=$(op signin ${domain} --output=raw)
# getting vault uuid by title
if [ "$vault_uuid" = "null" ]; then
    export vault_uuid=$(op list vaults | jq -r  '.[]|select(.name == "'${vault_title}'")|.uuid')
fi
# finding item uuid by its title
if [ "$item_uuid" = "null" ]; then
    export item_uuid=$(op list items --vault=${vault_uuid}  | jq -r '.[]|select(.overview.title == "'${item_title}'")|.uuid')
fi
# exporting variables from "environment" section
eval $(op get item ${item_uuid} --vault=${vault_id} | 
    jq -r '.details.sections[]|select(.title == "environment")|.fields[]|"export \(.t)=\(.v)"')

# signing out
op signout

$*

exit $?