import { HMRouter, HMRouterMgr } from "@hadss/hmrouter"
import { NetError } from "network";
import { HmRouterPathConstants, PreferenceManager, TitleComponent, UtilConstants } from "utils"
import { ShareArticleResponse } from "../model/ShareArticleResponse";
import { MineNetFunc } from "../net/MineNetFunc";

const TAG: string = 'MySharePage';

@HMRouter({ pageUrl: HmRouterPathConstants.PAGE_MINE_SHARE_NAV, interceptors: [UtilConstants.HMROUTER_INTERCEPTOR] })
@ComponentV2
export struct MySharePage {
  manager: PreferenceManager = PreferenceManager.getInstance();
  pageNum: number = 1;

  aboutToAppear(): void {
    this.getShareList(this.pageNum);
  }

  async getShareList(pageNum: number) {
    let cookie = await this.manager.getValue('cookie') as string;
    MineNetFunc.getShareList(cookie, pageNum).then((response: ShareArticleResponse) => {
      console.log(TAG, 'getShareList length:' + response.data.shareArticles.datas.length);
    }).catch((err: NetError) => {
      console.error(TAG, 'getShareList error code:' + err.code + '，message:' + err.message);
    });
  }

  build() {
    Column() {
      TitleComponent({
        title: $r('app.string.my_share'), onBackClick: () => {
          HMRouterMgr.pop()
        }
      })
        .backgroundColor(UtilConstants.CONST_UI_COLOR_white)
    }
    .width(UtilConstants.CONST_UI_PER_100)
    .backgroundColor(UtilConstants.CONST_UI_COLOR_f6f7f6)
  }
}