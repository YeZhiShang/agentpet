# AgentPet · 深鲸娘桌宠

Windows 桌面宠物（PowerShell + WPF 原生实现）。她会读取本机上 Antigravity / Codex / DeepSeek Harness 的会话文件，实时播报 AI 正在做什么；点她一下，可以看 DeepSeek 余额或 Codex 额度。

> 本项目基于 [uoweme325/AgentPet](https://github.com/uoweme325/AgentPet) v1.4.1 二次开发，增添了 DeepSeek 余额看板、第四位角色与一批稳定性修复。

## 功能

- **状态联动**：读取三个 Agent 的本地会话文件，显示「思考中 / 写代码 / 等你回答 / 卡住了」，多会话并行时标注 ×N。
- **余额看板**：DeepSeek 余额（实时）与 Codex 额度（5 小时 / 每周）共用一块面板，按当前在跑的 Agent 自动切换。
- **低余额提醒**：低于阈值时弹一次，默认 ¥5，可调可关。
- **四位角色**：各自独立的配色、台词与托盘图标。
- **纯本地**：除余额查询外不联网，无遥测。

| 小克（Claude娘） | 白龙（GPT娘） | 双子（Gemini娘） | 小鲸鱼（DeepSeek娘） |
| :---: | :---: | :---: | :---: |
| ![小克](app/assets/characters/claude-happy.png) | ![白龙](app/assets/characters/dragon-happy.png) | ![双子](app/assets/characters/gemini-happy.png) | ![小鲸鱼](app/assets/characters/deepseek-happy.png) |

## 运行要求

| 项目 | 说明 |
|---|---|
| 系统 | Windows 10 / 11 |
| PowerShell | 5.1（系统自带） |
| Node.js | **需要**。缺失时只有桌宠本体，没有状态播报与余额 |
| 网络 | 仅余额查询访问 `api.deepseek.com` |

## 快速开始

1. 解压后双击 **`启动 AgentPet.bat`**
2. 首次运行会自动生成 `app/config.json`
3. 想用余额看板：把 DeepSeek API Key 填进 `app/config.json` 的 `DeepSeekApiKey`

| 操作 | 方式 |
|---|---|
| 启动 | `启动 AgentPet.bat` |
| 退出 | 右键桌宠 → 退出，或 `退出 AgentPet.bat` |
| 桌面快捷方式 | `创建桌面快捷方式.bat` |
| 开机自启 | `开机自启设置 (可选).bat`（选 1 开启 / 2 关闭） |

## 看板说明

- **面板三种**：工作状态、额度、随机台词。忙碌时优先显示工作状态，空闲时按 `BubbleMode` 显示。
- **额度面板两种形态**：DeepSeek 余额（`money`）与 Codex 额度。`QuotaProvider` 为 `auto` 时，DSH 在跑就显示余额，Codex 在跑就显示额度。
- **左键点她**：切到看板并触发一次刷新，8 秒内不会被工作状态抢回去。
- **数据口径**：余额是实时值；「今日 / 累计」是**本地累计** —— 每次刷新和上次余额比，掉了多少记多少，因此只统计程序运行期间观察到的消耗。

## 1.5.0 更新

**新增**

- DeepSeek 余额看板（直连官方 `/user/balance`，与 Codex 额度共存并自动切换）
- 第四位角色「小鲸鱼」及配套主题配色、台词、托盘图标
- 低余额提醒（边沿触发，忙时顺延不丢失）

**修复**

- 启动时窗口跑到屏幕外（窗口未显示时 DPI 读到 1.0，拿物理像素边界校验 DIP 坐标）
- 拖动能把角色拖出屏幕（改为整窗限制在工作区内）
- 手改 `config.json` 里的 `DeepSeekApiKey` / `QuotaProvider` 会被程序保存时覆盖回旧值
- `.bat` 全为 LF 换行导致 cmd 无法解析
- 快捷方式脚本遇到含单引号的路径会失效
- 开机自启条目在目录调整后指向旧路径

**整理**

- 根目录只留启动脚本，程序、文档、备份分目录
- 仓库行尾规范化（仓库存 LF，检出按类型还原 CRLF），`.gitignore` 排除配置与运行时文件

## 授权与致谢

- **程序代码**：MIT（见 [docs/LICENSE](docs/LICENSE)）
- **立绘与音效**：社区二创素材，**仅限个人学习与非营利使用，禁止商用**
- **「小鲸鱼」立绘**：来自 [YunYueSama/codex-deepseek-pet](https://github.com/YunYueSama/codex-deepseek-pet)，按大肥鱼项目署名许可 1.0 使用（允许使用/修改/分享及商用，须署名）
- 参考项目：[T7moris/GPT-Niang](https://github.com/T7moris/GPT-Niang)（WPF 悬浮窗与圆角菜单）、[PC2005-cloud/dsh-pet](https://github.com/PC2005-cloud/dsh-pet)（状态文案）、ZipZipPipe 等社区同人作者

详细的分项声明见 [docs/THIRD_PARTY_NOTICES.md](docs/THIRD_PARTY_NOTICES.md)，本机的开发与排障记录见 [docs/LOCAL-NOTES.md](docs/LOCAL-NOTES.md)。

## 隐私与免责

本项目按设计完全在本地运行：读取本地会话文件生成状态，余额查询只发往 DeepSeek 官方接口，不含遥测或数据回传。软件按「原样」提供，不附带任何担保；额度与余额数据仅供参考，请以官方控制台为准。

本项目为第三方非官方工具，与 Anthropic、OpenAI、Google、DeepSeek 及其关联实体无任何官方关系。
