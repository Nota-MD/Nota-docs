# 编写自己的拓展

Nota 拓展使用 Lua 5.4。一个拓展是一个目录，至少包含：

```text
hello/
├── plugin.toml
└── main.lua
```

本教程按编程书的方式逐步推进：

1. [第一个 Hello World](01-hello-world.md)
2. [添加命令与菜单](02-command-and-menu.md)
3. [绘制面板](03-panel.md)
4. [读取文档、保存设置](04-document-and-settings.md)
5. [多文件、测试与打包](05-packaging.md)

完整 API 参考位于主仓库
[`docs/13-lua-api.md`](https://github.com/Nota-MD/Nota/blob/main/docs/13-lua-api.md)。

## 安全模型

拓展不是无限制脚本。它只能使用清单 `capabilities` 中声明、并由宿主装配的 API。

例如没有声明 `network.http`，`nota.http` 就不存在；没有声明 `document.write`，
`nota.document.set_text` 就不存在。
