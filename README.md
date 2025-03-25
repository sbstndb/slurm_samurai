
This repo is related to the Samurai project : https://github.com/hpc-maths/samurai

## Objective : 

- Want to profile scalability of the project Samurai
	-	Want single and multi node profiling
	-	Want uniform and adapted grid profiling
	-	Want to profile various test-cases like advection-2d

## Method :
- We use SLURM as a job manager
- I prefer launching N job per study since all nodes have the exact same performance. This approach is more flexible and robust. 

## TODO : 
- [ ] Binding benchmark scripts

## Files

Here are the diferent files of this repo : 

- `old directory` : Here are the old scripts doing an experimental design
- `plan_mra.sh` : Experimental design varying the number of MPI ranks on adapted meshs
- `plan_uniform.sh` : Experimental design varying the number of MPI ranks on uniform meshs
- `testcase_dist.sh` : Launch a test-case in distributed case
- `testcase.sh` : Launch a test-case on a single node
- `plan_mra_minlevel9.sh` : Same but with minlevel to 9, reduce the amount of MPI communications
- `print_timing.sh` : Command to grep the total walltime in a log file printed with --timers, just in case. 


