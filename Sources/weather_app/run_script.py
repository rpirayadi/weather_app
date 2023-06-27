import os
import argparse
from os import listdir
from os.path import join

def join_files(path, main):
    all_text = ""

    for file in [join(path, f) for f in listdir(path)] + [main]:
        with open(file, "r") as f:
            all_text += f.read() + "\n\n"

    return all_text

def exec(all_text):
    with open("temp.swift", "w") as f:
        f.write(all_text)
 
    os.system('swift temp.swift')


def main():
    parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument(
        "path", type=str, help="list of files to run"
    )

    parser.add_argument(
        "main", type=str, help="list of files to run"
    ) 

    args = parser.parse_args()
    all_text = join_files(args.path, args.main)
    exec(all_text)

main()