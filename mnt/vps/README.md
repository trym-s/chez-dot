# VPS Workspace

Hetzner Cloud VPS icin SSHFS uzerinden yonetilen calisma alani.

SSH alias: `deploy` -> `46.225.167.151`
Tailscale: `100.93.82.82`

## Mount Yapisi

Bu dizin tam bir `deploy:/` root mount degildir. Sadece secili remote path'ler mount edilir.

```
local:~/mnt/vps/   <SSHFS>   remote:
+-- opt/hc/                   /opt/hc/
+-- etc/hc/                   /etc/hc/
+-- var/lib/hc/               /var/lib/hc/
+-- home/deploy/              /home/deploy/
```

| Lokal path | Remote path | Systemd unit | Not |
|---|---|---|---|
| `opt/hc` | `deploy:/opt/hc` | `mnt-sshfs@vps-opt-hc.service` | Proje dosyalari |
| `etc/hc` | `deploy:/etc/hc` | `mnt-sshfs@vps-etc-hc.service` | Config ve secret dosyalari |
| `var/lib/hc` | `deploy:/var/lib/hc` | `mnt-sshfs@vps-var-lib-hc.service` | Kalici veri |
| `home/deploy` | `deploy:/home/deploy` | `mnt-sshfs@vps-home-deploy.service` | Deploy kullanicisinin home dizini |

- Type: SSHFS, read/write
- Dosya duzenleme: lokal mount uzerinden, yani bu dizin altindan
- Komut calistirma: `ssh deploy "..."`
- VPS'e dogrudan SSH shell ile girip dosya duzenlemek yerine mount uzerinden duzenleme yapilir

## VPS Sistemi

| Parametre | Deger |
|---|---|
| OS | Debian GNU/Linux 13 (Trixie) |
| Kernel | 6.12.88+deb13-cloud-amd64 |
| CPU | 2 vCPU |
| RAM | 3.7 GiB |
| Disk | 75 GiB SSD (`/dev/sda1`) |
| Swap | Yok, uretim oncesi eklenmeli |
| Kullanici | `deploy` (uid=1000, sudo, users) |

## Dizin Yapisi

VPS uzerindeki ana dizinler:

```
/opt/hc/current/        proje git reposu (kod, secret yok)
/etc/hc/                config ve secret dosyalari (git disi)
/var/lib/hc/            kalici veri (Caddy TLS sertifikalari vb.)
```

Bu dizinler `deploy:hc` sahipligiyle olusturulmustur.

### `/opt/hc/current/` Proje Yapisi

```
apps/
  api/            FastAPI backend (Python 3.11)
  pdf-worker/     Playwright/Chromium PDF servisi
  web/            React/Vite frontend (Cloudflare Pages'e deploy edilir, VPS'te calismaz)
infra/
  hetzner/        Uretim: docker-compose.yml, Caddyfile, hc.service (systemd)
  local/          Lokal gelistirme infrastrukturu (bu VPS ile ilgisi yok)
  neon/           Neon DB infra tanimlari
  cloudflare/     Cloudflare R2/Pages tanimlari
  gcp/            GCP tanimlari (ilerisi icin)
ops/
  make/           Makefile include'lari
  scripts/        Deploy scriptleri
packages/         Paylasilan Python paketleri (hc-core, hc-db vb.)
docker-compose.yml  SADECE yerel gelistirme (MSSQL+MinIO dahil)
```

`docker-compose.yml` root dosyasi sadece lokal gelistirme icindir. Uretim compose'u `infra/hetzner/docker-compose.yml` olarak ayridir.

## Guvenlik Katmanlari

```
Hetzner Cloud Firewall (dis ag, packet drop)
  -> port 22   : sadece tanimli IP
  -> port 80   : 0.0.0.0/0
  -> port 443  : 0.0.0.0/0
  -> digerleri : KAPALI (8000, 8001, 5432 vb. erisilemiyor)

UFW (host firewall, ikinci katman)
  -> 22, 80, 443 ACCEPT

Docker network hc-internal (172.20.0.0/16)
  -> Caddy      : 80/443 publish edilir
  -> api        : sadece Docker agi icinde (8000)
  -> pdf-worker : sadece Docker agi icinde (8001)
```

Calisan guvenlik servisleri:

| Servis | Durum | Not |
|---|---|---|
| `fail2ban` | Aktif | SSH brute-force korumasi |
| `unattended-upgrades` | Aktif | Otomatik guvenlik yamalari |
| `tailscaled` | Aktif | Ozel erisim icin Tailscale mesh |
| SSH | Aktif | Sadece key auth, root girisi kapali |

## Uretim Mimarisi

Planlanan akis:

```
Internet
  -> 443/80
Caddy container                    TLS terminate, reverse proxy
  -> :8000 (Docker internal)
api container                      FastAPI, Neon Postgres, Cloudflare R2
  -> :8001 (Docker internal)
pdf-worker container               Playwright -> PDF -> R2
```

Dis servisler VPS'te calismaz:

- Database: Neon Postgres
- Object storage: Cloudflare R2
- Frontend: Cloudflare Pages (React/Vite static build)

## Docker Durumu

Docker 26.1.5 kurulu. Su an daemon calismiyor.

Uretim oncesi yapilacaklar:

```bash
ssh deploy "sudo systemctl enable --now docker"
ssh deploy "sudo usermod -aG docker deploy"
ssh deploy "sudo fallocate -l 2G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile && echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab"
```

## Secrets Yonetimi

Secretlar `opt/hc/current/` icine, yani git reposuna, girmez. Sadece `etc/hc/` altinda tutulur:

```
etc/hc/
+-- .env.api            DATABASE_URL, JWT_SECRET, R2 keys, PDF_WORKER_URL
+-- .env.pdf-worker     DATABASE_URL, R2 keys, INTERNAL_API_TOKEN
+-- Caddyfile
```

Docker Compose bu dosyalari `env_file:` direktifiyle okur:

```yaml
env_file:
  - /etc/hc/.env.api
```

## Deploy Akisi

```bash
make hetzner-deploy   # git pull + docker compose up --build -d
make hetzner-logs     # canli log akisi
make hetzner-status   # container durumu
make hetzner-down     # stack'i durdur
```

Makefile target'lari `ops/make/hetzner.mk` icinde tanimlidir.

## Henuz Yapilmamislar

| # | Is | Oncelik |
|---|---|---|
| 2 | Swap dosyasi (2GB) | Yuksek |
| 4 | `infra/local/Caddyfile` yaz | Kritik |
| 5 | `etc/hc/.env.api` ve `.env.pdf-worker` doldur | Kritik |
| 6 | Systemd unit: Docker Compose stack boot'ta baslasin | Yuksek |
| 7 | UFW kurallarini dogrula (`ufw status verbose`) | Orta |
| 8 | Deploy script / Makefile target | Orta |
| 9 | Log retention (`journald` + `docker` log siniri) | Orta |
| 10 | Restore testi | Orta |
