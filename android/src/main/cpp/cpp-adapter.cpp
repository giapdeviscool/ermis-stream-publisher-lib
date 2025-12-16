#include <jni.h>
#include "ermisstreampublisherlibOnLoad.hpp"

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM* vm, void*) {
  return margelo::nitro::ermisstreampublisherlib::initialize(vm);
}
