# assets/

Static assets for the AI-Native Lab hub.

## Files

- `web-cover.png` — **OG image / social preview** (1200×630). Referenced from every page's `<meta property="og:image">`. Not committed yet — generate via Playwright screenshot of `index.html`, crop/resize to 1200×630, save here.

## Regenerating `web-cover.png`

```bash
# Playwright example
npx playwright screenshot \
  --viewport-size=1200,630 \
  --full-page=false \
  http://localhost:8000/ \
  assets/web-cover.png
```

Or open `index.html` in Chrome, use DevTools device toolbar at 1200×630, take a screenshot, crop to the hero block.

## Other assets

Add logos, cover images, icons here. Keep paths relative so the site works both locally (`/assets/...`) and under GitHub Pages (`/ainative-lab/assets/...`).
