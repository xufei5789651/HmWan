import { AttributeUpdater } from '@kit.ArkUI';
import { HMDefaultGlobalAnimator, HMNavigation, HMRouter } from '@hadss/hmrouter';
import { HmRouterPathConstants } from 'utils';

@Entry
@Component
export struct MainPage {
  modifier: PageNavModifier = new PageNavModifier();

  build() {
    Column() {
      HMNavigation({
        navigationId: 'mainNavigation', homePageUrl: HmRouterPathConstants.PAGE_URL_NAV, options: {
          standardAnimator: HMDefaultGlobalAnimator.STANDARD_ANIMATOR,
          dialogAnimator: HMDefaultGlobalAnimator.DIALOG_ANIMATOR,
          modifier: this.modifier
        }
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