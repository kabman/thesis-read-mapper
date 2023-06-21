

## Requirements
A Linux platform installed with CUDA toolkit 8 or higher. 

## Compiling mapper
To compile the library, run the following two commands following commands:

```
$ ./configure.sh <path to cuda installation directory>
$ make GPU_SM_ARCH=<GPU SM architecture> MAX_SEQ_LEN=<maximum sequence length> N_CODE=<code for "N", e.g. 0x4E if the bases are represented by ASCII characters> [N_PENALTY=<penalty for aligning "N" against any other base>]
```


## Using mapper
To use mapper  alignment functions, first the match/mismatach scores and gap open/extension penalties need to be passed on to the GPU. Assign the values match/mismatach scores and gap open/extension penalties to the members of `mapper_subst_scores` struct:

```
typedef struct{
	int32_t match;
	int32_t mismatch;
	int32_t gap_open;
	int32_t gap_extend;
}mapper_subst_scores;
```

The values are passed to the GPU by calling `mapper_copy_subst_scores()` function:

```


## Example
The `test_prog` directory conatins an example program which uses mapper for sequence alignment on GPU. See the README in the directory for the instructions about running the program.

