# map of environment variables to aws keys
/* 
Typically I would either pull these from environment variables
or pass them as sensitive variables
or better, use vault to generate dynamic short-lived credentials 
for the sake of simplicity for this task I have just hardcoded them below
*/
locals {
  aws_keys = {
    dev     = {
      access_key = "12345"
      secret_key = "abcde"
    }
    prod    = {
      access_key = "56789"
      secret_key = "efghi"
    }
    staging = {
      access_key = "101112"
      secret_key = "jklmn"
    }
  }
}