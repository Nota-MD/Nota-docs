# 安装 Nota

## 下载

从 [GitHub Releases](https://github.com/Nota-MD/Nota/releases) 下载对应平台的安装包：

- Linux：`.deb`、`.rpm` 或 `.AppImage`
- Windows：`.exe` 安装程序

官方安装包不包含拓展和官方主题，它们需要单独安装。

## Linux

Debian / Ubuntu 使用 `.deb`：

```sh
sudo apt install ./Nota_0.6.0-beta_amd64.deb
```

AppImage 添加执行权限后运行：

```sh
chmod +x Nota_0.6.0-beta_amd64.AppImage
./Nota_0.6.0-beta_amd64.AppImage
```

## Windows

运行 `.exe` 安装程序。

当前 Beta 安装包未签名。Windows SmartScreen 可能显示安全提示；请确认下载地址来自
`github.com/Nota-MD/Nota`，再按系统提供的正常方式继续。

Windows 支持尚属新增，当前测试范围有限。欢迎在
[GitHub Issues](https://github.com/Nota-MD/Nota/issues) 提交问题、兼容性信息和建议。

## 第一次启动

启动后可以：

- 新建 Markdown 文档
- 打开已有 `.md` 文件
- 打开一个文件夹作为工作区
- 从设置中安装词典、拓展和主题

如果界面没有按预期出现，请记录操作系统、安装包类型、Nota 版本和完整错误提示。
