# 安装拓展

Nota 安装包不预装拓展。官方拓展维护在
[Nota-plugins](https://github.com/Nota-MD/Nota-plugins)。

## 安装

1. 打开 **设置 → 拓展**
2. 选择 **从文件安装…**
3. 选择 `.nota-plugin` 包
4. 重启 Nota（插件在启动时加载）

安装后可启用、停用、导出或卸载拓展。

## 官方拓展

- **AI 助手**：使用你配置的 OpenAI 兼容接口
- **Git**：状态、差异、提交与历史
- **Slidev**：预览 Markdown 幻灯片
- **写作统计**：本轮速度、长期记录与分享图

## 权限

每个拓展在 `plugin.toml` 中声明能力。未声明 `network.http` 的拓展无法联网；未声明
`document.write` 的拓展无法修改正文。

安装第三方拓展前，请检查：

- 包来自哪里
- 申请了哪些能力
- 是否带有可信签名

签名只证明包在签名后没有被修改，不等于作者一定可信。

## 数据位置

拓展自己的设置与数据分别位于：

- Linux：`~/.config/nota/plugin-settings/`、`~/.local/share/nota/plugin-data/`
- Windows：`%APPDATA%\nota\plugin-settings\`、`%APPDATA%\nota\plugin-data\`
- macOS：`~/Library/Application Support/nota/plugin-settings/`、`~/Library/Application Support/nota/plugin-data/`

卸载拓展时，它自己的设置文件默认保留。
