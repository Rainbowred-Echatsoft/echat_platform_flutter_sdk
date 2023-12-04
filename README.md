# echat_platform_flutter_sdk

A new EChat Platform Flutter SDK.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Git管理

### 1. 代码提交

**提交范围**

1. 功能独立，可以进行有效撤回的代码
2. 提交不能独立撤回的代码，在合并主要分支前通过rebase合并
3. 请勿单次提交过多代码，避免多个功能混合在一起，不利于代码回溯

**命名规范：**

1. 方便快速浏览查找，回溯之前的工作内容
2. 统一风格方便查找
3. 可以通过git commit的message来自动生成changelog

<type>(<scope>): <subject>

type:
feat - 新功能 feature
fix - 修复 bug
docs - 文档注释
style - 代码格式(不影响代码运行的变动)
refactor - 重构、优化(既不增加新功能，也不是修复bug)
perf - 性能优化
test - 增加测试
chore - 构建过程或辅助工具的变动
revert - 回退
build - 打包

scope: 功能范围
subject: 简述

例如：

`feat(iOS): 新增用户登录功能实现`
`feat(Android): 更新原生依赖库版本`
`test(roam): 漫游API测试`
`chore(flutter): 更新Flutter依赖库版本`


### 2. 分支规范

**发布分支：release前缀**

该分支为发布版本时使用，所有开发或修复的功能都会合并到该分支，发布版本时，会合并到release分支，并打上tag。当前分支不能直接提交代码，需要在gitlab中提交pull request。

**开发分支：**

按照feature/xxx的格式命名，例如：
1. Android开发分支：feature/android/xxx
   1. 开发会员功能：feature/android/user-system
2. iOS开发分支：feature/ios/xxx

**BUG修复分支：**
按照fix/xxx的格式命名，例如：
1. Android BUG修复分支：fix/android/xxx
    1. 修复消息数变动失效：fix/android/unread-count-change-failure
2. iOS BUG修复分支：fix/ios/xxx


