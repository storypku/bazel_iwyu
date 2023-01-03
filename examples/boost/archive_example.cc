#include <iostream>

#include "boost/archive/text_oarchive.hpp" // IWYU pragma: keep
#include "boost/serialization/base_object.hpp"
#include "boost/serialization/export.hpp"

struct Base {
  virtual ~Base() = default;
  template <typename Ar> void serialize(Ar &, unsigned) {}
};

struct MyStruct : Base {
  template <typename Ar> void serialize(Ar &ar, unsigned) {
    ar &boost::serialization::base_object<Base>(*this);
  }
};

BOOST_CLASS_EXPORT_GUID(Base, "98e8e3ea-a14a-4875-89d9-6dc58e10002c")
BOOST_CLASS_EXPORT_GUID(MyStruct, "97e71ba2-8cb9-45b4-803f-809676925e5c")

BOOST_SERIALIZATION_FACTORY_0(MyStruct)

int main() {
  using namespace boost::serialization;

  std::string s = guid<MyStruct>();
  std::cout << s << "\n";

  extended_type_info const *eti = extended_type_info::find(s.c_str());

  Base *p = static_cast<MyStruct *>(eti->construct());
  std::cout << std::boolalpha << (!!p) << "\n";
  return 0;
}
