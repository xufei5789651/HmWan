import { UtilConstants } from "../common/UtilConstants";


@Builder
export function LoadingMore() {
  Row() {
    LoadingProgress()
      .color(UtilConstants.CONST_UI_COLOR_99000000)
      .size({ width: UtilConstants.CONST_UI_SIZE_24, height: UtilConstants.CONST_UI_SIZE_24 })

    Text(UtilConstants.CONST_LOAD_HINT)
      .fontColor(UtilConstants.CONST_UI_COLOR_99000000)
      .fontSize(UtilConstants.CONST_UI_FONT_SIZE_14)
      .margin({ left: UtilConstants.CONST_UI_SIZE_8 })
  }
  .width(UtilConstants.CONST_UI_PER_100)
  .height(UtilConstants.CONST_UI_SIZE_80)
  .justifyContent(FlexAlign.Center)
  .margin({ bottom: UtilConstants.CONST_UI_SIZE_13 })
}

@Builder
export function NoMore() {
  Row() {
    Divider()
      .color(UtilConstants.CONST_UI_COLOR_0D000000)
      .height(1)
      .layoutWeight(1)
    Text(UtilConstants.CONST_LOAD_END_HINT)
      .fontColor(UtilConstants.CONST_UI_COLOR_66000000)
      .fontSize(UtilConstants.CONST_UI_FONT_SIZE_10)
      .margin(UtilConstants.CONST_UI_SIZE_13)

    Divider()
      .color(UtilConstants.CONST_UI_COLOR_0D000000)
      .height(1)
      .layoutWeight(1)
  }
  .width(UtilConstants.CONST_UI_PER_100)
  .alignItems(VerticalAlign.Center)
  .margin({ bottom: UtilConstants.CONST_UI_SIZE_10 })
}