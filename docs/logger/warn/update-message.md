# Update





Updates the log dynamically.

### Syntax

<pre class="language-lua"><code class="lang-lua"><strong>log:update_message(type: string?, message: string?, color: Color3?, updateTimestamp: boolean?)
</strong></code></pre>

#### OR

```lua
log:update_message({
    type = string?; message = string?;
    color = Color3?; update_timestamp = boolean?;
});
```

***

### Parameters

| Parameter         | Type      | Description       |
| ----------------- | --------- | ----------------- |
| `type`            | `string`  | New log type      |
| `message`         | `string`  | New message       |
| `color`           | `Color3`  | Custom color      |
| `updateTimestamp` | `boolean` | Updates timestamp |

***

### Example

```lua
local log = Logger.info("Loading...");

task.wait(1);

log:update_message("SUCCESS", "Loaded!", Color3.fromRGB(0,255,0));
```



