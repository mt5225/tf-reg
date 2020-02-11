## update .terraformrc in user home folder
```bash
√ tom % cat ~/.terraformrc
host "tf.example.com" {
  services = {
    "modules.v1" = "https://4y00ig0f3e.execute-api.us-west-2.amazonaws.com/live/modules.v1/"
  }
}
```
The module installer in `terraform init` should then be able to download the module by first requesting its package location from our private registry.

## reg 001
```HCL
aws dynamodb put-item \
  --table-name 'TerraformRegistry-modules' \
  --item '{
    "Id": {"S":"mt5225/aws/dummy"},
    "Version": {"S":"0.1.1"},
    "Source": {"S":"https://tfreg-mt.s3-us-west-2.amazonaws.com/dummy.zip"}
  }'
```



## reg 002
```HCL
aws dynamodb put-item \
  --table-name 'TerraformRegistry-modules' \
  --item '{
    "Id": {"S":"mt5225/sg/aws"},
    "Version": {"S":"0.2.1"},
    "Source": {"S":"s3::https://s3-us-west-2.amazonaws.com/tfreg-mt/mt5225/sg/aws/terraform-aws-sg_v0.2.1.tgz"}
  }'
```

```HCL
aws dynamodb put-item \
  --table-name 'TerraformRegistry-modules' \
  --item '{
    "Id": {"S":"mt5225/sg/aws"},
    "Version": {"S":"0.2.1"},
    "Source": {"S":"https://github.com/mt5225/tf-my-sg/raw/master/terraform-aws-sg_v0.2.1.tgz?archive=tar.gz"}
  }'
```

```HCL works
aws dynamodb put-item \
  --table-name 'TerraformRegistry-modules' \
  --item '{
    "Id": {"S":"mt5225/sg/aws"},
    "Version": {"S":"0.2.1"},
    "Source": {"S":"https://api.github.com/repos/mt5225/terraform-aws-sg/tarball/0.2.1//*?archive=tar.gz"}
  }'
```



## naming
 The naming scheme for objects in this bucket is up to you, but we'd suggest using a systematic scheme like namespace/module/provider/module_provider_version.zip, giving (for example) hashicorp/consul/aws/consul_aws_v0.4.4.zip.

### public register

 * curl -i https://registry.terraform.io/v1/modules/hashicorp/consul/aws/versions


 * curl -i https://registry.terraform.io/v1/modules/hashicorp/consul/aws/0.7.4/download
```bash
HTTP/2 204 
server: Cowboy
cache-control: max-age=604800, stale-if-error=31536000, public
content-encoding: gzip
last-modified: Mon, 20 Jan 2020 14:55:45 GMT
strict-transport-security: max-age=31536000; includeSubDomains; preload
x-terraform-get: https://api.github.com/repos/hashicorp/terraform-aws-consul/tarball/v0.7.4//*?archive=tar.gz
via: 1.1 vegur
via: 1.1 varnish
accept-ranges: bytes
date: Tue, 11 Feb 2020 18:46:57 GMT
via: 1.1 varnish
age: 457232
x-served-by: cache-iad2144-IAD, cache-lax8622-LAX
x-cache: HIT, HIT
x-cache-hits: 1, 1
vary: X-Terraform-Version
```

* curl -i https://registry.terraform.io/v1/modules/clouddrove/ec2/aws/0.12.5/download
```
x-terraform-get: https://api.github.com/repos/clouddrove/terraform-aws-ec2/tarball/0.12.5//*?archive=tar.gz
```

### my resigstry
√ wg % curl -i https://4y00ig0f3e.execute-api.us-west-2.amazonaws.com/live/modules.v1/mt5225/sg/aws/versions

HTTP/2 200 
content-type: application/json
content-length: 109
date: Tue, 11 Feb 2020 19:15:56 GMT
x-amzn-requestid: bcbd560c-55f5-4f68-a702-472efdbd2c7f
x-amz-apigw-id: HvyI4H7HPHcFUlg=
x-amzn-trace-id: Root=1-5e42fd6b-61145150370781902389983d
x-cache: Miss from cloudfront
via: 1.1 adc433645a74a443ef3e8a3436f54242.cloudfront.net (CloudFront)
x-amz-cf-pop: LAX50-C2
x-amz-cf-id: vw3zrcZt-onuo-R8GwdbWB4fWCxws4Cq7N9FjNVfFBAjuGBVMBxL0A==

```JSON
{
  "modules": [
    {
      "versions": [
        {
        "version": "0.2.1"
      }
              ]
    }
  ]
}
```

* curl -i https://4y00ig0f3e.execute-api.us-west-2.amazonaws.com/live/modules.v1/mt5225/sg/aws/0.2.1/download

```
HTTP/2 200 
content-type: application/json
content-length: 122
date: Tue, 11 Feb 2020 19:38:06 GMT
x-amzn-requestid: fc64da86-98c6-4990-b6e0-c8c502ce721f
x-terraform-get: https://github.com/mt5225/tf-my-sg/raw/master/terraform-aws-sg_v0.2.1.tgz
x-amz-apigw-id: Hv1Y1GoxvHcFvtQ=
x-amzn-trace-id: Root=1-5e43029e-5090eec24bdb5e64e3e5e90e
x-cache: Miss from cloudfront
via: 1.1 be269f241b5cfb9cadc0ea3610022758.cloudfront.net (CloudFront)
x-amz-cf-pop: LAX50-C2
x-amz-cf-id: JX_xxBo9XmNB8DSUjbPyV_NYP9KYyUpuOnLJyxiYpdIuJHzmUSrhCg==

{
  "version": "0.2.1",
  "source": "https:\/\/github.com\/mt5225\/tf-my-sg\/raw\/master\/terraform-aws-sg_v0.2.1.tgz",
}
```


 ## modules.json issue
 ```JSON
 {
  "Modules": [
    {
      "Key": "",
      "Source": "",
      "Dir": "."
    },
    {
      "Key": "jerry",
      "Source": "tf.example.com/mt5225/sg/aws",
      "Version": "0.2.1",
      "Dir": ".terraform/modules/jerry/terraform-aws-sg"
    }
  ]
}
 ```

 v.s.

 ```JSON
 {
  "Modules": [
    {
      "Key": "",
      "Source": "",
      "Dir": "."
    },
    {
      "Key": "jerry",
      "Source": "tf.example.com/mt5225/sg/aws",
      "Version": "0.2.1",
      "Dir": ".terraform/modules/jerry"
    }
  ]
}
 ```


 ```
 Initializing modules...
Downloading tf.example.com/mt5225/sg/aws 0.2.1 for jerry...
- jerry in .terraform/modules/jerry   <---  ISSUE
Downloading clouddrove/ec2/aws 0.12.5 for tom...
- tom in .terraform/modules/tom/clouddrove-terraform-aws-ec2-02e5f08
Downloading git::https://github.com/clouddrove/terraform-labels.git?ref=tags/0.12.0 for tom.labels...
- tom.labels in .terraform/modules/tom.labels
```