import type { HybridObject } from 'react-native-nitro-modules';

export interface ErmisStreamPublisherLib
  extends HybridObject<{ ios: 'swift'; android: 'kotlin' }> {
  startStream(): void;
  stopStream(): void;
  flipCamera(position: boolean): void;
}
