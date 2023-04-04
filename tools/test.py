#!/usr/bin/python3

import os
import subprocess as sp
import sys
import requests

visited_urls = set()

def fetch_links(url):

    if(not os.path.isdir('_site_')):
        os.mkdir('_site_')
    os.chdir('_site_')

    if(url.endswith('/')):
        current_loc=url
    else:
        current_loc=url+'/'


    if url in visited_urls:
        return

    print(f"Fetching links from {url}...")
    visited_urls.add(url)
    
    response = requests.get(url)
    print(f"Response code: {response.status_code}")

    for link in response.text.split('href="')[1:]:
        href = link.split('"')[0]
        #if href.startswith('http'):
        if href!="../":
            os.mkdir(href)
            fetch_links(current_loc+href)

if __name__ == '__main__':
    fetch_links(sys.argv[1])

