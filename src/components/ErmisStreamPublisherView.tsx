import { getHostComponent } from 'react-native-nitro-modules';
import type {
  ErmisStreamPublisherViewMethods,
  ErmisStreamPublisherViewProps,
} from '../ErmisStreamPublisherView.nitro';

const ErmisStreamPublisherViewConfig = require('@generated/shared/json/ErmisStreamPublisherViewConfig.json');

const ErmisStreamPublisherView = getHostComponent<
  ErmisStreamPublisherViewProps,
  ErmisStreamPublisherViewMethods
>('ErmisStreamPublisherView', () => ErmisStreamPublisherViewConfig);

export default ErmisStreamPublisherView;
