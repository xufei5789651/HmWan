import { AttributeUpdater, window } from '@kit.ArkUI';
import { HMDefaultGlobalAnimator, HMNavigation } from '@hadss/hmrouter';
import { HmRouterPathConstants, PreferenceManager } from 'utils';
import { common, ConfigurationConstant } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG:string='MainPage';

@Entry
@Component
export struct MainPage {
  modifier: PageNavModifier = new PageNavModifier();
  @StorageProp('currentColorMode') @Watch('onCurrentColorModeChange') currentColorMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;
  windowObj?: window.Window= undefined;
  mContext = this.getUIContext().getHostContext() as common.UIAbilityContext;

  async aboutToAppear() {
    this.windowObj = await window.getLastWindow(this.mContext)!;
  }

  onCurrentColorModeChange(){
    if (!this.windowObj) {
      return;
    }
    try {
      if (this.currentColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
        this.windowObj?.setWindowSystemBarProperties({
          statusBarContentColor: '#000000'
        })
      } else if (this.currentColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
        this.windowObj?.setWindowSystemBarProperties({
          statusBarContentColor: '#FFFFFF'
        })
      }
    } catch (error) {
      let err = error as BusinessError;
      console.error(TAG, `setWindowSystemBarProperties failed, error code=${err.code}, message=${err.message}`);
    }
  }

  build() {
    Column() {
      HMNavigation({
        navigationId: 'mainNavigation', homePageUrl: HmRouterPathConstants.PAGE_URL_NAV, options: { standardAnimator: HMDefaultGlobalAnimator.STANDARD_ANIMATOR,
          dialogAnimator: HMDefaultGlobalAnimator.DIALOG_ANIMATOR, modifier: this.modifier }
      })
    }
    .width('100%')
    .height('100%')
  }
}

class PageNavModifier extends AttributeUpdater<NavigationAttribute> {
  initializeModifier(instance: NavigationAttribute) {
    instance.hideNavBar(true).hideBackButton(true);
  }
}