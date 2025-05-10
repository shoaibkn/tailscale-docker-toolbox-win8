

---

# 🐳 tailscale-docker-toolbox-windows8

Run [Tailscale](https://tailscale.com) in a Docker container using **Docker Toolbox** on **Windows 8/8.1**, with automatic start and authentication handling.

> ⚠️ Docker Toolbox is deprecated. This project is a workaround for older systems that cannot run Docker Desktop or WSL2.

---

## 🧰 Requirements

- **Windows 8/8.1**
- [Docker Toolbox](https://github.com/docker/toolbox/releases)
- [Tailscale account](https://tailscale.com) and an [auth key](https://login.tailscale.com/admin/settings/keys)

---

## 🚀 Setup Instructions

### 1. Clone this repo and build the Docker image

```bash
git clone https://github.com/shoaibkn/tailscale-docker-toolbox-win8.git
cd tailscale-docker-toolbox-win8
docker build -t my-tailscale .
```

### 2. Run Tailscale with persistent state

```bash
docker run -d --cap-add=NET_ADMIN ^
  -v tailscale-state:/var/lib/tailscale ^
  --name tailscale ^
  my-tailscale tailscaled --tun=userspace-networking
```

### 3. Authenticate with Tailscale

```bash
docker exec -it tailscale tailscale up --authkey=tskey-xxxxxxxxxxxxxxxx
```

### 4. Enable auto-start on reboot

- Edit `start_tailscale.bat` and set your auth key:

```bat
set AUTHKEY=tskey-xxxxxxxxxxxxxxxx
```

- Copy the file to your Windows Startup folder:

  ```shell
  shell:startup
  ```

---

## 📂 Files in This Repo

```
.
├── Dockerfile              # Lightweight Debian image with Tailscale
├── start_tailscale.bat     # Startup script for Windows
└── README.md               # You're reading it!
```

---

## 🧠 What `start_tailscale.bat` Does

- Starts the Docker VM (`default`)
- Sets Docker environment
- Starts the Tailscale container
- Checks Tailscale status
- Re-authenticates with your auth key if necessary
- Alerts you if your auth key is expired

---

## ✅ Features

- Runs in Docker Toolbox (VirtualBox)
- Persists Tailscale state across reboots
- Works with `--tun=userspace-networking`
- Warns if your auth key is expired

---

## ⚠️ Limitations

- **No host networking**: Docker Toolbox can’t expose Tailscale ports directly to Windows host.
- **Slower performance** due to userspace networking.
- **Manual key rotation** needed when keys expire.

---

## 🙏 Credits

- [Tailscale](https://tailscale.com)
- [Docker Toolbox (Legacy)](https://github.com/docker/toolbox)

---
