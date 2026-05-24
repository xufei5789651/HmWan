import { HMRouterMgr } from "@hadss/hmrouter";
import { NetError } from "network";
import { HmRouterPathConstants, showToast, UtilConstants } from "utils";
import { ProjectSortModel, ProjectSortResponse } from "../model/ProjectSortModel";
import { ProjectNetFunc } from "../net/ProjectNetFunc";
import { ArticleTabBar } from "./ArticleTabBar";

const TAG: string = 'ArticleMainPage';

@Component
export struct ArticleMainPage {
  @State message: string = '文章';
  @State tabArray: ProjectSortModel[] = []

  aboutToAppear(): void {
    this.getProjectSortList();
  }

  getProjectSortList() {
    ProjectNetFunc.getProjectSortList().then((response: ProjectSortResponse) => {
      if (response.errorCode === 0) {
        let tabs = response.data;
        tabs.forEach((item) => {
          this.tabArray.push(item);
        })
      } else {
        showToast('getProjectSortList errorCode:' + response.errorCode);
      }
    }).catch((err: NetError) => {
      console.error(TAG, 'getProjectSortList err code:' + err.code + ', message:' + err.message);
    })
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Flex({ direction: FlexDirection.Row }) {
        ArticleTabBar({ tabArray: this.tabArray })
      }
      .width(UtilConstants.CONST_WIDTH_UI)
      .height(UtilConstants.CONST_HEIGHT_UI)

      Image($r('app.media.search'))
        .size({ width: UtilConstants.CONST_UI_SIZE_28, height: UtilConstants.CONST_UI_SIZE_28 })
        .margin({ top: UtilConstants.CONST_UI_SIZE_13 })
        .backgroundColor($r('app.color.article_tabs_background_color'))
        .onClick(()=>{
          HMRouterMgr.push({ pageUrl: HmRouterPathConstants.PAGE_SEARCH_NAV })
        })
    }
  }
}
