# audiotool 包

这是一个 Go 语言包，提供了一套用于常见音频处理任务的工具。它允许您对 MP3 和 WAV 格式的音频文件进行混音、拼接以及组合操作。

## 功能特性

-   **音频混合**: 将主音轨与背景音轨混合，并可独立控制音量。
-   **音频拼接**: 将主音轨插入到背景音轨中，并使用背景音的开头和结尾作为前奏和尾声。
-   **组合操作**: 通过一次便捷的函数调用，同时完成混音和拼接。
-   **自动格式转换**: 在处理前，自动将所有音频转换为标准格式（44.1kHz, 16位, 立体声），以处理不同的采样率和声道数。

## 安装

```bash
go get github.com/your-username/your-repo/audiotool
```

## 如何使用

首先，在您的 Go 项目中导入本包：

```go
import "github.com/your-username/your-repo/audiotool"
```

然后，创建一个 `AudioMixer` 实例并调用其方法。

### 示例 1: 混合两个音频文件

此示例将 `song.mp3` 与 `background.mp3` 混合，并将背景音量设置为 10%。最终音频的长度将与 `song.mp3` 保持一致。

```go
package main

import (
    "log"
    "path/to/your/project/audiotool"
)

func main() {
    mixer := audiotool.NewAudioMixer()

    err := mixer.MixAudioFiles(
        "song.mp3",
        "background.mp3",
        "mixed_output.wav",
        1.0,  // 主音频音量 (100%)
        0.1,  // 背景音频音量 (10%)
    )

    if err != nil {
        log.Fatalf("混音文件时出错: %v", err)
    }
}
```

### 示例 2: 拼接音频文件

此示例将 `main_vocal.mp3` 插入到 `instrumental.mp3` 中。最终的输出将由 `instrumental.mp3` 的前10秒、完整的 `main_vocal.mp3` 以及 `instrumental.mp3` 的最后15秒组成。

```go
package main

import (
    "log"
    "path/to/your/project/audiotool"
)

func main() {
    mixer := audiotool.NewAudioMixer()

    err := mixer.SpliceAudioFiles(
        "main_vocal.mp3",
        "instrumental.mp3",
        "spliced_output.wav",
        10.0, // 使用器乐的前10秒作为前奏
        15.0, // 使用器乐的后15秒作为尾声
    )

    if err != nil {
        log.Fatalf("拼接文件时出错: %v", err)
    }
}
```

### 示例 3: 组合混合与拼接

这是最强大的功能。它首先混合主音频和背景音频，然后将混合结果插入到背景音轨的前奏和尾声之间。

```go
package main

import (
    "log"
    "path/to/your/project/audiotool"
)

func main() {
    mixer := audiotool.NewAudioMixer()

    err := mixer.MixAndSpliceAudio(
        "main_vocal.mp3",
        "background.mp3",
        "combo_output.wav",
        1.0,   // 主音频音量 (100%)
        0.15,  // 用于混合部分的背景音量 (15%)
        10.0,  // 来自 background.mp3 的前奏 (10秒)
        15.0,  // 来自 background.mp3 的尾声 (15秒)
    )

    if err != nil {
        log.Fatalf("执行组合操作时出错: %v", err)
    }
}
```

## 注意事项

-   本包会自动处理格式差异。
-   输出文件为标准的 WAV 格式。如果您需要 MP3 格式，本工具会提示您使用像 FFmpeg 这样的外部转换器。 