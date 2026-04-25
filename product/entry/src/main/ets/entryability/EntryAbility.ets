import { AbilityConstant, Configuration, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { HMRouterMgr } from '@hadss/hmrouter';
import { HMRouterTransitions } from '@hadss/hmrouter-transitions';
import { createNWeb, GlobalContext, PreferenceManager, WindowUtils } from 'utils';

const TAG: string = 'EntryAbility';

export default class EntryAbility extends UIAbility {
  manager: PreferenceManager = PreferenceManager.getInstance();

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, TAG, '%{public}s', 'Ability onCreate');
    AppStorage.setOrCreate('mContext',this.context);
    // HMRouter路由框架
    HMRouterMgr.init({ context: this.context });
  }

  onDestroy(): void {
    hilog.info(0x0000, TAG, '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, TAG, '%{public}s', 'Ability onWindowStageCreate');
    this.manager.getValue<string>(this.context, 'dark');

    windowStage.loadContent('pages/MainPage', (err) => {
      createNWeb('https://wanandroid.com/', windowStage.getMainWindowSync().getUIContext());
      if (err.code) {
        hilog.error(0x0000, TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, TAG, 'Succeeded in loading the content.');

      this.setAppDarkAndLight();
    });

    windowStage.getMainWindow().then((windowObj: window.Window) => {
      WindowUtils.updateWidthBp(windowObj.getWindowProperties().windowRect.width);
      WindowUtils.updateHeightBp(windowObj.getWindowProperties().windowRect.width,
        windowObj.getWindowProperties().windowRect.height);

      windowObj.on('windowSizeChange', (windowSize) => {
        WindowUtils.updateWidthBp(windowSize.width);
        WindowUtils.updateHeightBp(windowSize.width, windowSize.height);
      })
    });

    // HMRouterTransitions 高阶转场动画库
    HMRouterTransitions.init(windowStage);
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, TAG, '%{public}s', 'Ability onWindowStageDestroy');
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    const currentColorMode: ConfigurationConstant.ColorMode | undefined = AppStorage.get('currentColorMode');
    if (currentColorMode !== newConfig.colorMode) {
      AppStorage.setOrCreate<ConfigurationConstant.ColorMode>('currentColorMode', newConfig.colorMode);
    }
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, TAG, '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, TAG, '%{public}s', 'Ability onBackground');
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    console.log(TAG,'Ability onNewWant');
  }

  setAppDarkAndLight() {
    setTimeout(async () => {
      let isDark = await this.manager.getValue(this.context, 'dark') as string;
      console.log(TAG, 'setAppDarkAndLight isDark:' + isDark);

      if (isDark==='1') {
        this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
      } else {
        this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);
      }
      // 当前颜色模式
      AppStorage.setOrCreate<ConfigurationConstant.ColorMode>('currentColorMode',
        isDark ? ConfigurationConstant.ColorMode.COLOR_MODE_DARK :
          ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);
    },1000);
  }
}
