# Contributing

[简体中文](./CONTRIBUTING.md)

Thank you for your interest in open source contributions.
Not only the code, but also contributions such as issues and rich documents are also welcome.

Please follow the guidelines in this article to make open source contributions to the UME project.

- [Contributing](#contributing)
  - [How to contact author](#how-to-contact-author)
  - [How to raise an Issue](#how-to-raise-an-issue)
  - [How to raise a Pull Request](#how-to-raise-a-pull-request)
  - [Commit Message specification](#commit-message-specification)

## How to contact author

**Maybe...**

- Found a bug in the code, or an error in the documentation
- Produces an exception when you use the UME
- UME is not compatible with the new version Flutter
- Have a good idea or suggestion

You can [submit an issue](#how-to-raise-an-issue) in any of the above situations。

**Maybe...**

- Communicate with the author
- Communicate with more community developers
- Cooperate with UME

Welcome to [Join the ByteDance Flutter Exchange Group](https://applink.feishu.cn/client/chat/chatter/add_by_link?link_token=b07u55bb-68f0-4a4b-871d-687637766a68).

Or contact [author](mailto:zhaorui.dev@bytedance.com).

## How to raise an Issue

1. Go to [Issues](https://github.com/bytedance/flutter_ume/issues).
2. Search for similar situations, if there is a match, directly feedback in it.
3. If there is not, press [New issue](https://github.com/bytedance/flutter_ume/issues/new/choose) to raise a new one.
4. Select a template.
5. Describe your situation, and fill in the template.
6. It is better to attach a demo that can reproduce the problem.

## How to raise a Pull Request

1. Fork the repository.
2. Clone your fork repository.
3. Edit code.
4. Edit test code in example project, and test it manually.
5. Edit unit test in test directory.
6. Commit your changes and push it. Please follow the [Commit Message specification](#commit-message-specification) to write the commit message.
7. Create Pull Request in GitHub, and fill in the template.

## Commit Message specification

1. Please use english.
2. If you have references, please attach a link.
3. Format: `[tags] description`
   1. `tags` is the type of PR, such as `fix`, `feat`, `improve`.
   2. `description` is used to describe changes.

The following is a standard Commit message example:

``` plaintext
[fix] README.md document syntax error
```

``` plaintext
[feat] New feature description

[https://flutter.dev/dash](https://flutter.dev/dash)
```
