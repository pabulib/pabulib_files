#!/bin/bash
set -e

REPO_DIR="/home/pabulib/files_repo"
SOURCE_DIR="/home/pabulib/pabulib_front/pb_files"
LOG_FILE="/home/pabulib/logs/pb_sync.log"

# Log function
log() {
  echo "[$(date -u +'%Y-%m-%dT%H:%M:%SZ')] $1" >> "$LOG_FILE"
}

log "=== Starting pb_files sync ==="

# Check source exists
if [ ! -d "$SOURCE_DIR" ]; then
  log "ERROR: Source directory $SOURCE_DIR not found"
  exit 1
fi

# Check repo exists
if [ ! -d "$REPO_DIR/.git" ]; then
  log "ERROR: Repo directory $REPO_DIR not initialized"
  exit 1
fi

cd "$REPO_DIR"

# Rsync files from source to pb_files
log "Running rsync from $SOURCE_DIR to $REPO_DIR/pb_files"
rsync -av --delete "$SOURCE_DIR/" pb_files/ >> "$LOG_FILE" 2>&1

# Check for changes, including new untracked files created by rsync
if [ -z "$(git status --porcelain)" ]; then
  log "No changes detected, skipping commit"
  exit 0
fi

# Stage and commit
log "Changes detected, committing..."
git add .
git commit -m "sync: pb files updated $(date -u +'%Y-%m-%dT%H:%M:%SZ')" >> "$LOG_FILE" 2>&1

# Push to origin
log "Pushing to origin/main..."
git push origin main >> "$LOG_FILE" 2>&1

log "=== Sync completed successfully ==="
