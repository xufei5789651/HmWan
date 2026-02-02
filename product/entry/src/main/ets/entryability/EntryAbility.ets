import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { HMRouterMgr } from '@hadss/hmrouter';
import { HMRouterTransitions } from '@hadss/hmrouter-transitions';
import { createNWeb, WindowUtils } from 'utils';


export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    // HMRouter路由框架
    HMRouterMgr.init({ context: this.context });
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/MainPage', (err) => {
      createNWeb('https://wanandroid.com/', windowStage.getMainWindowSync().getUIContext());
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });

    windowStage.getMainWindow().then((windowObj: window.Window) => {
      WindowUtils.updateWidthBp(windowObj.getWindowProperties().windowRect.width);
      WindowUtils.updateHeightBp(windowObj.getWindowProperties().windowRect.width,
        windowObj.getWindowProperties().windowRect.height);

      windowObj.on('windowSizeChange', (windowSize) => {
        WindowUtils.updateWidthBp(windowSize.width);
        WindowUtils.updateHeightBp(windowSize.width, windowSize.height);
      })
    })

    // HMRouterTransitions 高阶转场动画库
    HMRouterTransitions.init(windowStage);
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
