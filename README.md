Terraform Discovery Helper (Powered by [terraforming](https://github.com/dtan4/terraforming))
--------------------------

This small repo was designed to collect the info about the aws assets we have and keep them in source control. + import / re-create with terraform so all our infrastructure is saved as code

There folder aws_assets/<region> in our case `aws_assets/eu-west-1` will have the state of all our assets in `eu-west-1` region by running the following command:

```
export AWS_PROFILE=`default`
terraforming help | grep terraforming | grep -v help | awk '{print "terraforming", $2, "--profile", "${AWS_PROFILE}", ">", $2".tf";}' | bash
```

In the command above I am using my IAM account which is the administrator of the account (or administrator privileges) which enable me to run the `terraforming` gem against our AWS account and provide the info for example running  `terraforming vgw` yields:
```
resource "aws_vpn_gateway" "vgw-xxxxxxx" {
    vpc_id = "vpc-xxxxxxx"
    availability_zone = ""
    tags {
    }
}
```
or `terraforming vpc` yields:
```
resource "aws_vpc" "Tikal-IO-Defaultvpc" {
    cidr_block           = "10.0.0.0/8"
    enable_dns_hostnames = true
    enable_dns_support   = true
    instance_tenancy     = "default"

    tags {
        "Name" = "Tikal IO Default VPC"
        "kubernetes.io/cluster/k8s.example.com" = "shared"
    }
}
```

Which means I can use/reuse these values / states (as terraform calls them) to persist to SCM.
the run.sh file

## Requirements
1. Ruby - you should have ruby already installed on your mac ...
2. `bundler` via `gem install bundler`
3. Running `bundle install` in the root of this directory

## Running "terrforming" for all your regions
./run_all_regions.sh
Once you are done you can basically re-create your infrastructure by using [terraform import](https://www.terraform.io/docs/import/index.html)
