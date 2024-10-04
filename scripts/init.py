import json
from tabnanny import check
import urllib.request
import sys
import os
import re
import math
import zipfile
from git import Repo
from git import exc
import shutil

def checkRevision(module, ref=None):
        repo = Repo(module["path"])

        if ref:
            module_ref = ref
        elif module["ref"] == None:
            module_ref = repo.active_branch
        else:
            module_ref = module["ref"]

        print(f"Checking out {module['name']}/{module_ref}")
        repo.remote().fetch()
        try:
            repo.git.checkout(module_ref)
        except exc.GitCommandError as e:
            sys.stderr.write(e.stderr)
            sys.exit(1)
        except Exception as e:
            sys.stderr.write(str(e))
            sys.exit(1)

        # check if the module ref is a branch or a specific commit
        for r in repo.remote().refs:
            # if the ref is a branch then pull new changes
            if f"origin/{module_ref}" == r.name:
                repo.remotes.origin.pull()


def download(entry):
    url = entry["url"] if "url" in entry else entry["perOSInfo"][sys.platform]["url"]
    file_name = os.path.split(url)[1]
    file_name = re.sub(r"\?.*$", "", file_name)
    extension = os.path.splitext(file_name)[1]

    if os.path.exists(entry["path"]):
        if extension == ".git":
            checkRevision(entry)
        return

    print("Downloading %s" % file_name)
    if extension == ".git":
        if not os.path.exists(entry['path']):
            Repo.clone_from(url, entry["path"], no_checkout=True)
            repo = Repo(entry["path"])
            repo.remote().fetch()
            repo.git.checkout(entry["ref"])

    else:
        count = 0
        with urllib.request.urlopen(url) as response, open(file_name, "wb") as out_file:
            size = int(response.headers.get("content-length"))
            chunk = 1024
            for i in range(math.ceil(size / chunk)):
                data = response.read(chunk)
                count += 1
                print("\r%i%%" % int(count / (size / chunk) * 100), end="")
                out_file.write(data)

        if extension == ".zip":
            print("\nExtracting...")
            with zipfile.ZipFile(file_name, "r") as zip:
                zip.extractall(entry["path"])


def main():
    with open("scripts/manifest.json", "r") as f:
        manifest = json.load(f)

    for entry in manifest:
        download(entry)

    shutil.copyfile("./scripts/build.py", "../build.py")


if __name__ == "__main__":
    main()
