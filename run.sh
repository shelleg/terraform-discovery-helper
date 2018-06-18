#!/bin/bash

export AWS_REGION=${AWS_REGION:-eu-west-1}
export AWS_PROFILE=${AWS_PROFILE:-tikal}
mkdir -p ./$AWS_REGION
pushd $AWS_REGION
terraforming help | grep terraforming | grep -v help | awk '{print "terraforming", $2, "--profile", "${AWS_PROFILE}", ">", $2".tf";}' | bash
# find files that only have 1 empty line (likely nothing in AWS)
find . -type f -name '*.tf' | xargs wc -l | grep '1 .' | cut -d 1 -f2 | xargs rm
popd
