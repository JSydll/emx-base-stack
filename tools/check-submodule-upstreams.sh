#!/bin/bash

declare -A SUBMODULES

function check_submodule()
{
    local url="$(git remote -v | head -1 | awk '{ print $2 }')"
    
    local branch="$(git name-rev --name-only HEAD)"
    # Attempt to deduce the branch name from ref/* and tags
    branch="${branch##*/}"
    branch="${branch%%[-~]*}"
    
    local local_head="$(git rev-parse HEAD)"
    local remote_head="$(git ls-remote ${url} | grep "refs/heads/${branch}" | cut -f 1 | head -1)"
    remote_head="${remote_head:-unknown }"

    [[ "${local_head}" != "${remote_head}" ]] && status="DEVIATES" || status="OK"

    SUBMODULES["${url}:${branch}"]="${local_head::8} | ${remote_head::8} [${status}]"
}

submodule_paths=($(git config --file .gitmodules --get-regexp path | awk '{ print $2 }'))
for path in "${submodule_paths[@]}"; do
    pushd "${path}" &>/dev/null || exit
    check_submodule
    popd &>/dev/null || exit
done

printf '%-60s %-10s %s\n' "Submodule" "Local" "Upstream"
for repo in "${!SUBMODULES[@]}"; do
    printf '%-60s %s\n' "[${repo}]" "${SUBMODULES[${repo}]}"
done
