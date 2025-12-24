import type {
  HybridView,
  HybridViewMethods,
  HybridViewProps,
} from 'react-native-nitro-modules';

export interface ErmisStreamPublisherViewProps extends HybridViewProps {
  rtmpUrl: string;
  streamKey: string;
  frameRate?: number;
  audioBitrate?: number;
  videoBitrate?: number;
  videoCodec?: boolean; // true is h264, false is h265
}
export interface ErmisStreamPublisherViewMethods extends HybridViewMethods {}

export type ErmisStreamPublisherView = HybridView<
  ErmisStreamPublisherViewProps,
  ErmisStreamPublisherViewMethods
>;
