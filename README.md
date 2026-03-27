# pabulib_files

Pabulib PB dataset files — current snapshots and full change history of all .pb files.

## Overview

This repository maintains:
- Current state of all active `.pb` files in `pb_files/`
- Complete Git history tracking all changes, updates, and deletions
- Hourly synchronization with the live application data

## Structure

```
pb_files/          # Current set of all active .pb files
README.md          # This file
```

## Synchronization

Files are synced from the live application every hour via automated rsync + git workflow. Each sync that detects changes creates a new commit with a timestamp.

## Usage

Browse the current files or use Git history to track changes:

```bash
# View history of a specific file
git log --all -- pb_files/some_file.pb

# Retrieve a deleted file from history
git show <commit-hash>:pb_files/some_file.pb > recovered.pb
```
