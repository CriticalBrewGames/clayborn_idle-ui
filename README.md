# Clayborn Idle UI

Visual-only Godot project. **No game logic, no Core dependency, no managers.**

Publishable folders at repo root are the source of truth. Run **`setup.bat`** after clone so `dev/` junctions point at them.

## Setup (required after clone)

```powershell
git clone https://github.com/CriticalBrewGames/clayborn_idle-ui.git
cd clayborn_idle-ui
.\setup.bat
```

Then open `dev/project.godot` (Godot **4.7**).

## Layout

| Path | Role |
|------|------|
| `features/` | Publishable UI feature views |
| `singleton/` | UiRules, ThemeUpdater |
| `assets/` | Themes, fonts, icons |
| `setup.bat` / `setup.ps1` | Recreate local junctions |
| `dev/ui/features` | Junction → `../../features` |
| `dev/ui/singleton` | Junction → `../../singleton` |
| `dev/assets` | Junction → `../../assets` |

Main links **`features/`**, **`singleton/`**, **`assets/`** locally via `setup.sh` (not `dev/`).

## Development

- Preview: `res://ui/features/combat/views/scenes/combat_hud_preview.tscn`
- Autoloads: `UiRules`, `ThemeUpdater` under `res://ui/singleton/`

Keep scripts free of Core types; pass plain data (`Dictionary`, `int`, `String`, `Texture2D`).
