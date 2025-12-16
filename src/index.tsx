import { NitroModules } from 'react-native-nitro-modules';
import type { ErmisStreamPublisherLib } from './ErmisStreamPublisherLib.nitro';

const ErmisStreamPublisherLibHybridObject =
  NitroModules.createHybridObject<ErmisStreamPublisherLib>('ErmisStreamPublisherLib');

export function multiply(a: number, b: number): number {
  return ErmisStreamPublisherLibHybridObject.multiply(a, b);
}
