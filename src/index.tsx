import { NitroModules } from 'react-native-nitro-modules';
import type { ErmisStreamPublisherLib } from './ErmisStreamPublisherLib.nitro';

import {
  getDummyToken as getDummyTokenUtil,
  getSDKToken as getSDKTokenUtil,
} from './utils/useRequest';
import ErmisStreamPublisherViewScreen from './components/ErmisStreamPublisherView';

const ErmisStreamPublisherLibHybridObject =
  NitroModules.createHybridObject<ErmisStreamPublisherLib>(
    'ErmisStreamPublisherLib'
  );

export function startStream(): void {
  return ErmisStreamPublisherLibHybridObject.startStream();
}

export function stopStream(): void {
  return ErmisStreamPublisherLibHybridObject.stopStream();
}

export function flipCamera(position: boolean): void {
  return ErmisStreamPublisherLibHybridObject.flipCamera(position);
}

export const getDummyToken = async () => {
  const dummyToken = await getDummyTokenUtil('tuantucuc@gmail.com');
  return dummyToken.data;
};

export const getSDKToken = async (auth_token: string) => {
  const sdkToken = await getSDKTokenUtil(auth_token);
  return sdkToken.data;
};

interface ErmisStreamPublisherViewProps {
  rtmpUrl: string;
  streamKey: string;
  frameRate?: number;
  videoBitrate?: number;
  audioBitrate?: number;
  videoCodec?: boolean;
  style?: object;
}

export const ErmisStreamPublisherView = ({
  rtmpUrl,
  streamKey,
  frameRate,
  videoBitrate,
  audioBitrate,
  videoCodec,
  style,
}: ErmisStreamPublisherViewProps) => {
  return (
    <ErmisStreamPublisherViewScreen
      rtmpUrl={rtmpUrl}
      streamKey={streamKey}
      frameRate={frameRate}
      videoBitrate={videoBitrate}
      audioBitrate={audioBitrate}
      videoCodec={videoCodec}
      style={style}
    />
  );
};
