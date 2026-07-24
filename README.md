# Clayborn Idle UI

Visual-only Godot project for Clayborn Idle. **No game logic, no Core dependency, no managers.**

Publishable code lives in `features/` and `singleton/`; open `dev/project.godot` for local preview. Main wires Core logic to these views at runtime.

## Layout

| Path | Role |
|------|------|
| `features/` | Publishable UI feature views (combat, crafting, shop, …) |
| `singleton/` | UiRules, ThemeUpdater (Main registers autoloads) |
| `assets/` | Themes, fonts, icons, combat art |
| `dev/` | Standalone Godot 4.7 project: preview scenes, addons, `project.godot` |
| `dev/ui/features` | Windows junction → `../../features` (`res://ui/features/...`) |
| `dev/ui/singleton` | Windows junction → `../../singleton` (`res://ui/singleton/...`) |
| `dev/assets` | Windows junction → `../../assets` (`res://assets/...`) |

Main sparse-checkouts **`features/`**, **`singleton/`**, and **`assets/`**, not `dev/`.

```
features/
  combat/
    views/
      components/       # Reusable combat widgets
      scenes/           # Composed view scenes
      widgets/          # Small UI helpers
singleton/              # Autoload scripts for Main
assets/                 # Themes, fonts, icons
dev/                    # Preview-only project root
```

## Development

1. After clone, recreate junctions (see `.gitignore` comments), then open `dev/project.godot` in Godot **4.7**.
2. Preview main scene: `res://ui/features/combat/views/scenes/combat_hud_preview.tscn`
3. Other previews: `dev/main.tscn`, `dev/test.tscn`, `dev/side.tscn`

Autoloads in the dev project:

- `UiRules` → `res://ui/singleton/ui_rules.gd`
- `ThemeUpdater` → `res://ui/singleton/theme_updater.gd`

## Combat views

| Asset | Role |
|-------|------|
| `components/hp_bar.tscn` | HP bar with numeric label |
| `components/damage_number.tscn` | Floating damage / miss text |
| `components/enemy_stat.tscn` | Enemy stat panel |
| `components/combat_style_button.tscn` | Attack / defence style toggle |
| `widgets/attack_bar.tscn` | Cooldown / attack timer bar |
| `combat_hud_view.gd` | Binds layout nodes — call `show_damage`, `set_enemy_hp`, etc. |
| `combat_layout_profile.gd` | NodePath export map for HUD layout |

## Main integration (later)

1. Instance combat component scenes in Main.
2. Assign node refs to `CombatLayoutProfile`.
3. Connect Core combat signals to `CombatHudView` methods — **not** the other way around.

Do **not** add `core/` or `mocks/` to this project.

## Adding features

Copy `.tscn` + minimal display scripts into `features/<feature>/`. Keep scripts free of Core types; pass plain data (`Dictionary`, `int`, `String`, `Texture2D`). Use `res://ui/features/...` paths so they match Main once mounted at `ui/`.
