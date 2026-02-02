import { HMRouter, HMRouterMgr } from "@hadss/hmrouter";
import { createNWeb, HmRouterPathConstants, shareLink, TitleComponent, UtilConstants, WebComponent } from "utils";
import { common } from "@kit.AbilityKit";

@HMRouter({ pageUrl: HmRouterPathConstants.PAGE_MINE_DETAIL_NAV })
@Entry
@ComponentV2
export struct MineDetailPage {
  param: ESObject | null = null;
  @Local url: string = '';
  @Local title: string = '';
  @Local desc: string = '';
  context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;

  aboutToAppear(): void {
    this.param = HMRouterMgr.getCurrentParam() as ESObject;
    this.url = this.param.link;
    this.title = this.param.title;
    this.desc = this.param.desc;
    createNWeb(this.url, this.getUIContext());
  }

  build() {
    Column() {
      TitleComponent({
        title: $r('app.string.page_article_title'), onBackClick: () => {
          HMRouterMgr.pop()
        }
      }){
        Image($r('app.media.title_share'))
          .width(UtilConstants.CONST_UI_SIZE_20)
          .height(UtilConstants.CONST_UI_SIZE_20)
          .onClick(() => {
            shareLink(this.context, this.title, this.url,this.desc);
          })
      }

      WebComponent({ url: this.url })
    }
    .width('100%')
  }
}
