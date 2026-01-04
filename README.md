# Dev Environment

A collection of scripts to set up a multi-node development cluster using Multipass VMs across macOS and Linux machines.

## Prerequisites

- **Mac Mini**: macOS with [Homebrew](https://brew.sh/) installed
- **ThinkPad**: Ubuntu Server 24.04

## Quick Start

### 1. Set up the node pools

**On Mac Mini:**
```bash
sudo ./cluster/setup-macmini-nodepool.sh
```

**On ThinkPad:**
```bash
sudo ./cluster/setup-thinkpad-nodepool.sh
```

### 2. Configure the nodes

Follow the instructions in [setup-nodes.md](setup-nodes.md) to complete the cluster configuration.