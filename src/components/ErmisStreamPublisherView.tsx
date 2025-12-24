import { getHostComponent } from 'react-native-nitro-modules';
import ErmisStreamPublisherViewConfig from '../../nitrogen/generated/shared/json/ErmisStreamPublisherViewConfig.json';
import type {
  ErmisStreamPublisherViewMethods,
  ErmisStreamPublisherViewProps,
} from '../ErmisStreamPublisherView.nitro';

const ErmisStreamPublisherView = getHostComponent<
  ErmisStreamPublisherViewProps,
  ErmisStreamPublisherViewMethods
>('ErmisStreamPublisherView', () => ErmisStreamPublisherViewConfig);

export default ErmisStreamPublisherView;
