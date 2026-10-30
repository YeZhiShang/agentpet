# 这个目录是什么

**AgentPet v1.5.0**（PowerShell + WPF 原生实现）的一个本地改造版：
读本机的 Agent 会话文件（Antigravity / Codex / DSH）播报工作状态，并把原来的「Codex 额度」换成了「DeepSeek 余额」。

## 目录结构

```
D:\桌宠\
├─ 启动 AgentPet.bat          双击启动
├─ 退出 AgentPet.bat          双击退出（也可以右键桌宠 → 退出）
├─ 创建桌面快捷方式.bat
├─ 开机自启设置 (可选).bat     选 1 开启 / 2 关闭
│
├─ app\                      程序本体
│   ├─ AgentPet.ps1          主程序
│   ├─ AgentPet.xaml         界面
│   ├─ launch.vbs            无窗口启动器
│   ├─ config.json           配置（含明文 API Key）
│   ├─ assets\               立绘、图标、音效、台词
│   └─ runtime\              agent-monitor.mjs 及运行时状态/日志
│
├─ docs\                     文档与许可
└─ backup\                   改代码前的备份（可删）
```

根目录只留 4 个启动用脚本，其余全部归类到 `app\` / `docs\` / `backup\`。

## 配置

`app\config.json`：

| 字段 | 说明 |
|---|---|
| `Character` | `claude` / `dragon` / `gemini` |
| `Scale` `BubbleScale` `FontScale` | 整体缩放 |
| `Left` `Top` | 窗口位置（DIP），`-1` 表示自动贴右下角 |
| `BubbleMode` | `quota` / `quote` |
| `QuotaProvider` | `auto`（跟随 Agent）/ `deepseek` / `codex` |
| `DeepSeekApiKey` | 余额查询用的 key |
| `StallDetectSeconds` | 多久没动静算「卡住」 |

## 余额看板

| 项 | 来源 |
|---|---|
| 余额 | 官方 `GET https://api.deepseek.com/user/balance`（实时） |
| 今日 / 累计 | **本地累计**：每次刷新和上次余额比，掉了多少记多少 |

官方没有「已用额度」接口，所以今日/累计只统计本程序运行期间观察到的消耗；
关掉一周再打开，那一周的消耗不会补记。

看板常驻时机：Agent 空闲时气泡默认显示它；Agent 忙时优先显示工作状态。
左键点她会临时切过来（8 秒内不会被自动切回），并顺手触发一次刷新。

## 看板跟随 Agent

`QuotaProvider` 默认 `auto`：

| 当前在跑的 Agent | 点她看到的 |
|---|---|
| DSH / Antigravity | DeepSeek 余额 |
| Codex | Codex 5 小时 / 每周额度 |

monitor 每轮把两张看板都算好，按 `runtime-status.json` 的 `source` 选默认那张。
Codex 那侧要拉 CLI，比较贵，只有它在跑（或被强制）时才刷新。

## 几个已修复的坑

- **启动跑到屏幕外**：窗口显示前 `PresentationSource` 为空，DPI 读到 1.0，拿物理像素边界去校验 DIP 坐标 → 误判通过。现在改用 `SystemParameters.VirtualScreen*`（DIP）。
- **拖动可以拖出屏幕**：原来限制的是「角色中心在屏内」，现在限制整个窗口。
- **手改的 key 被覆盖**：`Save-Config` 写盘前会先读磁盘，`DeepSeekApiKey` / `QuotaProvider` 以磁盘值为准。
- **.bat 全部是 LF 换行**：cmd 解析不了，已改 CRLF（GBK 编码保持不变）。
- **config.json 带 BOM**：Node 侧 `JSON.parse` 会失败，读取时先剥 BOM。

## 许可

- 程序代码：MIT（见 `docs\LICENSE`）
- 立绘与音效：社区二创素材，**仅限个人学习与非营利使用，禁止商用**（见 `docs\THIRD_PARTY_NOTICES.md`）

## 低余额提醒（2026-10-30 移植自上游 v1.5.0）

余额低于阈值时弹一次气泡（边沿触发：从"不低"变"低"才提醒，回到阈值以上后重新武装）。

```json
"LowBalanceAlertEnabled": true,
"LowBalanceCnyThreshold": 5.0
```

抑制条件：Agent 正在忙 / 气泡被手动隐藏 / 正在看面板（8 秒内）—— 这些情况下**不置位**，
等条件合适了再提醒，不会漏掉。启动后有 4 秒宽限期，先让 Agent 状态报上来。

monitor 侧的 `windows[0].amount` 提供数值，PS1 不再需要从 "¥44.87" 里解析。

## 快捷方式脚本（2026-10-30 修复）

原来是把路径直接拼进 PowerShell 的 `-Command` 字符串，路径带单引号会破坏语法。
现在改成通过**环境变量**传参 + `[char]34` 生成引号，并加了存在性检查与创建后校验输出。
