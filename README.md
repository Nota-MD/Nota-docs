# Nota 文档

Nota 是一款本地优先、所见即所得，并用 Lua 扩展的 Markdown 编辑器。

这里是 Nota 的正式用户文档与开发者文档。文档内容与
[Nota 主仓库](https://github.com/Nota-MD/Nota) 同步维护。

当前版本基线：

| 项目 | 版本 |
|---|---|
| Nota | 0.18.0 Beta |
| Lua 扩展 API | v2.5 |

## 用户文档

从 [安装 Nota](user/install.md) 开始，随后阅读：

- [第一次写作](user/writing.md)
- [工作区、标签页与大纲](user/workspace.md)
- [设置与外观](user/settings.md)
- [安装拓展](user/extensions.md)
- [安装主题](user/themes.md)

## 开发者文档

三条独立路线：

1. [参与主程序开发](developer/core/README.md)
2. [编写自己的 Lua 拓展](developer/extensions/README.md)
3. [编写自己的主题](developer/themes/README.md)

拓展与主题教程都从最小可运行示例开始，再逐步加入命令、面板、设置、资源和发布流程。
扩展开发者可直接阅读
[完整扩展示例 Field Notes](developer/extensions/06-complete-demo.md)，
示例包含可安装源码、中文翻译、纯 Lua 测试和打包说明。

## 官方仓库

| 仓库 | 内容 |
|---|---|
| [Nota](https://github.com/Nota-MD/Nota) | 主程序与核心文档 |
| [Nota-plugins](https://github.com/Nota-MD/Nota-plugins) | 官方拓展 |
| [Nota-themes](https://github.com/Nota-MD/Nota-themes) | 官方主题 |
| [Nota-public-relations](https://github.com/Nota-MD/Nota-public-relations) | 开发故事与软件哲学 |
| [nota-md.github.io](https://github.com/Nota-MD/nota-md.github.io) | 项目官网 |

> 当前文档对应 Nota 0.18.0 Beta。
