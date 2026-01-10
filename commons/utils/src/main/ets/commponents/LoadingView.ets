import { UtilConstants } from "../common/UtilConstants"

@ComponentV2
export struct LoadingView {

  build() {
    Column() {
      LoadingProgress()
        .width(UtilConstants.CONST_UI_SIZE_56)
        .height(UtilConstants.CONST_UI_SIZE_56)
        .color(UtilConstants.CONST_UI_COLOR_67bc5e)

      Text(UtilConstants.CONST_LOADING_HINT)
        .fontColor(UtilConstants.CONST_UI_COLOR_24246c)
        .fontSize(UtilConstants.CONST_UI_FONT_SIZE_15)
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor(UtilConstants.CONST_UI_COLOR_white)
    .width(UtilConstants.CONST_UI_PER_100)
    .height(UtilConstants.CONST_UI_PER_100)
  }
}