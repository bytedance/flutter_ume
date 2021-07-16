# Contributing

[English](./CONTRIBUTING_en.md)

感谢你对开源贡献感兴趣。
不止是代码，提 issue、补充和扩展文档等贡献也都欢迎。

请根据本文的指引，对 UME 项目进行开源贡献。

- [Contributing](#contributing)
  - [如何联系开发者](#如何联系开发者)
  - [如何提 Issue](#如何提-issue)
  - [如何提 Pull Request](#如何提-pull-request)
  - [Commit Message 规范](#commit-message-规范)

## 如何联系开发者

**可能你：**

- 发现文档错误、代码有 bug
- 使用 UME 后应用运行产生异常
- 发现新版本 Flutter 无法兼容
- 有好的点子或产品建议

上述情况均可以[提一个 issue](#how-to-issue)。

**可能你：**

- 想与开发者交流
- 想与更多 Flutter 开发者交流
- 想与 UME 开展交流或合作

欢迎[加入字节跳动 Flutter 交流群](https://applink.feishu.cn/client/chat/chatter/add_by_link?link_token=b07u55bb-68f0-4a4b-871d-687637766a68)

或随时[联系开发者](mailto:zhaorui.dev@bytedance.com)

## 如何提 Issue

1. 点击本仓库的 [Issue 页面](https://github.com/bytedance/flutter_ume/issues)
2. 先搜索是否有和你类似情况的 issue，若有请直接在该 issue 中反馈问题
3. 若没有类似情况 issue，点击 [New issue 按钮](https://github.com/bytedance/flutter_ume/issues/new/choose)
4. 选择一个适合你的 issue 模板
5. 在模板中填写对应信息
6. 如果有能复现问题的最简 Demo 就再好不过了

## 如何提 Pull Request

1. Fork 本仓库
2. 将你 fork 的仓库 clone 到本地
3. 在本地修改代码
4. 修改 example 工程的测试代码，并进行手工测试
5. 在 test 目录下，修改单元测试
6. 在本地提交改动并推送到你 fork 的仓库，commit message 格式请遵循本文 [Commit Message 规范](#commit-message) 部分
7. 在 GitHub 上创建 Pull Request，在模板中填写对应信息

## Commit Message 规范

1. 原则上请尽量使用英文
2. 涉及到参考资料的，请附链接
3. 格式：`[tags] description`
   1. `tags` 为 PR 的类型，如 `fix` 修复错误、`feat` 新增功能、`improve` 改进代码或文档
   2. `description` 为具体的改动描述

以下为标准的 Commit message 示例：

``` plaintext
[fix] README.md document syntax error
```

``` plaintext
[feat] New feature description

[https://flutter.dev/dash](https://flutter.dev/dash)
```
