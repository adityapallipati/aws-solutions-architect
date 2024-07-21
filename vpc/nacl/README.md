## NACL

```sh
aws ec2 create-network-acl --vpc-id vpc-0dc53debcc776b338 --region us-east-2
```

## Get the latest AML2 AMI

```sh
aws ec2 describe-images \
--owners amazon \
--filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" "Name=state,Values=available" \
--query "Images[?starts_with(Name, 'amzn2')]|sort_by(@, &CreationDate)[-1].ImageId" \
--region us-east-2 \
--output text
```
