# ParseBoolean

Converts any raw value into a `boolean`. Accepts a wide range of true and false string representations. If the value is `nil` or unrecognized, returns `default`.

### Syntax

```lua
luna_xyz_env:ParseBoolean(raw: any, default: boolean) -> boolean
```

***

### Parameters

| Parameter | Type      | Description                                                                           |
| --------- | --------- | ------------------------------------------------------------------------------------- |
| `raw`     | `any`     | The raw value to parse. Will be coerced to a lowercase string internally.             |
| `default` | `boolean` | Fallback value when `raw` is `nil` or not recognized. Defaults to `false` if omitted. |

***

### Recognized Values

**True:** `"true"`, `"t"`, `"1"`, `"yes"`, `"y"`, `"on"`, `"enable"`, `"enabled"`

**False:** `"false"`, `"f"`, `"0"`, `"no"`, `"n"`, `"off"`, `"disable"`, `"disabled"`

{% hint style="info" %}
The comparison is **case-insensitive** — `"True"`, `"YES"`, and `"ON"` all work.
{% endhint %}

***

### Example

```lua
luna_xyz_env:ParseBoolean("yes", false);
-- → true

luna_xyz_env:ParseBoolean(nil, true);
-- → true  (nil falls back to default)

luna_xyz_env:ParseBoolean("off");
-- → false

luna_xyz_env:ParseBoolean("maybe", false);
-- → false  (unrecognized, returns default)
```
