# Personal local storage

Local directory:

- `shared_local`

Connection:

- Sync pair: `~/mnt/personal/shared_local` <-> `gcloud:Cloud`
- Type: real local directory plus periodic rclone bisync
- Systemd timer: `rclone-gcloud-bisync-shared-local.timer`
- Interval: every 2 minutes after boot/start

This directory is intentionally local and offline-accessible. It is not a symlink and it is not a FUSE mount.
