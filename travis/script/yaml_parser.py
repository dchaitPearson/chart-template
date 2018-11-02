#!/usr/bin/env python
# WARNING: This file is deployed from template. Raise a pull request against chart-template to change.

from __future__ import print_function
import sys, yaml

def yaml_to_hash(filename):
    with open(filename,'r') as f:
        try:
            return yaml.load(f)
        except yaml.YAMLError as e:
            print(e)
    return {}


if __name__ == '__main__':
    filename = sys.argv[1]
    grepValue = sys.argv[2]

    contents = yaml_to_hash(filename)
    print(contents[grepValue])