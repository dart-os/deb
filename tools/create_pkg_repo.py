#!/usr/bin/python3

import os
import subprocess as sp
import sys

def create_pkg_repo_indexes(url):
    if (os.path.isdir("_site_") or os.path.isfile("_site_")):
        os.rmdir("_site_")
    os.mkdir("_site_")
    os.chdir("_site_")
    result = sp.run(["wget", "--recursive", "--no-parent", url])
    result = sp.run(["mkdir -p ../_pages_ && cd ./*/* && find . -type d -exec mkdir -p ../../../_pages_/{} \;"], shell=True, capture_output=True, text=True)
    print(result)
    result = sp.run(["cd ./*/* && find . -type f -name \"index.html\" -exec mv {} ../../../_pages_/{} \;"], shell=True, capture_output=True, text=True)

    print(result)

if(len(sys.argv)<5):
    print(f"""
Format: {sys.argv[0]} <URL> <HOSTING_BRANCH> <COMMITTER_USERNAME> <COMMITER_PASSWORD>""")
    exit()
url=sys.argv[1]
gh_pages_branch=sys.argv[2]
commiter_info=(sys.argv[3],sys.argv[4]) # (commiter_username, commiter_password)

create_pkg_repo_indexes(url)


