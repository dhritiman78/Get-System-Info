# Device Info Collector

This project collects system information from a device (Windows or Linux/macOS) and uploads it to **Firebase Realtime Database**.

---

## 🚀 Instructions

### 🔹 For Windows Users

1. Open **PowerShell**.
2. Copy and paste the following command and hit Enter:

```powershell
iex (iwr -UseBasicParsing https://raw.githubusercontent.com/dhritiman78/Get-System-Info/main/fetchDetails.ps1)
```

### 🔹 For Linux / macOS Users

1. Open **Terminal**.
2. Copy and paste the following command and hit Enter:

```bash
bash <(curl -s https://raw.githubusercontent.com/dhritiman78/Get-System-Info/main/fetchDetails.sh)
```
This will automatically download and run the Bash script to collect system info and upload it.

## 🔹 View Collected Data

You can view all uploaded device details in the static HTML page:

👉 [View Device Info](https://dhritiman78.github.io/Get-System-Info/)
