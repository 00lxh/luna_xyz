# Overview

The Logger system provides a dynamic and customizable way to create, update, and manage logs within the **luna.xyz runtime**, including real-time DevConsole rendering, live message updates, and optional file persistence.

***

These functions allow you to:

* Create categorized logs with dynamic updates
* Modify logs after creation (message, type, color, timestamp)
* Display logs with icons and colors in the DevConsole
* Track logs internally and clean them individually
* Create animated loading/progress logs
* Optionally print logs to console and save to files

Each log returns a **log module**, allowing real-time updates and manual cleanup.

***

### Available Functions

| Function                                      | Description                       | Returns       |
| --------------------------------------------- | --------------------------------- | ------------- |
| [`event`](event/)                             | Logs an event message             | `LogModule`   |
| [`warn`](warn/)                               | Logs a warning message            | `LogModule`   |
| [`error`](error/)                             | Logs an error message             | `LogModule`   |
| [`success`](success/)                         | Logs a success message            | `LogModule`   |
| [`debug`](debug/)                             | Logs debug information            | `LogModule`   |
| [`info`](info/)                               | Logs general information          | `LogModule`   |
| [`wait`](wait/)                               | Logs a waiting state              | `LogModule`   |
| [`ready`](ready/)                             | Logs a ready state                | `LoaderOject` |
| [`CreateLoading`](create-loading.md)          | Creates a dynamic loading log     | `nil`         |
| [`ToggleLogs`](toggle-logs.md)                | Enables/disables file saving      | `nil`         |
| [`SetSaveLocation`](set-save-location.md)     | Sets file save location           | `nil`         |
| [`ToggleConsoleLogs`](toggle-console-logs.md) | Enables/disables console logs     | `nil`         |
| [`ToggleIcons`](toggle-icons.md)              | Enables/disables icons            | `nil`         |
| [`Destroy`](destroy.md)                       | Cleans all logs and stops updates | `nil`         |

***

### Usage

All functions are called with dot syntax on `Logger`:

```lua
Logger.FunctionName(args);
```



