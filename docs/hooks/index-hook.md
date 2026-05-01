# IndexHook

Overrides property access and assignment on an object.

### Syntax

```lua
HookService:IndexHook(object: Instance|string, property: string, value: any) -> (function, function)
```

{% hint style="warning" %}
Your executor must have hookmetamethod.
{% endhint %}

***

### Parameters

| Parameter  | Type                 | Description                |
| ---------- | -------------------- | -------------------------- |
| `object`   | `Instance \| string` | Target object              |
| `property` | `string`             | Property to override       |
| `value`    | `any`                | Value to return or enforce |

***

### Example

```lua
HookService:NameCallHook(game.Players.LocalPlayer.Character.Humanoid, "WalkSpeed", 32);
```

