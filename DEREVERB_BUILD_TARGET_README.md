# Dereverb 构建目标说明

## 概述

本文档说明了新创建的 `example_ffva_ua_adec_dereverb_altarch` 构建目标，它包含了 `example_ffva_ua_adec_altarch` 的所有功能，并额外启用了 dereverb 模块。

## 构建目标对比

### 原有目标：`example_ffva_ua_adec_altarch`
- **音频管道**: `adec_altarch_aec_ic_ns_agc_2mic_2ref`
- **包含模块**: AEC, ADEC, IC, NS, AGC, VNR
- **处理流程**: 声学回声消除 → 延迟估计校正 → 干扰消除 → 噪声抑制 → 自动增益控制

### 新目标：`example_ffva_ua_adec_dereverb_altarch`
- **音频管道**: `adec_altarch_aec_ic_ns_dereverb_agc_2mic_2ref`
- **包含模块**: AEC, ADEC, IC, NS, **DEREVERB**, AGC, VNR
- **处理流程**: 声学回声消除 → 延迟估计校正 → 干扰消除 → 噪声抑制 → **去混响** → 自动增益控制

## 新增功能

### Dereverb 模块特性
- **算法**: 改进的 WPE (Weighted Prediction Error) 算法
- **感知加权**: 基于 Bark 尺度的频率权重
- **可配置参数**:
  - 去混响强度 (0-100%)
  - 频率焦点 (低频/中频/高频)
  - 预测阶数 (1-10)
  - 延迟步长
  - 增益平滑系数

### 配置选项
在 `examples/ffva/src/app_conf.h` 中添加了：
```c
#ifndef appconfAUDIO_PIPELINE_SKIP_DEREVERB
#define appconfAUDIO_PIPELINE_SKIP_DEREVERB      0
#endif
```

## 构建方法

### 1. 构建 dereverb 模块
```bash
ninja fwk_voice_module_lib_dereverb
```

### 2. 构建新的 FFVA 目标
```bash
ninja example_ffva_ua_adec_dereverb_altarch
```

### 3. 使用测试脚本
```bash
test_build_dereverb.bat
```

## 文件结构

### 新增的 dereverb 模块
```
modules/voice/modules/lib_dereverb/
├── src/dereverb_impl.c          # 核心实现
├── api/dereverb_api.h           # 公共 API
├── doc/index.rst                # 文档
├── CMakeLists.txt               # 构建配置
└── README.rst                   # 模块说明
```

### 更新的配置文件
- `examples/ffva/ffva.cmake` - 添加了 `adec_dereverb_altarch` 管道
- `modules/audio_pipelines/reference/CMakeLists.txt` - 定义了新的音频管道
- `examples/ffva/src/app_conf.h` - 添加了 dereverb 配置选项

## 音频管道集成

### 管道配置
新的音频管道 `adec_altarch_aec_ic_ns_dereverb_agc_2mic_2ref` 在 `audio_pipeline_t0.c` 中集成了 dereverb 处理阶段：

```c
static void stage_dereverb(frame_data_t *frame_data)
{
#if appconfAUDIO_PIPELINE_SKIP_DEREVERB
#else
    int32_t DWORD_ALIGNED dereverb_output[appconfAUDIO_PIPELINE_FRAME_ADVANCE];
    configASSERT(DEREVERB_FRAME_ADVANCE == appconfAUDIO_PIPELINE_FRAME_ADVANCE);
    
    dereverb_process_frame(
                &dereverb_stage_state,
                dereverb_output,
                frame_data->samples[0]);
    memcpy(frame_data->samples, dereverb_output, appconfAUDIO_PIPELINE_FRAME_ADVANCE * sizeof(int32_t));
#endif
}
```

### 处理顺序
1. **Tile 1**: AEC 处理 (声学回声消除)
2. **Tile 0**: 
   - VNR + IC (语音噪声降低 + 干扰消除)
   - NS (噪声抑制)
   - **DEREVERB (去混响)** ⭐ **新增**
   - AGC (自动增益控制)

## 性能特点

### 延迟
- **帧大小**: 240 样本 (15ms @ 16kHz)
- **总延迟**: 最小延迟，适合实时应用

### 资源使用
- **内存**: 优化的 BFP 数据结构
- **计算**: 使用 XMOS 数学库优化
- **精度**: 32 位定点运算

## 使用场景

### 适用环境
- 会议室和会议室
- 家庭语音助手
- 车载语音系统
- 任何有混响的声学环境

### 优势
- 改善语音清晰度
- 提高语音识别准确率
- 减少环境混响影响
- 保持原始语音质量

## 故障排除

### 常见问题
1. **构建失败**: 确保 dereverb 模块已正确创建
2. **链接错误**: 检查 CMake 配置和库依赖
3. **运行时错误**: 验证音频管道配置

### 调试选项
- 启用 `DEBUG_PRINT_ENABLE=1`
- 使用 xscope 进行音频分析
- 检查管道跳过配置

## 总结

`example_ffva_ua_adec_dereverb_altarch` 构建目标成功集成了 dereverb 模块，为远场语音助手提供了强大的去混响功能。该目标保持了原有系统的所有功能，同时增加了专业的音频后处理能力，特别适合在有混响的声学环境中使用。

