## Virtual Private Cloud

AWS Virtual Private Cloud (VPC) is a logically isolated virtual network.

AWS VPC resembles a traditional network you'd operate in your own data center.

A VPC provides many different networking components

Virtual Machines eg EC2 is most common reason for using a VPC in AWS

Virtual Network cards eg Elastic Network Interfaces (ENIs) are used within a VPC to attach different compute types eg EC2, Lambda, ECS


**AWS VPC is tightly coupled with AWS EC2, and all VPC CLI commands are under AWS EC2.**

## Core Components of VPC

A VPC is composed of many different networking components.

**Internet Gateway (IGW)**
- A gateway that connects your VPC out to the Internet

**Virtual Private Gateway (VPN Gateway)**
- A gateway that connects your VPC to a private external network

**Route Tables**
- determines where to route traffic within a VPC

**NAT Gateway**
- Allows private instances (eg Virtual Machines) to connect to services outside the VPC (specifically for IPV4)

**Network Access Control Lists (NACLs)**
- Acts as a **stateless** virtual firewall for compute within a VPC
- Operates at the subnet level with allow and deny rules

**Security Groups (SG)**
- Acts as a **stateful** virtual firewall for compute within a VPC
- Operates at the instance level with allow rules

**Public Subnets**
- subnets that allow instances to have public IP addresses

**Private Subnets**
- subnets that disallow instances to have public IP addresses

**VPC Endpoints**
- Privately connect to AWS support services

**VPC Peering**
- Connecting VPCs to other VPCs

**Technically NACLs and SGs are EC2 networking components**

## Key Features

- VPCs are **Region Specific**. They do not span regions.
    - You can use VPC Peering to connect VPCs across-regions
- You can create up to 5 VPC per region (adjustable)
- Every region comes with a default VPC
- You can have 200 subnets per VPC
- Up to 5 IPv4 CIDR Blocks per VPC (adjustable to 50)
- Up to 5 IPv6 CIDR Blocks per VPC (adjustable to 50)
- Most Components Cost nothing:
    - VPCs, Route Tables, NACLs, Internet Gateways, Security Groups and Subnets, VPC Peering
- Some things cost money: eg NAT Gateway
    - VPC Endpoints, VPN Gateway, Customer Gateway
    - IPV4 Addresses, Elastic IPs
- DNS host names (should your instance have domain name addresses)


## Default VPC

AWS has a default VPC in every region so you can immediately deploy instances.

A default VPC is configured by default with the following:

- An IPV4 CIDR block at the address 127.31.0.0/16
- A subnet (size of /20) for each possible Availability Zone (AZ)
- An Internet Gateway (IGW)
- A default Security Group (SG)
- Create a default Network access control list (NACL)
- Default DHCP options set
- A Route Table with a route out to the internet via IGW

You CAN delete a default VPC (shouldn't but the option is available)

AWS recommends the use of the default VPC. *Other cloud service providers may recommend against using the default.

## Create a Default VPC

If you delete the Default VPC (by accident or intentional) and you want to recreate a default VPC. You can run the following AWS CLI command:

```sh
aws ec2 create-default-vpc --region us-east-2
```

Output:

```json
{
    "Vpc": {
        "VpcId": "vpc-3f139646",
        "InstanceTenancy": "default",
        "Tags": [],
        "Ipv6CidrBlockAssociationSet": [],
        "State": "pending",
        "DhcpOptionsId": "dopt-61079b07",
        "CidrBlock": "172.31.0.0/16",
        "IsDefault": true
    }
}
```

- You cannot restore a previous default VPC that you deleted
- You cannot mark an existing non-default VPC as a default VPC
- If you already have a default VPC in the Region, you cannot create another one

## Deleting a VPC

To Delete a VPC you need to delete multiple VPC resources before you can delete:
- Security groups (SGs) and Network ACLs (NACLs)
- Subnets
- Route Tables (RTs)
- Gateway endpoints
- Internet gateways (IGWs)
- Egress-only internet gateways (EO-IGWs)

```sh
aws ec2 delete-security-group --group-id sg-id
aws ec2 delete-network-acl --network-acl-id acl-id
aws ec2 delete-subnet --subnet-id subnet-id
aws ec2 delete-route-table --route-table-id rtb-id
aws ec2 detach-internet-gateway --internet-gateway-id igw-id --vpc-id vpc-id
aws ec2 delete-internet-gateway --internet-gateway-id igw-id
aws ec2 delete-egress-only-internet-gateway --egress-only-internet-gateway-id eigw-id

aws ec2 delete-vpc --vpc-id vpc-id
```

**When you delete a VPC in the AWS Management Console it will automatically attempt to delete the resources for you.**

## Default Route / Catch-All Route

The default route or catch all route represents all possible IP addresses

Think of this route as giving access from anywhere or to the internet without restriction

IPv4 default route
0.0.0.0/0

IPv6 default route
::/0

When we specify 0.0.0.0/0 in our Route Table for IGW we are allowing internet access.

When we specify 0.0.0.0/0 in our Security Group's Inbound Rules, we are allowing all traffic from the internet to access our public resources.

