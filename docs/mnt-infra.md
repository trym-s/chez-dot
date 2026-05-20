# ~/mnt infra

`~/mnt` is the primary surface for remote filesystems on `x230`.

## Layout

- `~/mnt/ssh/envy/home` mounts `envy:/home/vlhnhp`.
- `~/mnt/ssh/ac/home` mounts `ac:/home/vlhnac`.
- `~/mnt/cloud/gdrive` mounts `gcloud:` online with rclone.
- `~/mnt/personal/cloud` points at `~/mnt/cloud/gdrive/Cloud`.
- `~/mnt/vps` is the VPS/deploy surface when needed.
- `~/mnt/work` and `~/mnt/personal` are top-level organization areas.

`~/Cloud` is no longer the active sync surface. It is moved to a hidden rollback directory when decommissioned.

## Systemd

The mounts are user `.mount` units enabled in `default.target`. User `.automount` units were avoided because this host's user manager cannot allocate the needed autofs resources.

SSHFS options:

```text
rw,_netdev,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3
```

Rclone mount options:

```text
rw,_netdev,vfs-cache-mode=writes,vfs-cache-max-size=2G,vfs-write-back=1s,dir-cache-time=30s,poll-interval=15s
```

Rclone writes are live mount writes, not bisync. With VFS write caching they are uploaded after the file is closed and the 1 second write-back window passes. SSHFS writes go directly to the remote filesystem.

## Operations

Reload and enable:

```sh
systemctl --user daemon-reload
systemctl --user enable --now home-vlhnx230-mnt-ssh-ac-home.mount home-vlhnx230-mnt-cloud-gdrive.mount
```

`envy` can stay disabled while the machine is offline:

```sh
systemctl --user disable --now home-vlhnx230-mnt-ssh-envy-home.mount
```

The old `rclone-gcloud-bisync.*` units are disabled and archived. Cloud changes now go through the live rclone mount, not a periodic bisync job.

Rollback for the old local cloud copy is a directory move: move the saved rollback directory back to `~/Cloud`.

Check:

```sh
findmnt -R ~/mnt
mount | rg '/home/vlhnx230/mnt'
ls ~/mnt/cloud/gdrive
ls ~/mnt/ssh/deploy/home
ls ~/mnt/ssh/envy/home
ls ~/mnt/ssh/ac/home
```
