# 读取文档、保存设置

这一章加入两个最常用的宿主能力：读取当前文档与保存拓展自己的设置。

## 1. 读取文档

清单：

```toml
capabilities = [
  "document.read",
  "settings.own",
  "ui.panel",
]
```

读取整篇 Markdown：

```lua
local text = nota.document.get_text()
```

读取统计：

```lua
local stats = nota.document.stats()
nota.log.info("words=" .. stats.words)
```

`document.read` 只允许读取当前打开的文档，不提供任意文件读取。

## 2. 保存设置

```lua
local greeting = nota.settings.get("greeting") or "Hello"
nota.settings.set("greeting", "Welcome")
```

设置文件按拓展 id 隔离：

```text
plugin-settings/example.hello.toml
```

值只支持文本、数字和布尔值，不支持数组或表。需要结构化数据时自行编码为 JSON 文本。

## 3. 让宿主绘制设置

在清单中声明：

```toml
[[settings]]
key = "greeting"
kind = "text"
label = "Greeting"
help = "Shown in the hello panel."
placeholder = "Hello"
```

Nota 会把这一项显示在 **设置 → 拓展**。

范围控件示例：

```toml
[[settings]]
key = "refresh_seconds"
kind = "range"
label = "Refresh interval"
help = "Seconds between updates."
min = 1
max = 60
default = 5
step = 1
unit = "s"
```

## 4. 写入文档的边界

写入需要 `document.write`。不要在用户没有确认时替换整篇文档。

更安全的设计：

1. 在面板中展示将要写入的内容
2. 用户点击确认
3. 再调用写入 API

## 5. 检验隔离

完成这一章后，检查：

- 未声明 `network.http` 时 `nota.http == nil`
- 未声明 `document.write` 时写入函数不存在
- 设置只出现在自己的文件中
- 卸载后重新安装同一 id，原设置仍可读取
