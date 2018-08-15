#include <climits>
#include <cmath>
#include <cstdio>
#include <iostream>

struct cache_content {
  bool v; // verify bit
  unsigned int tag;
  unsigned int time_stamp; // time stamp for last use
};

const int K = 1024;

void simulate(int cache_size, int ways) {
  const int block_size = 64;
  unsigned int tag, index, x;
  unsigned int total = 0, miss = 0;

  int offset_bit = log2(block_size); // 2^(offset_bit) bytes per one block
  int index_bit = log2((cache_size / block_size) / ways);
  int index_size = (cache_size / block_size) / ways;

  cache_content cache[index_size][ways];

  for (int i = 0; i < index_size; i++) // instart, every line is empty
    for (int j = 0; j < ways; j++)
      cache[i][j].v = false;

  FILE *fp = std::fopen("RADIX.txt", "r"); // read file

  while (fscanf(fp, "%x", &x) != EOF) {
    index = (x >> offset_bit) & (index_size - 1); // filter the index bits
    tag = x >> (index_bit + offset_bit);          // filter the tag bits
    bool hit = false, empty = false;

    for (int i = 0; i < ways; i++) {
      if (cache[index][i].v && cache[index][i].tag == tag) {
        cache[index][i].time_stamp = total;
        hit = true; // hit
        break;
      }
    }

    if (hit == false) { // miss
      miss++;

      for (int i = 0; i < ways; i++) {
        if (cache[index][i].v == false) {
          empty = true; // some idle space for new data
          cache[index][i].v = true;
          cache[index][i].tag = tag;
          cache[index][i].time_stamp = total;
        }
      }

      if (empty == false) { // there are no idle space
        int earliest = INT_MAX, LRU = -1;
        for (int i = 0; i < ways; i++) { // find LRU block
          if (cache[index][i].time_stamp <= earliest) {
            earliest = cache[index][i].time_stamp;
            LRU = i;
          }
        }

        cache[index][LRU].tag = tag;
        cache[index][LRU].time_stamp = total;
      }
    }
    total++; // add time stamp
  }
  std::cout << "Cache size: " << cache_size / 1024 << 'K' << " ways: " << ways;
  std::cout << " miss rate: " << double(miss) * 100 / double(total) << "\n";
  fclose(fp);
}

int main() {
  for (int i = 1; i <= 32; i <<= 1)
    for (int j = 1; j <= 8; j <<= 1) {
      simulate(i * K, j);
    }
  return 0;
}
