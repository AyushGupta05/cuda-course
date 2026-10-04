# Variables 

h_variablename 
use that to define a variable on cpu 
d_variable name for gpu 

can transfer it over to gpu 

__global__ is viisble globally, means the cpu can call 
these functions. dont return anything, just do fast ops

__device__ can only be called by gpu

__host__ only runs on cpu, regular c/c++ script without cuda 

cudaMalloc = global memory 

    float *d_a, *d_b, *d_c;

ESTABLISH THE VARIABLES AS NORMAL 

    cudaMalloc(&d_a, N*N*sizeof(float));
    cudaMalloc(&d_b, N*N*sizeof(float));
    cudaMalloc(&d_c, N*N*sizeof(float));

    ALLOCATE THE VARIABLES ON GPU , ENOUGH MEMORY TO STORE 
    N*N FLOATS . THIS ONLY ALLOCATES SPACE, DOESNT ACTUALLY COPY DATA

    cudaMemcpy - device to host (GPU TO CPU), 
    host to device( CPU TO GPU), 
    device to device  (GPU TO diff GPU location)
    - **`cudaMemcpyHostToDevice`**, **`cudaMemcpyDeviceToHost`**, or **`cudaMemcpyDeviceToDevice`**

    cudaFree will free memory 

nvcc is the compiler

passes host code to normal compiler for cpu instructions
compiles gpu device code to ptx, a gpu instriction format


imagine you have a giant 3d cubic volume (a grid), in this there are smaller cubic volumes (blocks), and each block has things called threads, which do math ops 

individual threads can communicate inside these blocks 
this helps with parralelism of gpus, once everyone does there parts correctly


- `gridDim` ⇒ number of blocks in the grid
- `blockIdx` ⇒ index of the block in the grid
- `blockDim` ⇒ number of threads in a block
- `threadIdx` ⇒ index of the thread in the block

each of these variables tells the thread where it is 
suppose we launch 
kernel<<<4, 256>>>(); (4 blocks, 256 threads per block)

gridDim.x = 4 (4 blocks in grid)
blockIdx.x  (which block am i in, 0,1,2,3)

blockDim.x = 256 (no of threads in each block)

threadIdx.x = (which thread am i inside my block, 0..255)

overlal thread position - 
int i = blockIdx.x * blockDim.x + threadIdx.x;


each thread has local memory/registers and is private to that thread. **the thread index itself tells you how to index into the data**



Warps - groups of 32 threads the gpu executes together . gpu doesnt schedule threads indepdenntly, it scheduels threads

grids -> blocks -> warps -> 32 threads
warp scheduler makes the warp run

sm = streaming multiprocessor