#include <atomic>
#include <iostream>

int main() {
  struct Test {
    int val;
  };
  std::atomic<Test> s;
  std::cout << std::boolalpha << s.is_lock_free() << std::endl;
  std::atomic_int my_num;
  ++my_num;
  std::cout << "my_num: " << my_num << std::endl;
  return 0;
}
