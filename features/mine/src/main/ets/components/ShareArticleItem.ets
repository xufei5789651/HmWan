import { HMRouterMgr } from "@hadss/hmrouter";
import { HmRouterPathConstants, UtilConstants } from "utils";
import { ArticleInfo } from "../model/ShareArticleResponse";

@Component
export struct ShareArticleItem {
  @State @Require info: ArticleInfo;

  build() {
    Column() {
      Text(this.info.title)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .font({ size: UtilConstants.CONST_UI_FONT_SIZE_15, weight: FontWeight.Bold })
        .fontColor(UtilConstants.CONST_UI_COLOR_black)
        .margin({
          top: UtilConstants.CONST_UI_SIZE_10,
          left: UtilConstants.CONST_UI_SIZE_10,
          right: UtilConstants.CONST_UI_SIZE_10
        })

      Row() {
        Text(this.info.chapterName)
          .textAlign(TextAlign.Start)
          .fontColor(UtilConstants.CONST_UI_COLOR_999999)
          .fontSize(UtilConstants.CONST_UI_FONT_SIZE_10)
          .margin({ right: UtilConstants.CONST_UI_SIZE_10 })

        Text('赞:' + this.info.zan + ' . ' + this.info.niceDate)
          .fontColor(UtilConstants.CONST_UI_COLOR_999999)
          .textAlign(TextAlign.Start)
          .fontSize(UtilConstants.CONST_UI_FONT_SIZE_10)
      }
      .justifyContent(FlexAlign.Start)
      .margin({
        top: UtilConstants.CONST_UI_SIZE_35,
        left: UtilConstants.CONST_UI_SIZE_10,
        right: UtilConstants.CONST_UI_SIZE_10,
        bottom: UtilConstants.CONST_UI_SIZE_10
      })
    }
    .onClick(()=>{
      HMRouterMgr.push({
        pageUrl: HmRouterPathConstants.PAGE_MINE_DETAIL_NAV,
        param: { link: this.info.link }
      })
    })
    .alignItems(HorizontalAlign.Start)
    .width(UtilConstants.CONST_UI_PER_100)
    .backgroundColor(UtilConstants.CONST_UI_COLOR_white)
  }
}