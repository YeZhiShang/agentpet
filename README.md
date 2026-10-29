# AgentPet · 鲸鱼娘桌宠

Windows 桌面宠物（PowerShell + WPF），会读本机的 Agent 会话文件，实时播报 AI 在干什么；点她一下能看到 DeepSeek 余额或 Codex 额度。

## 特点

- **状态联动**：读取 Antigravity / Codex / DSH 的本地会话文件，显示「思考中 / 写代码 / 等你回答 / 卡住了」
- **余额看板**：DeepSeek 余额（实时）+ 今日/累计消耗（本地累计），Codex 额度一并支持，按当前在跑的 Agent 自动切换
- **四种角色**：小克（Claude娘）、白龙（GPT娘）、双子（Gemini娘）、小鲸鱼（DeepSeek娘），各自独立配色与台词
- **纯本地**：除余额查询外不联网，无遥测

## 快速开始

```
双击  启动 AgentPet.bat
```

首次运行会生成配置；把 DeepSeek API Key 填进 `app/config.json` 的 `DeepSeekApiKey` 即可显示余额。

> 需要 Windows 10/11 + PowerShell 5.1（系统自带）。

## 目录

| 路径 | 内容 |
|---|---|
| `app/` | 程序本体（`AgentPet.ps1` / `AgentPet.xaml` / 立绘 / 监控守护进程） |
| `docs/` | 架构说明、常见问题、第三方致谢与授权 |
| `backup/` | 本地备份（不入库） |

## 授权

本项目基于 [uoweme325/AgentPet](https://github.com/uoweme325/AgentPet) 开发完成，增添了部分功能以及立绘。

- 代码：MIT
- 立绘与音效：社区二创素材，**仅限个人学习与非营利使用**
- 「小鲸鱼」立绘来自 [YunYueSama/codex-deepseek-pet](https://github.com/YunYueSama/codex-deepseek-pet)，按大肥鱼项目署名许可 1.0 使用

详见 [docs/THIRD_PARTY_NOTICES.md](docs/THIRD_PARTY_NOTICES.md)。
