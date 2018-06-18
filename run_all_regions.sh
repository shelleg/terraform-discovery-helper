#!/bin/bash

export AWS_REGION=${AWS_REGION:-eu-west-1}
export AWS_PROFILE=${AWS_PROFILE:-tikal}
for region in `aws ec2 describe-regions --output text | cut -f3`; do
  mkdir -p ./aws_assets/$region
  pushd ./aws_assets/$region
  terraforming help | grep terraforming | grep -v help | grep -v iam | awk '{print "terraforming", $2, "--profile", "${AWS_PROFILE}", ">", $2".tf";}' | bash
  # find files that only have 1 empty line (likely nothing in AWS)
  find . -type f -name '*.tf' | xargs wc -l | grep '1 .' | cut -d 1 -f2 | xargs rm
  popd
done

# IAM is global ... don't want duplicates
mkdir -p ./aws_assets/global
pushd ./aws_assets/global
terraforming help | grep terraforming | grep -v help | grep iam | awk '{print "terraforming", $2, "--profile", "${AWS_PROFILE}", ">", $2".tf";}' | bash
popd
