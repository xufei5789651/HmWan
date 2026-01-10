import { HMRouter } from '@hadss/hmrouter';
import { Constants } from '../common/Constants';
import { ArticleMainPage } from 'article';
import { MineMainPage } from 'mine';
import { HomeMainPage } from 'home';
import { HmRouterPathConstants, UtilConstants } from 'utils';

@HMRouter({ pageUrl: HmRouterPathConstants.PAGE_URL_NAV ,singleton:true, lifecycle: UtilConstants.LIFECYCLE_EXIT_APP})
@Component
export struct NavPage {
  @State message: string = 'Hello World';
  @State currentIndex: number = 0;
  tabsController: TabsController = new TabsController();


  @Builder
  tabBuilder(title: ResourceStr, index: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === index ? selectedImg : normalImg)
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)

      Text(title)
        .margin({ top: 4 })
        .fontSize(10)
        .fontColor(this.currentIndex === index ? $r('app.color.color_67bc5e') : $r('app.color.color_24246c'))
    }
    .width('100%')
    .height(52)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = index;
      this.tabsController.changeIndex(this.currentIndex);
    })
  }

  build() {
    RelativeContainer() {
      Tabs({
        barPosition: BarPosition.End,
        controller: this.tabsController
      }) {
        // 首页
        TabContent() {
          HomeMainPage()
        }
        .backgroundColor($r('app.color.start_window_background'))
        .tabBar(this.tabBuilder($r('app.string.tab_home'),
          Constants.TAB_INDEX_ZERO, $r('app.media.house_fill_1'), $r('app.media.house_fill_0')))

        // 文章
        TabContent() {
          ArticleMainPage()
        }
        .backgroundColor($r('app.color.start_window_background'))
        .tabBar(this.tabBuilder($r('app.string.tab_article'),
          Constants.TAB_INDEX_ONE, $r('app.media.list_square_bill_1'), $r('app.media.list_square_bill_0')))

        // 我的
        TabContent() {
          MineMainPage()
        }
        .backgroundColor($r('app.color.start_window_background'))
        .tabBar(this.tabBuilder($r('app.string.tab_mine'),
          Constants.TAB_INDEX_TWO, $r('app.media.person_crop_circle_fill_1'),
          $r('app.media.person_crop_circle_fill_0')))
      }
      .width('100%')
      .backgroundColor($r('app.color.color_F3F4F5'))
      .barHeight(52)
      .barMode(BarMode.Fixed)
      .onAnimationStart((index: number, targetIndex: number) => {
        this.currentIndex = targetIndex;
      })
    }
    .height('100%')
    .width('100%')
  }
}