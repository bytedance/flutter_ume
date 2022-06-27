# Changelog

[简体中文](./CHANGELOG_cn.md)

## [1.0.0]

* Normal version with adaption of Flutter 3.
* Feature: Anywhere door (Route)

## [1.0.0-dev.0]

* Adapt Flutter 3.

## [0.3.0+1]

* Fix the version error

## [0.3.0]

* Remove static function. Use the `UMEWidget`.
* Allow insert `Widget` into Widget tree, in order to access new plugin easily.
* Fix the issue of multiple instances of FloatingWidget caused by the refresh state.
* Fix the isseue that the plugin is not displayed due to the first layout exception in AOT mode

## [0.3.0]

* 移除静态方法，更换为壳 Widget
* 允许在 Widget tree 增加自定义嵌套结构组件，从而快速接入新插件
* 修复刷新状态引发的浮窗组件出现多实例的问题
* 修复在 AOT 模式下首次布局异常导致插件不展示的问题

## [0.2.1]

* Remove the extra MaterialApp Widget

## [0.2.0-dev.0]

* Adapted Null-Safety.

## [0.1.0+1]

* Add some docs comments, modify description in pubspec.yaml.

## [0.1.0]

* Open source.
