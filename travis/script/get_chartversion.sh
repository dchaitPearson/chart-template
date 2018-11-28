#!/usr/bin/env bash
# WARNING: This file is deployed from template. Raise a pull request against chart-template to change.

folder_path=$(pwd | xargs basename)
folder_name=${folder_path:6}
name=$(travis/script/yaml_parser.py $folder_name/Chart.yaml version)
echo -n $name