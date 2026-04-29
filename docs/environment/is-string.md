# IsString

Returns `true` only if the given value is of type `string` **and** is non-empty after stripping leading and trailing whitespace.

### Syntax

```lua
luna_xyz_env:IsString(str: string) -> boolean
```

### Parameters

| Parameter | Type     | Description            |
| --------- | -------- | ---------------------- |
| `str`     | `string` | The value to validate. |

{% hint style="info" %}
Strings containing only whitespace (e.g. `" "`) return `false`.
{% endhint %}

### Example

```lua
luna_xyz_env:IsString("hello");   -- → true
luna_xyz_env:IsString("   ");     -- → false (whitespace only)
luna_xyz_env:IsString("");        -- → false (empty)
luna_xyz_env:IsString(123);       -- → false (not a string)
luna_xyz_env:IsString(nil);       -- → false
```
