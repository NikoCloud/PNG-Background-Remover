# PNG Background Remover

> A lightweight, standalone Windows tool for batch-removing backgrounds from PNG and JPEG character images — built for [SillyTavern](https://github.com/SillyTavern/SillyTavern) AI character card creators.

![Banner](docs/screenshots/banner.png)

---

## Features

**Background Remover tab**
- Removes **black**, **white**, and **checkered** backgrounds automatically
- Handles **non-contiguous regions** — cleans gaps between arm and body, hair strands, etc.
- Batch processes entire folders or individual files
- Converts **JPEG → PNG** with transparency in one pass
- Live progress with thumbnail previews as each image finishes
- Full-size viewer with ◀ ▶ arrow navigation to compare results side by side
- Advanced tolerance sliders — tune dark/light thresholds and edge blur per run
- Output saved to a `background removal/` subfolder next to your source files

**Grid Slicer tab**
- Load a character emotion grid sheet (PNG or JPEG)
- **Auto-detect** grid lines, or manually specify rows × columns
- Preview the detected grid with green overlay before committing
- **Generate Cells** — all cells processed in memory, nothing saved yet
- Click any thumbnail to **deselect** it (dims it); click again to re-select
- **Save Selected** — only writes the cells you kept, named by row/col
- Full-size viewer per cell, with arrow navigation

---

## Screenshots

### Background Remover
![Background Remover tab](docs/screenshots/bg_remover_tab.png)

### Grid Slicer — Grid Preview
![Grid overlay preview](docs/screenshots/grid_slicer_preview.png)

### Grid Slicer — Cell Selection
![Cell selection](docs/screenshots/grid_slicer_cells.png)

---

## Installation

### Option A — Pre-built EXE (recommended)

1. Go to the [**Releases**](https://github.com/NikoCloud/PNG-Background-Remover/releases) page
2. Download `BGRemover.exe` from the latest release
3. Double-click to run — no install, no Python required

### Option B — Run from source

**Requirements:** Python 3.10+

```bash
git clone https://github.com/NikoCloud/PNG-Background-Remover.git
cd PNG-Background-Remover
pip install -r requirements.txt
python main.py
```

Or double-click **`Run.bat`** (suppresses the terminal window).

### Option C — Build the EXE yourself

```bash
pip install -r requirements.txt
```

Then double-click **`build.bat`**, or run:

```bash
python -m PyInstaller bg_remover.spec
```

Output: `dist/BGRemover.exe` (~19 MB, fully self-contained).

---

## Usage

### Background Remover

1. Click **Folder…** to process all images in a folder, or **File(s)…** to pick individual images
2. Optionally expand **⚙ Advanced ▾** to adjust tolerances (see table below)
3. Click **Start Processing**
4. Thumbnails appear as each image finishes — click any to open the full-size viewer
5. Click **Open Output Folder** to jump straight to the results

Output is saved to a `background removal/` subfolder next to your source files.

#### Advanced Settings

| Setting | Default | Notes |
|---|---|---|
| Dark BG tolerance | 10 | Lower = safer near dark hair/shadows |
| Light BG tolerance | 20 | Higher catches more white fringe |
| Edge blur radius | 2.0 | Gaussian blur applied to alpha edges only |

---

### Grid Slicer

1. Click **Select Image…** and pick your emotion grid sheet (PNG or JPEG)
2. Click **Auto-Detect Grid** — the tool scans for separator lines automatically
   - If auto-detect fails, click **Manual ▾**, enter rows × columns, and click **Apply**
3. Verify the green grid overlay on the preview — it should align with cell borders
4. Optionally check **Remove BG** to strip backgrounds from each cell as it's cropped
5. Click **Generate Cells** — all cells appear as thumbnails, all selected by default
6. **Click any thumbnail** to deselect it (dims to gray); click again to re-select
7. Use **✓ All** / **✗ None** for bulk selection
8. Click **💾 Save Selected (X/Y)** to write only your chosen cells to disk
9. Click **Open Output Folder** to see the results

Output is saved to a `{imagename}_slices/` subfolder next to your source image.

---

## Controls Reference

### Background Remover

| Control | Description |
|---|---|
| **Folder…** | Select a folder — processes all PNG/JPEG files inside |
| **File(s)…** | Pick one or more individual images |
| **Start Processing** | Begin batch removal |
| **⚙ Advanced ▾** | Toggle tolerance and blur sliders |
| **Open Output Folder** | Opens `background removal/` in Explorer |
| *Click thumbnail* | Open full-size viewer |

### Grid Slicer

| Control | Description |
|---|---|
| **Select Image…** | Load a grid sheet (PNG or JPEG) |
| **Auto-Detect Grid** | Scan image for separator lines |
| **Manual ▾** | Enter rows × columns manually |
| **Remove BG** | Strip background from each cropped cell |
| **Generate Cells** | Crop all cells into memory for review |
| *Click thumbnail* | Toggle selected / deselected |
| **✓ All / ✗ None** | Select or deselect all cells |
| **💾 Save Selected** | Write selected cells to `{name}_slices/` |
| **Open Output Folder** | Open the slices folder in Explorer |

### Viewer (both tabs)

| Input | Action |
|---|---|
| Click thumbnail | Open full-size viewer |
| ◀ / ▶ buttons | Previous / next image |
| ← / → arrow keys | Previous / next image |
| **✕ Close** button or **Escape** | Close viewer |

---

## How It Works

### Background Classification
Samples ~32 evenly-spaced pixels along all four edges and majority-votes for the background type. Requires only 35% agreement, so it works correctly even when the subject fills most of the bottom edge (portraits, shoulder-up shots). Checks for checkered patterns first by sampling a tile grid.

### Background Removal (Pass 1 — Flood Fill)
Seeds a flood fill from every border pixel on a downscaled (512px) copy of the image, colour-gated to only spread through pixels that match the border background colour within tolerance. The resulting mask is upscaled back to full resolution.

### Background Removal (Pass 2 — Global Colour Match)
A fast O(w×h) pass using PIL's `point()` and `ImageChops` removes enclosed background regions that the flood fill couldn't reach (e.g. a white gap between an arm and body).

### Alpha Edge Smoothing
A light Gaussian blur is applied to the alpha channel only — the RGB data is untouched — producing clean, anti-aliased edges without blurring the subject.

### Grid Detection
Scans each row and column of the image (on a downscaled copy for speed) counting background-coloured pixels. Rows/columns where ≥90% of pixels are background are marked as separators. Consecutive separator indices are collapsed to a single midpoint boundary.

---

## Requirements (source / build)

| Package | Purpose |
|---|---|
| `Pillow >= 10.0` | All image processing |
| `customtkinter >= 5.2` | Modern dark-mode UI |
| `darkdetect >= 0.8` | System theme detection |
| `pyinstaller >= 6.0` | Build EXE *(build only)* |

---

## License

MIT — free to use, modify, and distribute.
