# GivePromise



Registers a promise for automatic cleanup.

### Syntax

```lua
Maid:GivePromise(promise: Promise) -> Promise
```

***

### Parameters

| Parameter | Type      | Description      |
| --------- | --------- | ---------------- |
| `promise` | `Promise` | Promise to track |

***

### Example

```lua
Maid:GivePromise(somePromise):andThen(function(result)
	print(result);
end);
```

