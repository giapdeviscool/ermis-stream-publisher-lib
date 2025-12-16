package com.margelo.nitro.ermisstreampublisherlib
  
import com.facebook.proguard.annotations.DoNotStrip

@DoNotStrip
class ErmisStreamPublisherLib : HybridErmisStreamPublisherLibSpec() {
  override fun multiply(a: Double, b: Double): Double {
    return a * b
  }
}
