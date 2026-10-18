# 添加命令与菜单

命令是拓展可以执行的动作；菜单只是调用命令的入口。

## 1. 注册命令

修改 `main.lua`：

```lua
local M = {}
local nota_api

function M.on_load(nota)
  nota_api = nota

  nota.command.register("hello.run", function()
    return {
      message = "Hello from a command",
      date = nota.time.now().ymd,
    }
  end)
end

return M
```

命令名只在**当前拓展内**唯一。前端调用时同时携带拓展 id 和命令名。

## 2. 将命令放进“插件”菜单

菜单需要 `ui.menu` 能力：

```toml
capabilities = ["ui.menu"]
```

注册菜单：

```lua
nota.ui.register_menu({
  label = "Run Hello",
  command = "hello.run",
})
```

重启 Nota 后，**拓展 → 插件 → Run Hello** 会出现。

## 3. 显示通知

通知需要 `ui.notify`：

```toml
capabilities = ["ui.menu", "ui.notify"]
```

```lua
nota.command.register("hello.run", function()
  nota.ui.notify("Hello from Nota", "success")
end)
```

`level` 可写 `info`、`success`、`warn` 或 `error`。

## 4. 接收参数

命令回调接收一个 `args` 参数：

```lua
nota.command.register("hello.greet", function(args)
  local name = args and args.name or "world"
  nota.ui.notify("Hello, " .. name)
end)
```

## 5. 为什么菜单立即变灰

菜单的 `command` 必须指向**已经注册过的命令**。拼错命令名时，条目可能无法执行。

保持 id、命令名和菜单入口一致，并在重启后实际点击验证。
