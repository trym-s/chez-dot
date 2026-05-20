# ~/mnt infra

`~/mnt` is the shared remote-filesystem surface for every client managed by this chezmoi repo. The goal is that `x230`, `ac`, `envy`/`vlhnhp`, and future clients see the same local layout under their own home directory.

## Layout

- `~/mnt/ssh/x230/home` mounts `x230:/home/vlhnx230` on non-x230 clients.
- `~/mnt/ssh/ac/home` mounts `ac:/home/vlhnac` on non-ac clients.
- `~/mnt/ssh/envy/home` mounts `envy:/home/vlhnhp` on non-envy clients.
- `~/mnt/cloud/google_drive_ravelihan` mounts `gcloud:google_drive_ravelihan` online with rclone.
- `~/mnt/personal/shared_local` is the real local offline bisync directory for `gcloud:Cloud`.
- `~/mnt/vps/home/deploy` mounts `deploy:/home/deploy`.
- `~/mnt/vps/etc/hc` mounts `deploy:/etc/hc`.
- `~/mnt/vps/opt/hc` mounts `deploy:/opt/hc`.
- `~/mnt/vps/var/lib/hc` mounts `deploy:/var/lib/hc`.
- `~/mnt/work` and `~/mnt/personal` are top-level organization areas.

README files live in parent wrapper directories, not inside mounted remote content.

## Systemd Model

Mounts use two template units and per-instance environment files:

- `mnt-sshfs@.service` reads `%h/.config/mnt/sshfs/%i.env`.
- `mnt-rclone@.service` reads `%h/.config/mnt/rclone/%i.env`.

This avoids one service file per host and avoids path-named `.mount` units. `.mount` unit names encode absolute paths, so they are not portable across usernames.

Peer mounts are selected by `host_profile` in `run_onchange_after_mnt-systemd.sh.tmpl`:

- `x230` enables `ac-home` and `envy-home`.
- `ac` enables `x230-home` and `envy-home`.
- `vlhnhp`/`envy` enables `x230-home` and `ac-home`.
- Unknown profiles enable all peer mounts.

VPS and cloud mounts are external services, not peer clients, so they are enabled on every profile.

## Instances

SSHFS instances:

- `mnt-sshfs@x230-home.service`
- `mnt-sshfs@ac-home.service`
- `mnt-sshfs@envy-home.service`
- `mnt-sshfs@vps-home-deploy.service`
- `mnt-sshfs@vps-etc-hc.service`
- `mnt-sshfs@vps-opt-hc.service`
- `mnt-sshfs@vps-var-lib-hc.service`

Rclone instances:

- `mnt-rclone@google-drive-ravelihan.service`

Bisync:

- `rclone-gcloud-bisync-shared-local.timer`

## Requirements

Chezmoi manages the layout and systemd units. Credentials are deliberately local prerequisites:

- Packages: `sshfs`, `fuse3`, `rclone`, `systemd`.
- SSH aliases for other peer clients, not necessarily self.
- SSH alias `deploy` for the VPS.
- Rclone remote `gcloud` configured locally.

For example, `ac` does not need a working `Host ac` entry because the `ac-home` instance is not enabled on `ac`. It should have `Host x230`, `Host envy`, and `Host deploy` if those mounts are expected to work there.

## Operations

Chezmoi applies and enables the units through `run_onchange_after_mnt-systemd.sh.tmpl`.

Manual reload and enable example for `x230`:

```sh
systemctl --user daemon-reload
systemctl --user enable --now mnt-rclone@google-drive-ravelihan.service mnt-sshfs@ac-home.service mnt-sshfs@envy-home.service mnt-sshfs@vps-home-deploy.service mnt-sshfs@vps-etc-hc.service mnt-sshfs@vps-opt-hc.service mnt-sshfs@vps-var-lib-hc.service rclone-gcloud-bisync-shared-local.timer
```

If a client is offline or a credential is missing, start failures are expected until the prerequisite is fixed:

```sh
systemctl --user status mnt-sshfs@envy-home.service
systemctl --user start mnt-sshfs@envy-home.service
```

Check:

```sh
findmnt -R ~/mnt
mount | rg "$HOME/mnt"
ls ~/mnt/cloud/google_drive_ravelihan
ls ~/mnt/vps/home/deploy
ls ~/mnt/vps/etc/hc
ls ~/mnt/vps/opt/hc
ls ~/mnt/vps/var/lib/hc
ls ~/mnt/ssh/x230/home
ls ~/mnt/ssh/envy/home
ls ~/mnt/ssh/ac/home
```
