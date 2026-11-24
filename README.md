# Space Waves — standalone build

Personal offline copy of the Unity WebGL build of Space Waves (CrazyGames build 114),
stripped of the gameframe wrapper and ads. **For your own personal use only** — don't
redistribute it; the game belongs to its developer.

## How to run

You need a tiny local web server (WebGL builds can't run from a `file://` link — the
browser blocks loading the .wasm/.data files that way).

**Windows (easiest):**
1. Double-click `start-windows.bat`
   (needs Python installed; if you don't have it, install from python.org or use Option B)
2. Open http://localhost:8777 in your browser

**Any OS with Python:**
```
python3 -m http.server 8777
```
then open http://localhost:8777

**Option B — VS Code:** install the "Live Server" extension, right-click `index.html`
→ "Open with Live Server".

## Offline caching (service worker)

The first time you open the page, a service worker pre-caches **every** game file
(index.html, loader, wasm, data, framework — ~62 MB). Look for the green
"Offline-ready: all files cached" line on the loading screen.

After that:
- The game boots instantly from cache; the server is only there so the browser
  allows the page to exist at all (WebGL can't run from a `file://` link).
- You can even install it as an app via your browser's "Install app" menu —
  it launches fullscreen with no URL bar thanks to the included manifest.
- Verified: with the network fully disconnected, the game reloads and runs
  purely from the service worker cache.

If you ever need to reset the cache: DevTools (F12) → Application → Service
Workers → Unregister, then reload.

**Option C — Railway (cloud):** the folder is a ready-to-deploy container.
1. Push this folder to a private GitHub repo (or install the Railway CLI and run
   `railway init` + `railway up` inside the folder).
2. On Railway, create a project → "Deploy from GitHub repo" → pick the repo.
   Railway auto-detects the `Dockerfile` — no config needed.
3. It binds to `0.0.0.0:$PORT` automatically; Railway gives you the public URL.
4. Open the URL once — the service worker caches everything, so you can even play
   it with a flaky connection afterwards.

`server.py` sets correct MIME types (`application/wasm` etc.) and cache headers
(build assets immutable, shell always revalidated), so it also works as a plain
host for any static web server you prefer (nginx, caddy, ...).

Keep the deployment URL **private** — this is still the developer's game, so
don't share it publicly or list it as a game site.

## What's inside

- `index.html` — standalone launcher (loading bar + fullscreen button + SDK stub + SW registration)
- `sw.js` — service worker that pre-caches all game files for offline use
- `manifest.webmanifest` — PWA manifest (installable app, fullscreen, landscape)
- `Build/` — Unity WebGL build files (already decompressed from Brotli)
- `start-windows.bat` / `start.sh` — one-click local server helpers
- `server.py` + `Dockerfile` — Railway-ready container (binds 0.0.0.0:$PORT)

## Notes

- Controls: hold Left Mouse / W / Space to fly up, release to fly down. P pauses.
- **Fullscreen window:** the game canvas fills the entire browser window and renders
  at your monitor's **native** resolution (canvas buffer = window size x devicePixelRatio).
  If Windows display scaling is at 125%/150%, the game now renders sharp — not blurry.
  Use the Fullscreen button (or F11) for true fullscreen. A few menu texts may still look
  slightly soft — the game's own low-res bitmap font is baked into the original assets.
- **Auto-updating cache:** if the files are ever updated, the page reloads itself once
  automatically when the new service worker takes over — no manual double-refresh needed.
- **No ads:** ad requests are intercepted and instantly "finished", so the fake
  "A midgame ad would appear here" popup never shows and nothing pauses the game.
- The bundled CrazyGames SDK falls back to "local" mode automatically: your progress
  saves to your browser's localStorage instead of the cloud. Console lines about
  ByteBrew / orientation lock / "adblock status" are harmless.
- No ads, no account, no tracking beyond what runs inside the build itself.
- If your browser cache holds a stale copy, hard-refresh (Ctrl+Shift+R).
