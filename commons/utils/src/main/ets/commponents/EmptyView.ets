import { UtilConstants } from "../common/UtilConstants";

@Builder
export function emptyView() {
  Column() {
     Image($r('app.media.xmark_circle'))
       .width(UtilConstants.CONST_UI_SIZE_40)
       .height(UtilConstants.CONST_UI_SIZE_40)
       .fillColor(UtilConstants.CONST_UI_COLOR_999999)

    Text('暂无数据')
      .margin({top:UtilConstants.CONST_UI_SIZE_10})
      .fontColor(UtilConstants.CONST_UI_COLOR_999999)
  }
  .justifyContent(FlexAlign.Center)
  .backgroundColor(UtilConstants.CONST_UI_COLOR_F3F4F5)
  .width(UtilConstants.CONST_UI_PER_100)
  .height(UtilConstants.CONST_UI_PER_100)
}