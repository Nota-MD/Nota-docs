# 图标与字体

主题资源使用相对 CSS 文件自身的路径。

## 目录示例

```text
ui-styles/
├── dusk.css
└── dusk-assets/
    ├── close.svg
    └── interface-font.ttf
```

`dusk.css` 和资源都在 `ui-styles/` 根目录内。相对路径不能逃出这个目录。

## 替换图标

图标由逻辑名映射：

```css
@font-face {
  font-family: "Dusk Interface";
  src: url("./dusk-assets/interface-font.ttf") format("truetype");
}

[data-ui-style="dusk"] {
  --font-ui: "Dusk Interface", sans-serif;
  --icon-folio-close-symbolic: url("./dusk-assets/close.svg");
}
```

图标文件应为 SVG，使用单色路径。Nota 通过 `mask-image` 取形状，颜色来自当前文字色。

## 图标命名

从组件使用的逻辑名映射，例如：

```text
folio-close-symbolic
folio-document-open-symbolic
folio-insert-image-symbolic
nota-spellcheck-symbolic
```

变量格式固定：

```css
--icon-<逻辑名>: url("./path.svg");
```

## 字体许可

随主题分发字体时，必须：

- 在主题目录内保留完整许可证
- 保留修改说明和来源
- 不使用禁止再分发的字体
- 不把字体许可证混入 Nota 根 `LICENSE`

## 点阵字体

点阵字体必须按原生像素尺寸使用。例如 16px 字体不要随意放大到 20px 再声称仍是点阵。

```css
[data-ui-style="dusk"] {
  --font-ui: "Dusk Bitmap", monospace;
  --ui-font-size: 16px;
  font-synthesis: none;
}
```

## 资源内联

Nota 在注入主题前会把相对图片、SVG 与字体转为内联数据。文件缺失时，只跳过对应资源，
不会让整个应用崩溃。
