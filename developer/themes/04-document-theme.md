# 第一个文档主题

文档主题只作用于编辑区，不影响菜单、侧栏和按钮。

## 1. 创建文件

在文档主题目录创建：

```text
paper.css
```

## 2. 最小主题

```css
:root {
  --doc-bg: #fffdf8;
  --doc-fg: #25211d;
  --fg: #25211d;
  --fg-muted: #655d54;
  --fg-faint: #8a8178;
  --border: #e2d9cf;
  --bg-subtle: #f7f2eb;
  --bg-raised: #fffaf3;
  --accent: #b8542b;
  --accent-fg: #ffffff;

  --font-doc: "Noto Serif CJK SC", "Songti SC", serif;
  --doc-font-size: 1em;
  --doc-line-height: 1.85;
  --doc-para-gap: 0.85em;
}

h1,
h2,
h3,
h4,
h5,
h6 {
  font-weight: 600;
}

blockquote {
  border-left: 3px solid var(--accent);
  color: var(--fg-muted);
}
```

## 3. 标题层级

主题可以定义：

```css
--doc-h1-size
--doc-h2-size
--doc-h3-size
--doc-h4-size
--doc-h5-size
--doc-h6-size
--doc-h-weight
--doc-h-line-height
```

## 4. 代码块

```css
pre,
code {
  font-family: var(--font-mono);
}

pre {
  border: 1px solid var(--border);
  border-radius: 6px;
  background: var(--bg-subtle);
}
```

代码块的颜色变量还包括：

```css
--code-comment
--code-keyword
--code-string
--code-number
--code-function
--code-attr
--code-tag
```

## 5. 不碰界面

文档主题不需要写 `[data-ui-style]`，也不应试图修改 `.sidebar`、`.menubar` 等外壳。
Nota 会把主题选择器机械地限制在编辑区下，外壳规则不会成功泄漏。

## 6. 深色配对

独立文档主题可以本身就是深色。准备同时用于浅色和深色的主题时，建议提供两个文件：

```text
paper.css
paper-dark.css
```

让两套主题共用排版，只把颜色分开，更容易维护。
