# AI-Native Lab — Sprint S2 Hub

Static results hub for the **AI-Native Organizations Sprint s2** — the 3-week AI Mindset lab. Collects the programme graph, weekly breakdowns, session archive, speakers, participants, stories, and final results behind one teal-grid GitHub Pages site.

**Live:** https://ai-mindset-org.github.io/ainative-lab/
**Repo:** https://github.com/ai-mindset-org/ainative-lab

---

## Site structure

| Path | Page | Description |
|---|---|---|
| `/` | `index.html` | Sprint hub — entry point, map of all sections, hero stats |
| `/graph/` | `graph/index.html` | Interactive knowledge graph of topics, speakers, sessions |
| `/weeks/` | `weeks/index.html` | Week index (w1, w2, w3) with per-week deep-dives |
| `/weeks/w1.html` | | Week 1 recap — sessions, highlights, homework |
| `/weeks/w2.html` | | Week 2 recap |
| `/weeks/w3.html` | | Week 3 recap |
| `/sessions/` | `sessions/index.html` | Full session archive with filters, recordings, materials |
| `/speakers-page/` | `speakers-page/index.html` | Speaker directory with bios and session links |
| `/participants/` | `participants/index.html` | Participant directory (opt-in), projects |
| `/stories/` | `stories/index.html` | Case studies and participant stories |
| `/results/` | `results/index.html` | Final outcomes, metrics, learnings, next cohort |

Shared assets live under `shared/` and can be referenced from any page.

---

## Local preview

```bash
# Python (stdlib)
python3 -m http.server 8000
# → http://localhost:8000/

# Or Node
npx serve .
```

Open in a browser. Paths inside the site use relative links, so it works both under `/` (local) and `/ainative-lab/` (GitHub Pages).

---

## Deploy

Pushing to `main` auto-publishes via GitHub Pages.

```bash
./deploy.sh
```

The helper runs `test.sh` first, shows `git status`, waits for confirmation, then commits with the message `deploy: rebuild sprint hub` and pushes to `origin/main`. Pages typically updates in 1–2 minutes.

Manual alternative:

```bash
./test.sh          # verify structure
git add -A
git commit -m "deploy: rebuild sprint hub"
git push origin main
```

---

## Data sources

All pages read from static JSON — no build step, no backend.

| File | Used by | Notes |
|---|---|---|
| `lms-data.json` | `index.html`, `graph/` | LMS export: sessions, modules, homework |
| `data/sessions.json` | `sessions/`, `weeks/` | Normalized session list |
| `data/speakers.json` | `speakers-page/`, `graph/` | Speaker bios + links |
| `data/stories.json` | `stories/` | Participant stories and case studies |
| `data/participants.json` | `participants/` | Opt-in participant directory |
| `data/graph.json` | `graph/` | Pre-computed graph adjacency |

---

## Shared design system

| File | Purpose |
|---|---|
| `shared/site.css` | Canonical design tokens + reusable components (topbar, nav, cards, hero, stat cards, tags, quotes, terminal block). Pages may `<link>` to it or inline the tokens. |
| `shared/nav.html` | Top navigation fragment with active-link detection. Include via fetch or copy inline; call `injectNav(basePath)` to wire it up. |

Design language: **Teal-grid** (AI-Native visual style).
- Background `#0d1117` / `#161b22` / `#1c2333`
- Accent teal `#4dc9d4`, blue `#3b82f6`, amber `#f59e0b`
- Fonts: IBM Plex Mono (body) + Space Grotesk (display)
- Subtle noise texture + 60px grid overlay

---

## Testing

```bash
./test.sh
```

Verifies every expected page exists and has a `<!DOCTYPE html>`, every data JSON parses, and every shared file is present. Exits non-zero on any miss. Run before `deploy.sh` (the deploy helper calls it automatically).

---

## Contributing

- Section pages live in their own folders (`graph/`, `weeks/`, etc.). Edit in place — no build step.
- Keep design tokens in sync with `shared/site.css` (`:root` block). If you introduce a new color or spacing value, add it to the shared file first.
- New pages: add the path to `test.sh` so the verification catches regressions.
- Data changes: update the corresponding JSON in `data/`, then run `./test.sh` to confirm it still parses.
- OG preview: `assets/web-cover.png` (1200×630) — regenerate via Playwright screenshot of the hub hero.
