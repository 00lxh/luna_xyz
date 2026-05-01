# event





Creates a log and returns a **log module** for dynamic control.

### Syntax

```lua
Logger.event(message: string) -> LogModule
```

***

### Parameters

| Parameter | Type     | Description    |
| --------- | -------- | -------------- |
| `message` | `string` | Message to log |

***

### Example

```lua
local log = Logger.event("Player joined");
```

