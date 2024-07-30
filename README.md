# terraform_aws_s3_twinkl

Test repo for an interview question. 

- builds out 2 cloudfront web s3 buckets
- builds a long-lived sensitive data s3 bucket
- builds a 48 hour lifecycle bucket

I have added bucket policies as a best practice

### usage

see examples directory 



### notes

https://github.com/hashicorp/terraform/issues/19932 

This issue has been going on a while. Essentially a `for_each` over `provider` as per my initial commit is not yet supported. 

I also wasn't aware that it was legacy practice to set providers when building modules, which prevents the use of `for_each` within a `module` block

In a traditional 3/4 stage environment I would usually have separate terraform workspaces for each environment to ensure the right infrastructure is deployed to the correct environment. 

As I cannot come up with a clever way of looping over environments to determine the accounts without the use of another script I have gone with that method of segregated environment so the example is written to be given one environment at a time now.



Such a script to loop over environments would be super simple like this:


```
#!/bin/bash

environments=("dev" "staging" "prod")

error_log=/tmp/tf_error

for i in ${environments[@]}; do

  init=$(terraform init 2> "${error_log}")
  if [ "$?" != 0 ]; then
    echo "init failed - see "${error_log}"
    exit 1
  fi

  plan=$(terraform plan -var envrionment=${i} 2> "${error_log}")
  if [ "$?" != 0 ]; then
    echo "plan failed - see "${error_log}"
    exit 1
  fi

  apply=$(terraform apply -var envrionment=${i} 2> "${error_log}")
  if [ "$?" != 0 ]; then
    echo "apply failed - see "${error_log}"
    exit 1
  fi
done
```

though I personally do not like this solution as it does not seem intuitive to me.


Other changes that I had to make from the inital commit just for testing purposes include:

- changing iam role to iam group since I hit the rate limit for identity center whilst testing something else
- lowercase [A,B,C,D] for the bucket names 