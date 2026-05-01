# IsNumber

Returns `true` if the given value is of type `number` and is not `NaN` (Not a Number).

### Syntax

```lua
luna_xyz_env:IsNumber(num: number) -> boolean
```

***

### Parameters

| Parameter | Type     | Description            |
| --------- | -------- | ---------------------- |
| `num`     | `number` | The value to validate. |

{% hint style="info" %}
`NaN` is detected using the self-equality trick: `num == num` returns `false` only for `NaN`.
{% endhint %}

***

### Example

```lua
luna_xyz_env:IsNumber(42);       -- → true
luna_xyz_env:IsNumber(0.5);      -- → true
luna_xyz_env:IsNumber(0/0);      -- → false (NaN)
luna_xyz_env:IsNumber("42");     -- → false (string)
luna_xyz_env:IsNumber(nil);      -- → false
```
