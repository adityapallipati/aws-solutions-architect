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
