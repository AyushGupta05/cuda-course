#include <stdio.h>

__global__ void whoami(void) { 
//this function runs on the gpu and is luanched from the cpu 
// who am i is the cuda function name 

    int block_id =
        blockIdx.x +    // apartment number on this floor (points across)
        blockIdx.y * gridDim.x +    // floor number in this building (rows high)
        blockIdx.z * gridDim.x * gridDim.y;   // building number in this city (panes deep)


// we have a 3d block, we want to flatten it to make indexing easier 
// 0 indexing so its a fomrula form that
    int block_offset =
        block_id * // times our apartment number
        blockDim.x * blockDim.y * blockDim.z; // total threads per block (people per apartment)

// block dim is threads in block, so block offset yay


    int thread_offset =
        threadIdx.x +  
        threadIdx.y * blockDim.x +
        threadIdx.z * blockDim.x * blockDim.y;
    int id = block_offset + thread_offset; // global person id in the entire apartment complex

    printf("%04d | Block(%d %d %d) = %3d | Thread(%d %d %d) = %3d\n",
        id,
        blockIdx.x, blockIdx.y, blockIdx.z, block_id,
        threadIdx.x, threadIdx.y, threadIdx.z, thread_offset);
    // printf("blockIdx.x: %d, blockIdx.y: %d, blockIdx.z: %d, threadIdx.x: %d, threadIdx.y: %d, threadIdx.z: %d\n", blockIdx.x, blockIdx.y, blockIdx.z, threadIdx.x, threadIdx.y, threadIdx.z);
// block offset + what threads its on
}

int main(int argc, char **argv) {

    //nornal c program entry point

    const int b_x = 2, b_y = 3, b_z = 4;
    const int t_x = 4, t_y = 4, t_z = 4; 
    
    // creating variables yipee , the b thing defines grid dimension 
    // t defines each dimension size of thread in blocks 
    //24 blocks
//64 threads per block
//1536 total threads
    // // the max warp size is 32, so 
    // we will get 2 warp of 32 threads per block

    int blocks_per_grid = b_x * b_y * b_z;
    int threads_per_block = t_x * t_y * t_z;

    // yipee

    printf("%d blocks/grid\n", blocks_per_grid);
    printf("%d threads/block\n", threads_per_block);
    printf("%d total threads\n", blocks_per_grid * threads_per_block);

    dim3 blocksPerGrid(b_x, b_y, b_z); // 3d cube of shape 2*3*4 = 24
    dim3 threadsPerBlock(t_x, t_y, t_z); // 3d cube of shape 4*4*4 = 64

    // dim3 is a cuda type that stores three dimensions x,y,z 

    whoami<<<blocksPerGrid, threadsPerBlock>>>();

    // actual kernel launch
    // kernel<<<grid_dimensions, block_dimensions>>>();
    cudaDeviceSynchronize();
    // wait her euntil the gpu has finish everything, because cpu immedaitely continues normally after giving instruction

}