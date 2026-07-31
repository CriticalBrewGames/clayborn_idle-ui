extends Control

## Left side column: activity tracker on top, player inventory HUD at the bottom.
## The accessor lets Main reach the inventory HUD without depending on this
## scene's internal layout.


func get_inventory_hud() -> Control:
	return $VBoxContainer/PlayerInventoryHud
