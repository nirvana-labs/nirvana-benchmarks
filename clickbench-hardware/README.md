# ClickBench Hardware Benchmark

This benchmark deploys infrastructure on Nirvana Cloud to run the [ClickBench hardware benchmark](https://github.com/ClickHouse/ClickBench), which measures the raw performance of hardware for database workloads.

## What it Does

This Terraform configuration creates:

- A Nirvana compute VM (configurable CPU, memory, boot disk size, and data disk size)
- Configurable boot volume and data volume
- VPC with subnet
- SSH firewall rule for secure access (configurable IP address)

## Prerequisites

- Terraform >= 1.0
- Nirvana Cloud account with **CLI** configured
- `NIRVANA_LABS_API_KEY` environment variable set with your [API key](https://dashboard.nirvanalabs.io/api-keys))
- SSH key pair (public key) and private key (optional) for SSH access (default: `~/.ssh/id_ed25519`)
- Your IP address for SSH access (default: `0.0.0.0/0`)

## Usage

1. Set your API key:

```bash
export NIRVANA_LABS_API_KEY=your_api_key_here
```

2. Initialize Terraform:

```bash
terraform init
```

3. Create a `terraform.tfvars` file OR set the variables in the command line before running `terraform apply`

```hcl
ssh_public_key   = "ssh-ed25519 AAAA..."  # Your public SSH key
ssh_private_key  = "~/.ssh/id_ed25519"    # Path to your private SSH key
my_ip            = "YOUR_IP/32"           # Your IP for SSH access
```

OR

```bash
terraform plan -var="ssh_public_key=ssh-ed25519 AAAA..." -var="ssh_private_key=~/.ssh/id_ed25519" -var="my_ip=YOUR_IP/32"
```

4. Deploy the infrastructure:

```bash
terraform apply -var="ssh_public_key=ssh-ed25519 AAAA..." -var="ssh_private_key=~/.ssh/id_ed25519" -var="my_ip=YOUR_IP/32"
```

## Configuration

Key variables:

- `ssh_public_key` - Your SSH public key (required)
- `ssh_private_key` - Path to your SSH private key (default: `~/.ssh/id_ed25519`)
- `my_ip` - IP address for SSH access (default: `0.0.0.0/0`)
- `region` - Nirvana region (default: `us-sva-2`)
- `name` - Resource name prefix (default: `clickbench-hardware`)
- `tags` - Tags for all resources (default: `["benchmarking"]`)
- `cpu` - CPU (default: `8`)
- `memory` - Memory (default: `16`)
- `boot_disk_size` - Boot disk size (default: `64`)
- `data_disk_size` - Data disk size (default: `64`)

## Cleanup

```bash
terraform destroy
```

## About ClickBench

ClickBench is a benchmark for analytical databases. The hardware benchmark specifically tests the raw performance of the underlying hardware. Learn more at [ClickBench repository](https://github.com/ClickHouse/ClickBench).
