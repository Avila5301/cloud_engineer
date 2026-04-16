# Stage 1 — Exercise: Complete the CloudFormation Template

## Goal

Complete `vpc-stack-starter.yaml` by writing all the resource blocks in the `Resources:` section. The Parameters and Outputs sections are already written — read them carefully before you start, because they tell you exactly what your resources should be named and what values they should use.

## Rules

- Do not look at the solution folder
- Use the [AWS CloudFormation Resource Reference](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html) when you get stuck
- Use `cfn-lint` to validate your template syntax before deploying

Install cfn-lint:
```bash
pip install cfn-lint
cfn-lint vpc-stack-starter.yaml
```

## Resources to Write

Fill in the Resources section with these CloudFormation resource types:

| Logical ID | Type | Notes |
|---|---|---|
| `VPC` | `AWS::EC2::VPC` | Use `!Ref VpcCidr`, enable DNS |
| `PublicSubnet1` | `AWS::EC2::Subnet` | AZ index 0, MapPublicIpOnLaunch: true |
| `PublicSubnet2` | `AWS::EC2::Subnet` | AZ index 1, MapPublicIpOnLaunch: true |
| `PrivateSubnet1` | `AWS::EC2::Subnet` | AZ index 0, no public IP |
| `PrivateSubnet2` | `AWS::EC2::Subnet` | AZ index 1, no public IP |
| `InternetGateway` | `AWS::EC2::InternetGateway` | |
| `VPCGatewayAttachment` | `AWS::EC2::VPCGatewayAttachment` | Attaches IGW to VPC |
| `NatEIP` | `AWS::EC2::EIP` | Domain: vpc, DependsOn VPCGatewayAttachment |
| `NatGateway` | `AWS::EC2::NatGateway` | In PublicSubnet1 — not private |
| `PublicRouteTable` | `AWS::EC2::RouteTable` | |
| `PublicRoute` | `AWS::EC2::Route` | 0.0.0.0/0 → IGW, DependsOn VPCGatewayAttachment |
| `PublicSubnet1RouteTableAssoc` | `AWS::EC2::SubnetRouteTableAssociation` | |
| `PublicSubnet2RouteTableAssoc` | `AWS::EC2::SubnetRouteTableAssociation` | |
| `PrivateRouteTable` | `AWS::EC2::RouteTable` | |
| `PrivateRoute` | `AWS::EC2::Route` | 0.0.0.0/0 → NAT Gateway |
| `PrivateSubnet1RouteTableAssoc` | `AWS::EC2::SubnetRouteTableAssociation` | |
| `PrivateSubnet2RouteTableAssoc` | `AWS::EC2::SubnetRouteTableAssociation` | |
| `BastionSecurityGroup` | `AWS::EC2::SecurityGroup` | SSH from AdminIpCidr only |
| `PrivateInstanceSecurityGroup` | `AWS::EC2::SecurityGroup` | SSH from BastionSG only |
| `BastionHost` | `AWS::EC2::Instance` | In PublicSubnet1, BastionSG |

## Helpful CloudFormation Functions

| Function | Use |
|---|---|
| `!Ref ResourceName` | Reference another resource's ID or a parameter value |
| `!GetAtt Resource.Attribute` | Get a specific attribute (e.g., `!GetAtt NatEIP.AllocationId`) |
| `!Select [0, !GetAZs '']` | Get the first AZ in the current region |
| `!Sub "${ProjectName}-vpc"` | String interpolation with a parameter |

## AZ Selection

CloudFormation can automatically pick AZs for your region:
```yaml
AvailabilityZone: !Select [0, !GetAZs '']   # First AZ
AvailabilityZone: !Select [1, !GetAZs '']   # Second AZ
```

## Validate Before Deploying

```bash
cfn-lint vpc-stack-starter.yaml
aws cloudformation validate-template --template-body file://vpc-stack-starter.yaml
```
