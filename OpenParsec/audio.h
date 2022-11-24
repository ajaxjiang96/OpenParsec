#pragma once

#include <stdint.h>

struct audio;

void audio_init(struct audio **ctx_out);
void audio_destroy(struct audio **ctx_out);

void audio_cb(const int16_t *pcm, uint32_t frames, void *opaque);
