# ~/mnt map

This directory is the local entry point for remote and synced storage on every client.

- `cloud/google_drive_ravelihan`: online rclone mount for `gcloud:google_drive_ravelihan`.
- `personal/shared_local`: real local offline directory bisynced with `gcloud:Cloud`.
- `ssh/x230/home`: SSHFS mount for `x230:/home/vlhnx230`; enabled on non-x230 clients.
- `ssh/ac/home`: SSHFS mount for `ac:/home/vlhnac`.
- `ssh/envy/home`: SSHFS mount for `envy:/home/vlhnhp`.
- `vps/home/deploy`: SSHFS mount for `deploy:/home/deploy`.
- `vps/etc/hc`: SSHFS mount for `deploy:/etc/hc`.
- `vps/opt/hc`: SSHFS mount for `deploy:/opt/hc`.
- `vps/var/lib/hc`: SSHFS mount for `deploy:/var/lib/hc`.

README files are intentionally placed outside mount contents.
