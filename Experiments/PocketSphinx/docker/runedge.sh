docker run --rm -v ~/fogbench/configs:/mnt/configs -v ~/fogbench/assets:/mnt/assets -v ~/fogbench/results:/mnt/results -v /root/.aws:/root/.aws --name psphinx psphinx ../scripts/execute.sh