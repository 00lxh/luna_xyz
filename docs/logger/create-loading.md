# CreateLoading





Creates a dynamic progress log that updates automatically.

### Syntax

```lua
Logger:CreateLoading(options: table) -> LoaderObject
```

***

### Parameters

| Parameter | Type    | Description          |
| --------- | ------- | -------------------- |
| `options` | `table` | Loader configuration |

***

### Options

| Option        | Type     | Description               |
| ------------- | -------- | ------------------------- |
| `Color`       | `Color3` | Progress color            |
| `FillSymbol`  | `string` | Progress bar fill symbol  |
| `EmptySymbol` | `string` | Progress bar empty symbol |
| `CurrentStep` | `number` | Current progress          |
| `TotalSteps`  | `number` | Total steps               |

***

### Example

```lua
local loader = Logger:CreateLoading({
    TotalSteps = 5;
});

for i = 1, 5 do
    task.wait(0.5);
    loader:SetCurrentStep(i);
end;
```

***

### Loader Methods

#### SetCurrentStep:

```lua
loader:SetCurrentStep(step: number);
```

#### SetTotalSteps:

```lua
loader:SetTotalSteps(step: number);
```

#### SetColor:

```lua
loader:SetColor(color: Color3);
```



