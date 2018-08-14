#include <cstdio>
#include <iostream>

struct cache_content {
  bool v;
  unsigned int tag;
  // unsigned int data[16];
};

// my own log2
int log2(int n) {
  int m = 0;
  while (n >>= 1)
    ++m;
  return m;
}

const int K = 1024;

void simulate(int cache_size, int block_size) {
  unsigned int tag, index, x;

  int offset_bit = log2(block_size);
  int index_bit = log2(cache_size / block_size);
  int line = cache_size >> (offset_bit);

  int no_of_access;
  int no_of_miss;

  cache_content *cache = new cache_content[line];
  std::cout << "cache_size:" << cache_size << "    ";
  std::cout << "block_size:" << block_size << std::endl;
  // std::cout << "cache line:" << line << "    ";
  // std::cout << "offset_bit:" << offset_bit << "    ";
  // std::cout << "index_bit:"  << index_bit << std::endl;

  for (int j = 0; j < line; j++)
    cache[j].v = false;

  // FILE *fp = std::fopen("DCACHE.txt", "r");
  FILE *fp = std::fopen("ICACHE.txt", "r");
  if (!fp) {
    std::cerr << "test file open error!" << std::endl;
  }

  no_of_access = no_of_miss = 0;
  while (std::fscanf(fp, "%x", &x) != EOF) {
    no_of_access++;

    index = (x >> offset_bit) & (line - 1);
    tag = x >> (index_bit + offset_bit);

    if (cache[index].v && cache[index].tag == tag) {
      cache[index].v = true; // hit
    } else {
      cache[index].v = true; // miss
      cache[index].tag = tag;
      no_of_miss++;
    }
  }

  std::fclose(fp);

  delete[] cache;

  std::cout << "miss rate:" << (no_of_miss / (double)no_of_access) * 100 << '%'
            << std::endl;
}

int main() {
  // Let us simulate 4KB cache with 16B blocks
  // simulate(1024, 32, 2);
  for (int i = 64; i <= 512; i <<= 1) {
    // simulate(i, 0);
    for (int j = 4; j <= 32; j <<= 1) {
      simulate(i, j);
    }
    std::cout << "\n";
  }
  return 0;
}
