#ifndef __MAPPER_H__
#define __MAPPER_H__

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include "/usr/local/cuda/targets/x86_64-linux/include/cuda_runtime.h"






enum comp_start{
	WITH_START,
	WITHOUT_START
};

enum algo_type{
	LOCAL,
	GLOBAL,
	SEMI_GLOBAL
};


//kernel data
typedef struct {
	uint8_t *unpacked_query_batch;
	uint8_t *unpacked_target_batch;
	uint32_t *packed_query_batch;
	uint32_t *packed_target_batch;
	uint32_t *query_batch_offsets;
	uint32_t *target_batch_offsets;
	uint32_t *query_batch_lens;
	uint32_t *target_batch_lens;
	int32_t *aln_score;
	int32_t *query_batch_end;
	int32_t *target_batch_end;
	int32_t *query_batch_start;
	int32_t *target_batch_start;
	uint32_t max_query_batch_bytes;
	uint32_t max_target_batch_bytes;
	uint32_t max_n_alns;

} mapper_gpu_storage_t;



//match/mismatch and gap penalties
typedef struct{
	int32_t match;
	int32_t mismatch;
	int32_t gap_open;
	int32_t gap_extend;
} mapper_subst_scores;



#ifdef __cplusplus
extern "C" {
#endif


void mapper_aln(mapper_gpu_storage_t *gpu_storage, const uint8_t *query_batch, const uint32_t *query_batch_offsets, const uint32_t *quer_lens, const uint8_t *target_batch, const uint32_t *target_batch_offsets, const uint32_t *target_batch_lens,   const uint32_t actual_query_batch_bytes, const uint32_t actual_target_batch_bytes, const uint32_t actual_n_alns, int32_t *host_aln_score, int32_t *host_query_batch_start, int32_t *host_target_batch_start, int32_t *host_query_batch_end, int32_t *host_target_batch_end,  int algo, int start);

void mapper_gpu_mem_alloc(mapper_gpu_storage_t *gpu_storage, int max_query_batch_bytes, int max_target_batch_bytes, int max_n_alns, int algo, int start);

void mapper_gpu_mem_free(mapper_gpu_storage_t *gpu_storage);

void mapper_copy_subst_scores(mapper_subst_scores *subst);



#ifdef __cplusplus
}
#endif

#endif
