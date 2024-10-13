import type { TurboModule } from 'react-native';
import { TurboModuleRegistry, NativeModules } from 'react-native';

export interface Spec extends TurboModule {
  restart(): Promise<void>;
}

const RestartEnhancedTurbo = TurboModuleRegistry.get<Spec>('RestartEnhanced');
const RestartEnhancedLegacy = NativeModules.RestartEnhanced;

const RestartEnhanced = {
  async restart() {
    if (RestartEnhancedTurbo) {
      await RestartEnhancedTurbo.restart();
    } else if (RestartEnhancedLegacy) {
      await RestartEnhancedLegacy.restart();
    } else {
      console.warn('RestartEnhanced module is not available');
    }
  },
};

export default RestartEnhanced;
