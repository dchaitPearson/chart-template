#!/bin/bash
set -e
set -x

CHART_TEMPLATE_LAST_COMMIT=$(git log -n 1 --pretty=oneline)

cat repos.txt | while read repo;
do
  echo -e "\nABOUT TO UPDATE ${repo}"
  git clone git@github.com:pearsontechnology/${repo}.git
  mkdir -p ${repo}/docs || true
  cp travis_rw_key.sh ${repo}/travis
  cp -a ecr ${repo}/travis
  cp -a script ${repo}/travis
  cp ../.gitignore ${repo}
  cp ../Makefile ${repo}
  cp ../.travis.yml ${repo}
  cp version.sh ${repo}/travis
  cp build_testimage.sh ${repo}/travis
  cp start_minikube.sh ${repo}/travis
  cp setup_ssh.sh ${repo}/travis
  cp install_dependencies.sh ${repo}/travis
  cp ../README.md ${repo}
  (cd ${repo} && git status && git add . && git commit . -m "Update from chart-template repo: ${IMAGE_TEMPLATE_LAST_COMMIT}" || true && git push origin master)
  echo -e "FINISHED UPDATING ${repo}\n"
done

rm -fr chart-*
