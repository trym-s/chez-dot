# Cloud mounts

Mountpoint:

- `google_drive_ravelihan`

Connection:

- Remote: `gcloud:google_drive_ravelihan`
- Type: rclone FUSE mount
- Systemd unit: `mnt-rclone@google-drive-ravelihan.service`
- Mode: read/write
- Cache: VFS write cache, max `2G`, write-back `1s`

This is an online mount. Files are not fully stored locally just because they are listed here; data is fetched or cached as files are accessed.
