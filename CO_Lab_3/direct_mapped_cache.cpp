#include <cmath>
#include <cstdio>
#include <iostream>

struct cache_content {
  bool v;
  unsigned int tag;
  // unsigned int data[16];
};

const int K = 1024;

void simulate(int cache_size, int block_size) {
  unsigned int tag, index, x;
  unsigned int count = 0, miss = 0;

  int offset_bit = log2(block_size);
  int index_bit = log2(cache_size / block_size);
  int line = cache_size >> (offset_bit);

  cache_content *cache = new cache_content[line];

  for (int j = 0; j < line; j++)
    cache[j].v = false;

  FILE *fp = std::fopen("ICACHE.txt", "r");
  // FILE *fp = std::fopen("DCACHE.txt", "r");
  // FILE *fp = std::fopen("Trace.txt", "r");

  while (std::fscanf(fp, "%x", &x) != EOF) {
    count++;
    index = (x >> offset_bit) & (line - 1);
    tag = x >> (index_bit + offset_bit);

    if (cache[index].v && cache[index].tag == tag) {
      cache[index].v = true; // hit
    } else {
      cache[index].v = true; // miss
      cache[index].tag = tag;
      miss++;
    }
  }

  std::fclose(fp);
  delete[] cache;

  std::cout << "cache_size:" << cache_size << "    ";
  std::cout << "block_size:" << block_size << '\n';
  std::cout << "miss rate:" << (miss / (double)count) * 100 << '%' << '\n';
}

int main() {
  // cache size range: 32 ~ 256
  // block size range: 4 ~ 32
  for (int i = 32; i <= 256; i <<= 1) {
    for (int j = 4; j <= 32; j <<= 1) {
      simulate(i, j);
    }
    std::cout << "\n";
  }
  return 0;
}
