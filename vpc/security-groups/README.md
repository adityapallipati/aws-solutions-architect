# Security Groups

Security Groups (SG) act as stateful virtual firewalls at the instance level.

Security Groups are associated with EC2 instances.

Each SG contains two different sets of rules:

- inbound rules (ingress traffic, entering)
- outbound rules (egress traffic, leaving)

A Security Group (SG) can contain multiple instances in different subnets.

- SGs are not bound by subnets, but are bound by VPC.

## Security Group Rules

- You can choose a preset Traffic Type eg HTTP/S Postgres
- You can choose a custom Protocol (UDP/TCP) and Port Range

Destination type can be a:
- IPv4 CIDR Block
- IPv6 CIDR Block
- Another Security Group
- Managed Prefix List

There are only Allow Rules.
There are no 'Deny' Rules.
All traffic is blocked by default.


## Security Group - Use Case

**Allow IP Addresses**

You can specify the source to be an IPv4 or IPv6 range or a specific IP 

- A specific IP address for IPv4 is /32
- A specific IP address for IPv6 is /128

**Allow To Another Security Group**

You can specify the source to be another security group.

**Nested Security Groups**

An instance can belong to multiple Security Groups, and rules are permissive (instead of restrictive). If you have cne security group with no Allow and add an Allow to another, it will be ALlowed.

## Security Groups CLI Example

Create the security groups

```sh
aws ec2 create-security-group \
--group-name MySecurityGroup \
--description "My Security Group" \
--vpc-d vpc-xxxxxxxx
```

Add rules to the security group

```sh
aws ec2 authorize-security-group-ingress \
--group-id sg-xxxxxxxx \
--protocol tcp \
--port 80 \
--cidr 0.0.0.0/0
```

Associate EC2 instance to the security group

```sh
aws ec2 modify-instance-attribute \
--instance-id i-xxxxxxxxxxxx \
--groups sg-xxxxxxxxxxxx
```

## Security Groups - Limits

- You can have up to 10,000 SGs in a Region (default is 2500)
- You can have 60 inbound rules and 60 outbound rules per security group
- 16 SG per Elastic Network Interface (ENI) (default is 5)

Security Groups do not filter traffic destined to and from the following:

- Amazon Domain Name Services (DNS)
- Amazon Dynamic Host Configuration Protocol (DHCP)
- Amazon EC2 instance metadata
- Amazon ECS task metadata endpoints
- License activation for Windows instances
- Amazon Time Sync Service
- Reserved IP addresses used by the default VPC route

