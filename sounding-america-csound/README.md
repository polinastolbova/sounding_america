# Sounding America — Csound edition

This version removes the embedded Csound IDE and loads each original `.csd` directly through `@csound/browser` (WebAssembly).

## Run locally
1. Install Node.js 20+ from https://nodejs.org/
2. In this folder run `npm install`
3. Run `npm run dev` and open the local URL Vite prints.
4. To make a deployable build, run `npm run build`; upload the contents of `dist/` to a static HTTPS host (GitHub Pages, Netlify, etc.).

The first playback downloads/initializes the Csound engine. Press Play once per chapter; selecting another chapter and pressing Play loads its matching `.csd`. Browsers require a user click before audio can start.
