import { HMRouter, HMRouterMgr } from "@hadss/hmrouter"
import {
  createNWeb,
  HmRouterPathConstants,
  LightDarkStatus,
  shareLink,
  TitleComponent,
  UtilConstants,
  WebComponent
} from "utils"
import { common } from "@kit.AbilityKit";
import { PersistenceV2 } from "@kit.ArkUI";

const TAG: string = 'ArticleDetailPage';

@HMRouter({ pageUrl: HmRouterPathConstants.PAGE_ARTICLE_DETAIL_NAV })
@Entry
@ComponentV2
export struct ArticleDetailPage {
  param: ESObject | null = null;
  @Local url: string = '';
  @Local title: string = '';
  @Local desc: string = '';
  context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  @Local lightDarkStatus: LightDarkStatus = PersistenceV2.globalConnect({
    type: LightDarkStatus,
    key: 'lightDarkStatus',
    defaultCreator: () => new LightDarkStatus()
  })!;

  aboutToAppear(): void {
    this.param = HMRouterMgr.getCurrentParam() as ESObject;
    this.url = this.param.link;
    this.title = this.param.title;
    this.desc = this.param.desc;
    createNWeb(this.url, this.getUIContext(), this.lightDarkStatus.isDark);
    console.log(TAG,'isDark:'+this.lightDarkStatus.isDark);
  }

  build() {
    Column() {
      TitleComponent({
        title: $r('app.string.page_article_title'), onBackClick: () => {
          HMRouterMgr.pop()
        }
      }) {
        Image($r('app.media.title_share'))
          .width(UtilConstants.CONST_UI_SIZE_20)
          .height(UtilConstants.CONST_UI_SIZE_20)
          .onClick(() => {
            shareLink(this.context, this.title, this.url, this.desc);
          })
      }

      WebComponent({ url: this.url })
    }
    .width('100%')
  }
}
