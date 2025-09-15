# VitalCare Project Modification Summary
Instructiions to setting up building tools and build firmware: 
https://docs.google.com/document/d/1VChpM-qvemn7rFueaXeTY9Z4EXOQb2EEMjocmrVE9aY/edit?tab=t.0
## Modified Files List

### AGC (Automatic Gain Control) Parameter Adjustment
- `modules/voice/modules/lib_agc/api/agc_profiles.h`

### AEC (Automatic Echo Cancellation) Filter Length Optimization
- `modules/voice/examples/bare-metal/pipeline_single_threaded/src/pipeline_config.h`
- `modules/voice/examples/bare-metal/pipeline_multi_threaded/src/pipeline_config.h`
- `modules/voice/examples/bare-metal/aec_1_thread/src/aec_config.h`
- `modules/voice/examples/bare-metal/aec_2_threads/src/aec_config.h`

### AEC Parameter Aggressive Optimization
- `modules/voice/modules/lib_aec/src/aec_priv_impl.c`

### Reference Signal Detection Optimization
- `modules/voice/examples/bare-metal/shared_src/pipeline_stage_1/stage_1.h`

### Dereverberation Module Verification
- `modules/voice/modules/lib_ns/src/ns_impl.c`

## Modification Objectives
- Optimize AGC volume control for more effective volume suppression
- Enhance AEC echo cancellation capability with longer delay support and more aggressive processing
- Improve reference signal detection sensitivity
- Verify dereverberation module impact on echo cancellation

## Technical Features
- 225ms maximum echo cancellation capability
- 16kHz sample rate with 15ms frame processing
- Dual-filter adaptive algorithm
- Suitable for voice communication scenarios in various room environments
