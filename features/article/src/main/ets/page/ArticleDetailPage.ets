import { HMRouter, HMRouterMgr } from "@hadss/hmrouter"
import { createNWeb, HmRouterPathConstants, TitleComponent, WebComponent } from "utils"

const TAG:string='ArticleDetailPage';

@HMRouter({ pageUrl: HmRouterPathConstants.PAGE_ARTICLE_DETAIL_NAV })
@Entry
@ComponentV2
export struct ArticleDetailPage {
  param: ESObject | null = null;
  @Local url:string='';

  aboutToAppear(): void {
    this.param = HMRouterMgr.getCurrentParam() as ESObject;
    this.url=this.param.link;
    createNWeb(this.url,this.getUIContext());
  }

  build() {
    Column() {
      TitleComponent({
        title: $r('app.string.page_article_title'), onBackClick: () => {HMRouterMgr.pop()}
      })

      WebComponent({url:this.url})
    }
    .width('100%')
  }
}
