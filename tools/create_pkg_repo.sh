#!/bin/sh

create_pkg_static_repo(){

    current_username=$(git config user.name)
    current_usermail=$(git config user.email)


    if [[ -z ${GITHUB_ACTION+x} ]]; then
        git config --global user.name "${3}"
        git config --global user.email "${4}"
    else
        git config --global user.name "GitHub Actions"
        git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"
    fi

    git branch -r | grep -q "origin/${2}"

    if [ $? -ne 0 ]; then
        git checkout --orphan "${2}"
    fi

    rm -rf ./*
    git merge main # Trigger branch

    # rm -rf _site_ _pages_ &&
    if [ ! -d "_pages_" ]; then
        mkdir -p _site_ _pages_ &&
        cd _site_ &&
        wget --recursive --no-parent "${1}" &&
        cd ./*/* &&
        find . -type d -exec mkdir -p ../../../_pages_/{} \; &&
        find . -type f -name "index.html" -exec mv {} ../../../_pages_/{} \; &&
        # code need to provide for packages and sources
        ## change to initial path & Remove _site_ directory
        cd ../../../
    fi

    if [ ! -f "_pages_/index.html" ]; then
       echo "Site Created at $(date -u)" > _pages_/index.html
    fi

    find . | grep -vE '^(\./(\.git.*)?|(\./)?_pages_(/.*)?|(\./)?tools(/.*)?)$' | xargs rm -rf &&
    mv _pages_/* ./ && rm -rf _pages_


    ## Push to gh-pages branch
    git update-ref -d HEAD
    git add .
    if [[-z ${GITHUB_ACTION+x} ]]; then
        git commit -m "[Automation] Updated Static directory listing : ${3}"
    else
        git commit -m "[Automation] Updated Static directory listing No.${GITHUB_RUN_NUMBER}"
    fi


    if $_no_branch; then
        git push -u origin "${2}"
    else
        git push -f
    fi

}


if [ $# -gt 3 ]; then

    url=$1
    hosting_branch=$2
    username=$3
    usermail=$4
    create_pkg_static_repo "${url}" "${hosting_branch}" "${username}" "${usermail}"

else
    echo "Format: ${0} <URL> <HOSTING_BRANCH> <COMMITTER_USERNAME> <COMITTER_EMAIL>"
fi
