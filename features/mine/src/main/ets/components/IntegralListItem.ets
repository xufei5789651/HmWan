import { DateUtils } from "utils";
import { UtilConstants } from "utils/src/main/ets/common/UtilConstants";
import { IntegralInfo } from "../model/UserIntegralResponse";

@ComponentV2
export struct IntegralListItem {
  @Param @Require item?: IntegralInfo;

  build() {
    RelativeContainer() {
      Text(`${this.item?.reason}`)
        .font({ size: UtilConstants.CONST_UI_FONT_SIZE_18, style: FontStyle.Italic },
          { enableVariableFontWeight: true })
        .fontColor(UtilConstants.CONST_UI_COLOR_black)
        .alignRules({
          top: { anchor: "__container__", align: VerticalAlign.Top },
          start: { anchor: "__container__", align: HorizontalAlign.Start }
        })
        .id('reason')

      Text(`${DateUtils.timestampToDateTime(this.item?.date)}`)
        .font({ size: UtilConstants.CONST_UI_FONT_SIZE_13, style: FontStyle.Normal })
        .fontColor(UtilConstants.CONST_UI_COLOR_999999)
        .margin({ top: UtilConstants.CONST_UI_SIZE_15 })
        .alignRules({
          top: { anchor: "reason", align: VerticalAlign.Bottom },
          start: { anchor: "__container__", align: HorizontalAlign.Start }
        })
        .id('date')

      Text(`+ ${this.item?.coinCount}`)
        .font({ size: UtilConstants.CONST_UI_FONT_SIZE_15, style: FontStyle.Normal })
        .fontColor(UtilConstants.CONST_UI_COLOR_67bc5e)
        .alignRules({
          center: { anchor: "__container__", align: VerticalAlign.Center },
          end: { anchor: "__container__", align: HorizontalAlign.End },
        })
        .id('coinCount')

      Divider().vertical(false)
        .strokeWidth(UtilConstants.CONST_UI_SIZE_DIVIDER)
        .color(UtilConstants.CONST_UI_COLOR_black)
        .margin({ top: UtilConstants.CONST_UI_SIZE_10 })
        .alignRules({
          top: { anchor: "date", align: VerticalAlign.Bottom },
        })
    }
    .width(UtilConstants.CONST_UI_PER_100)
    .height(UtilConstants.CONST_UI_SIZE_76)
    .padding({
      top: UtilConstants.CONST_UI_SIZE_10,
      left: UtilConstants.CONST_UI_SIZE_10,
      right: UtilConstants.CONST_UI_SIZE_10
    })
    .backgroundColor(UtilConstants.CONST_UI_COLOR_white)
  }
}