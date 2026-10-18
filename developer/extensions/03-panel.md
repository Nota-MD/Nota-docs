# 绘制面板

面板显示在右侧“拓展”栏，需要 `ui.panel`。

## 1. 增加能力

```toml
capabilities = ["ui.notify", "ui.panel", "ui.menu"]
```

## 2. 声明面板

```lua
nota.ui.register_panel({
  id = "hello",
  title = "Hello",
  location = "right",
  render = function()
    return {
      { kind = "heading", text = "Hello Nota" },
      { kind = "text", text = "This panel is rendered on demand." },
    }
  end,
})
```

`render` 是一个函数，不是固定表格。宿主每次读取面板内容都会重新调用它。

## 3. 添加按钮

先注册命令，再在面板中使用按钮块：

```lua
nota.command.register("hello.refresh", function()
  nota.ui.refresh("hello")
end)

nota.ui.register_panel({
  id = "hello",
  title = "Hello",
  render = function()
    return {
      { kind = "heading", text = "Hello Nota" },
      { kind = "buttons", items = {
        { label = "Refresh", command = "hello.refresh" },
      } },
    }
  end,
})
```

## 4. 实时面板

加上：

```lua
live = true
```

宿主会每秒请求一次 `render`。只适合内存中的轻量计算；不要在实时面板里启动进程或请求网络。

## 5. 面板状态

把状态保存在模块变量中：

```lua
local count = 0

nota.command.register("hello.increment", function()
  count = count + 1
  nota.ui.refresh("hello")
end)
```

`render` 读取 `count`，命令修改它，然后主动刷新面板。

## 6. 调试原则

- `render` 每次都应返回**当前**状态
- 不在 `render` 中做昂贵操作
- 命令修改状态后主动调用 `nota.ui.refresh(panel_id)`
- 面板 id 在同一个拓展内不能重复
