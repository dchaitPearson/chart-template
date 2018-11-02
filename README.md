<h1> Chart-kubedns </h1> 

helm chart for kubedns addon

Chart files should be in templates folder

Testing is done using https://github.com/helm/helm/blob/master/docs/chart_tests.md and need to create a docker image with test scripts included. Sample can be found in tests directory

Building docker image is automated via travis/build_testimage.sh script

Travis workflow work as below

* Copy chart to parent directory (this is done since installing dependencies in travis will copy those to chart package and chartname should be always equal to directory name as well)
* Install dependencies
* Build test image (This will happen only if changes are done to tests directory)
* Start Minikube
* Build helm chart and install
* Testing helm chart

On the master when new PR is merged it will create a new release and also it will push that version to the s3 helm repository

<h2>Building and Testing on Mac</h2>

To build this repo's addon into a local minikube cluster please run (from the root directory of this repo)

./travis/test_local_mac.sh
