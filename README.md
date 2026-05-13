# Flux-Tweaks

[![Version](https://img.shields.io/badge/version-1.6-blue.svg)](https://github.com/irqshake/Flux-Tweaks)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Android](https://img.shields.io/badge/Android-8.0%2B-brightgreen.svg)](https://www.android.com)

Advanced Android system optimization script for improving UI performance, CPU scheduling, memory management, and battery efficiency. Designed for rooted Android devices with custom kernels.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)

## 🚀 Overview

Flux-Tweaks optimizes Android system performance by:
- Reorganizing process cgroups for better CPU utilization
- Reducing latency for critical UI components
- Optimizing memory management and I/O operations
- Fine-tuning the Linux scheduler for mobile workloads

## ✨ Features

### CPU Control Groups (cgroups)
- Creates dedicated `ux_critical` cgroup for latency-sensitive tasks
- Optimizes task placement across CPU cores
- Moves background tasks to power-efficient cores

### Display Pipeline Optimization
- Prioritizes `surfaceflinger` and display HAL services
- Reduces rendering latency for smoother UI
- Optimizes KGSL (GPU) worker threads

### Memory Management
- Adaptive dirty page caching based on RAM size
- Optimized swap and reclaim behavior
- Memory pressure tuning for different screen resolutions

### Network Tweaks
- Low latency TCP settings
- Disables unnecessary TCP metrics

### I/O Optimization
- Disables disk I/O statistics for each block device
- Reduces overhead on storage operations

## 📱 Requirements

- **Root Access** - Script modifies system cgroups and kernel parameters
- **Android 8.0+** (API 26+)
- **Much Better If You Have Qualcomm Device**

## 🔧 Installation

### Just flash it in Magisk or Kernelsu.
