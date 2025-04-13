# 🚀 Full Guide: Deploy phpIPAM in a Proxmox LXC Container (Debian 12)

This guide walks you through **deploying phpIPAM** in a **Debian 12 LXC container** under **Proxmox VE**, with:

✅ LXC container creation  
✅ phpIPAM installation  
✅ IP discovery tools  
✅ Web UI served from `/`  
✅ MySQL database setup  
✅ Ready-to-go installer script

---

## 🧱 Step 1: Create LXC Container in Proxmox

### 📌 Requirements
- Proxmox VE installed
- Debian 12 LXC template downloaded (from Proxmox Templates)
- 512MB+ RAM, 1 CPU, 4–8GB storage
- Internet access inside the container

---

### 🧰 Create the LXC Container

1. Open **Proxmox Web UI**
2. Click **Create CT**
3. Fill in:
   - **Hostname**: `phpipam`
   - **Password**: (your choice)
   - **Template**: Select `debian-12-standard` from local storage
4. **Disk**: Minimum 4–8GB
5. **CPU**: 1 core
6. **Memory**: 512–1024MB
7. **Network**: DHCP or static (recommended to reserve IP in your router)

---

### ⚙️ Features Tab

Make sure to:
- ✅ Enable **Nesting**
- 🔒 Ensure **Unprivileged container** is checked

Then click **Finish** to create the container.

---

## ⚙️ Step 2: Run the Auto-Install Script

### SSH into the LXC container:
```bash
pct exec <CTID> -- /bin/bash
```
Or use your SSH client if configured.

### Download and run the script:
```bash
wget https://your-download-url/install_phpipam.sh
chmod +x install_phpipam.sh
sudo ./install_phpipam.sh
```

> Replace `<your-download-url>` with the real URL if hosting externally,
> or copy the file from this package manually.

---

## 🌐 Step 3: Complete Web-Based Setup

1. Open `http://<LXC-IP>` in your browser
2. Select **"New phpIPAM installation"**
3. On the **Database Setup** screen:
   - 🔲 Uncheck **Drop existing database**
   - 🔲 Uncheck **Create new database**
   - 🔲 Uncheck **Set permissions to tables**
4. Use these credentials:

| Field             | Value           |
|------------------|-----------------|
| DB Host          | `localhost`     |
| DB Name          | `phpipam`       |
| DB User          | `phpipam`       |
| DB Password      | `phpipam_pass`  |

5. Click "Install phpIPAM database"
6. Create your admin user and start using the app!

---

## 📁 Included Files

- [`install_phpipam.sh`](./install_phpipam.sh) – Auto-installer script

---

## 🧼 Optional Cleanup

After installation, you can convert this container into a **Proxmox template**:

```bash
pct stop <CTID>
mv /var/lib/lxc/<CTID> /var/lib/lxc/phpipam-template
pct template phpipam-template
```

---

## 📦 Backups and Maintenance

You may wish to set up weekly backups of:

- `/var/www/html` (phpIPAM files)
- MySQL database (`phpipam`)

Let me know if you want an auto-backup script added to this guide!
