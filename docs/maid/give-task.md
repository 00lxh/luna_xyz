# GiveTask



Adds a task to be cleaned later.

### Syntax

```lua
Maid:GiveTask(task: any) -> number
```

***

### Parameters

| Parameter | Type  | Description                                            |
| --------- | ----- | ------------------------------------------------------ |
| `task`    | `any` | Task to manage (function, connection, object, or Maid) |

***

### Example

You can register tasks using `GiveTask`:

```lua
Maid:GiveTask(game.Players.PlayerAdded:Connect(function(player)
	print(('%s joined the game!'):format(player.Name));
end));
```

You can also assign connections directly using indexing:

```lua
Maid.player_added = game.Players.PlayerAdded:Connect(function(player)
	print(('%s joined the game!'):format(player.Name));
end);
```

To remove and clean a task assigned via indexing:

```lua
Maid.player_added = nil;
```

