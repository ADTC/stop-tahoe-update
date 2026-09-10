# 🛑 Stop Tahoe Update

> [!WARNING]
> **This project’s deferral profile no longer reliably hides Tahoe on recent Sequoia versions.**
>
> Starting with macOS Sequoia **15.7.5**, Apple stopped honoring separate major vs. minor update deferrals. The profile may still install, but Tahoe can reappear in Software Update. Discussion and workarounds: [issue #19](https://github.com/travisvn/stop-tahoe-update/issues/19).
>
> If you need something that still works on current Sequoia, these unofficial alternatives are what people have been using. They are **not** Apple-supported — read each project before you use it.
>
> - **[noTahoe](https://github.com/ADTC/noTahoe)** — hides Tahoe with Apple’s MobileAsset audience setting, while keeping native XProtect/MRT security updates.
> - **[Tanoe](https://github.com/DrDonk/Tanoe)** — blocks `gdmf.apple.com` so OS updates (Tahoe **and** Sequoia point releases) stop appearing. Safari and similar updates still work; turn the block off (or use Tanoe’s installer helper) when you want a Sequoia 15.x update.

_A community-led effort to block unwanted macOS upgrades (e.g. Sequoia → Tahoe)._

[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-blue.svg)](.github/CONTRIBUTING.md)
[![GitHub Discussions](https://img.shields.io/github/discussions/travisvn/stop-tahoe-update?logo=github)](https://github.com/travisvn/stop-tahoe-update/discussions)
[![Build & Validate](https://github.com/travisvn/stop-tahoe-update/actions/workflows/validate.yml/badge.svg)](https://github.com/travisvn/stop-tahoe-update/actions)

> Safe • Transparent • Reversible
> 
> Everything here is inspectable and easy to undo.

---

## ⚙️ What This Does

Apple allows deferring major macOS upgrades using configuration profiles with official `com.apple.applicationaccess` keys. This repo provides a **90-day deferral profile** along with scripts to install, check status, and uninstall it.

On Sequoia **15.7.5 and later** this no longer reliably hides Tahoe — see the warning at the top.

A separate script can hide the red System Settings Dock badge.

<details>
<summary>🔍 What the deferral profile actually does</summary>

It uses Apple's official deferral keys:

```xml
<key>forceDelayedMajorSoftwareUpdates</key><true/>
<key>enforcedSoftwareUpdateMajorOSDeferredInstallDelay</key><integer>90</integer>
```

These settings hide major upgrades from Software Update for **up to 90 days** according to Apple's documentation. That held on earlier Sequoia releases; on **15.7.5 and later** Apple changed the behavior (see the warning at the top).

</details>

---

## 🧰 Quick Start

### 1. Clone or download the repo

```bash
git clone https://github.com/travisvn/stop-tahoe-update.git
cd stop-tahoe-update
```

### 2. Apply the 90-day deferral profile

The script will generate unique identifiers to prevent conflicts and attempt to install the profile.

To delay major updates 90 days and minor updates 30 days,

```bash
./scripts/install-profile.sh profiles/deferral-major-90days-minor-30days.mobileconfig
```

Or to delay only major updates 90 days and allow minor upates to occur as usual,

```bash
./scripts/install-profile.sh profiles/deferral-major-90days-only.mobileconfig
```

> [!NOTE]
> On recent macOS versions, silent installation may be blocked. If the script opens **System Settings**, locate the **"Profiles"** (or "Downloaded Profile") notification and click **Install** manually to complete the process.

### 3. Verify status

```bash
./scripts/status.sh
```

### 4. Hide the System Settings Dock badge (optional)

The deferral profile does not remove the red notification badge on the System Settings Dock icon. Toggle it with:

```bash
./scripts/toggle-dock-badge.sh
```

System Settings must be pinned in the Dock. Run the script again to restore the badge. See [Remove the Red Badge from the System Settings Dock Icon](./docs/REMOVE_DOCK_BADGE.md) for details and a Prefs Editor walkthrough.

### 5. Remove later if needed

```bash
./scripts/uninstall-profile.sh
```

---

## 📖 Guides

- [Remove the Red Badge from the System Settings Dock Icon](./docs/REMOVE_DOCK_BADGE.md) — hide the persistent notification badge on the System Settings Dock icon, or toggle it with [`scripts/toggle-dock-badge.sh`](./scripts/toggle-dock-badge.sh)

---

## 🧩 What's Next? (Help Wanted)

The 90-day deferral profile is unreliable on Sequoia 15.7.5 and later (see the warning at the top). Open questions the community can still help answer:

- **How long does the deferral actually last?** Apple says 90 days, but anecdotal experience suggests it may persist longer. More data points would be valuable.
- **Can we suppress upgrade prompts?** The Dock badge can be toggled (see above); “Install Now” prompts are still a separate annoyance.
- **Are there other safe, reversible approaches?** If you've found something that works, we'd love to hear about it.
- **What changes with new macOS versions?** Apple may change deferral behavior in future releases.

If you have findings, ideas, or just want to share your experience, open a [Discussion](https://github.com/travisvn/stop-tahoe-update/discussions) or submit a PR.

---

## 🧑‍💻 Contributing

We welcome contributions of all kinds:

- **Testing** — verify the profile works on your macOS version and report results
- **Research** — document macOS update behavior, deferral edge cases, or new Apple keys
- **Scripts & tooling** — improve the install/uninstall experience
- **Ideas** — propose approaches for suppressing prompts or extending deferrals

📄 See [CONTRIBUTING.md](./.github/CONTRIBUTING.md) and [docs/GOALS.md](./docs/GOALS.md).

---

## ⚖️ Safety Philosophy

- **No surprises** — every approach is documented and well-understood before it ships
- **Community-reviewed** — all code goes through PR review

---

## 🗺️ Beyond Tahoe

While this repo focuses on **Sequoia → Tahoe**, the long-term goal is a general-purpose toolkit for macOS users who want to choose when — or if — they upgrade.

---

## 💬 Community & Support

- [GitHub Discussions](https://github.com/travisvn/stop-tahoe-update/discussions) — share findings, test results, and ideas
- [Issues](https://github.com/travisvn/stop-tahoe-update/issues) — report bugs or problems with the scripts/profiles

---

## 🧾 License

**MIT License** — simple, permissive, and open.
