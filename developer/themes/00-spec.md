# 主题包规范

Nota 有两条独立主题轴：

- **界面主题**：菜单、侧栏、按钮、标签、状态栏、图标和界面字体；
- **文档主题**：正文、代码块、表格、图片、公式、打印与导出。

两者都不能要求主程序增加主题专用分支。

## 推荐目录

```text
themes/
└── focus/
    ├── theme.css
    ├── assets/
    ├── fonts/
    └── LICENSE.md

ui-styles/
└── dusk/
    ├── theme.css
    ├── icons/
    └── fonts/
```

只接受主题目录；根目录里的扁平 `<id>.css` 不会被加载。

主 CSS 可用 `theme.css`，也可用与目录同名的 `<id>.css`。主题 id 只能包含
ASCII 字母、数字、`-` 和 `_`，长度 1–64。

## 文档主题

正文根兼容 Typora 的 `#write`：

```css
#write {
  max-width: 46em;
  font-family: var(--font-doc);
  line-height: 1.8;
}
```

宿主会把它映射到编辑区中的 ProseMirror 根，并把裸元素规则限域到
`.editor-pane`。文档主题不能修改外壳。

代码块、任务列表和公式等组件结构由 Nota 自己的 DOM 决定。Typora 的
`pre.md-fences` / `.md-task-list-item` 不能原样假设可用。

Nota 已提供 `pre.md-fences`、任务项、块公式和 Mermaid 容器的基础结构映射。
具体兼容结果与已知差异见主仓库
[`typora-theme-compatibility.md`](https://github.com/Nota-MD/Nota/blob/main/docs/reference/typora-theme-compatibility.md)。

## 界面主题

每条组件规则必须带主题 id：

```css
[data-ui-style="dusk"] {
  --radius: 4px;
  --control-height: 30px;
}

[data-ui-style="dusk"][data-ui-mode="light"] {
  --bg: #f5f2ec;
  --fg: #25221e;
}

[data-ui-style="dusk"][data-ui-mode="dark"] {
  --bg: #24272b;
  --fg: #f0ede7;
}
```

## 资源

- 资源路径相对主 CSS；
- 只能读取主题包目录内的资源；
- 图片、SVG 和字体会在注入前内联；
- 不联网加载字体或样式；
- 随包字体必须同时附带完整许可证；
- 图标通过 `--icon-<逻辑名>: url(...)` 声明。

## 发布前

界面主题至少检查菜单、侧栏、按钮、设置、关于、浅色、深色、键盘焦点和禁用态。

文档主题至少检查标题、列表、引用、代码块、表格、图片、公式、Mermaid、查找、
选区、拼写波浪线、打印和导出。

完整规范见主仓库
[`theme-package-spec.md`](https://github.com/Nota-MD/Nota/blob/main/docs/reference/theme-package-spec.md)。
