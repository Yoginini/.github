# Yoginini &middot; `.github`

The GitHub organisation profile for [Yoginini](https://yoginini.us).

- **[`profile/README.md`](profile/README.md)** — the page shown at
  [github.com/Yoginini](https://github.com/Yoginini). GitHub only renders it
  from this exact path in this exact repo.
- **[`assets/logo.svg`](assets/logo.svg)** — the crown lotus, the source of
  truth for the mark. `logo.png` is rendered from it at 1024&times;1024 for the
  organisation avatar, which has to be uploaded through the GitHub web UI
  (there is no REST API for it).
- **[`assets/org-banner.png`](assets/org-banner.png)** — the banner at the top
  of the profile, rendered at 2x from `tools/org-banner.html`.

Images in the profile README are referenced by absolute `raw.githubusercontent`
URL, because relative paths do not resolve for viewers of the org page.

```bash
./tools/render.sh    # regenerate the banner and the avatar (needs Chrome)
```

The site itself lives in [Yoginini/website](https://github.com/Yoginini/website).
