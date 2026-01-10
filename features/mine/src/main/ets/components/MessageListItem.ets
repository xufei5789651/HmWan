import { UtilConstants } from "utils";
import { MessageInfo } from "../model/UserMessageResponse";

@ComponentV2
export struct MessageListItem {
  @Param @Require message: MessageInfo;

  build() {
    RelativeContainer() {
      Text(this.message.tag)
        .fontColor(UtilConstants.CONST_UI_COLOR_white)
        .fontSize(UtilConstants.CONST_UI_FONT_SIZE_13)
        .margin({ top: UtilConstants.CONST_UI_SIZE_3 })
        .padding({ left: UtilConstants.CONST_UI_SIZE_5, right: UtilConstants.CONST_UI_SIZE_5 })
        .borderRadius({ topLeft: UtilConstants.CONST_UI_SIZE_15, bottomRight: UtilConstants.CONST_UI_SIZE_15 })
        .backgroundColor(this.message.tag === '系统消息' ? Color.Red : UtilConstants.CONST_UI_COLOR_24246c)
        .alignRules({
          top: { anchor: "__container__", align: VerticalAlign.Top },
          start: { anchor: "__container__", align: HorizontalAlign.Start }
        })
        .id('tag')

      Text(this.message.fromUser)
        .fontColor(UtilConstants.CONST_UI_COLOR_999999)
        .fontSize(UtilConstants.CONST_UI_FONT_SIZE_13)
        .margin({ left: UtilConstants.CONST_UI_SIZE_6, top: UtilConstants.CONST_UI_SIZE_3 })
        .alignRules({
          top: { anchor: "__container__", align: VerticalAlign.Top },
          start: { anchor: "tag", align: HorizontalAlign.End }
        })
        .id('fromUser')

      Text(this.message.niceDate)
        .fontColor(UtilConstants.CONST_UI_COLOR_999999)
        .margin({ top: UtilConstants.CONST_UI_SIZE_3, right: UtilConstants.CONST_UI_SIZE_8 })
        .fontSize(UtilConstants.CONST_UI_FONT_SIZE_13)
        .alignRules({
          top: { anchor: "__container__", align: VerticalAlign.Top },
          end: { anchor: "__container__", align: HorizontalAlign.End }
        })
        .id('niceDate')

      Text(this.message.title)
        .fontColor(UtilConstants.CONST_UI_COLOR_black)
        .fontSize(UtilConstants.CONST_UI_FONT_SIZE_16)
        .margin({ left: UtilConstants.CONST_UI_SIZE_8, top: UtilConstants.CONST_UI_SIZE_10 })
        .fontWeight(FontWeight.Bold)
        .alignRules({
          top: { anchor: "tag", align: VerticalAlign.Bottom },
          end: { anchor: "__container__", align: HorizontalAlign.End },
          start: { anchor: "__container__", align: HorizontalAlign.Start }
        })
        .id('title')

      Text(this.message.message)
        .fontColor(UtilConstants.CONST_UI_COLOR_999999)
        .fontSize(UtilConstants.CONST_UI_FONT_SIZE_14)
        .maxLines(3)
        .padding({ left: UtilConstants.CONST_UI_SIZE_5, right: UtilConstants.CONST_UI_SIZE_5 })
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .ellipsisMode(EllipsisMode.END)
        .margin({
          left: UtilConstants.CONST_UI_SIZE_8,
          top: UtilConstants.CONST_UI_SIZE_10,
          bottom: UtilConstants.CONST_UI_SIZE_10,
          right: UtilConstants.CONST_UI_SIZE_8
        })
        .backgroundColor(UtilConstants.CONST_UI_COLOR_f6f7f6)
        .borderRadius(UtilConstants.CONST_UI_SIZE_5)
        .alignRules({
          top: { anchor: "title", align: VerticalAlign.Bottom },
          end: { anchor: "__container__", align: HorizontalAlign.End },
          start: { anchor: "__container__", align: HorizontalAlign.Start }
        })
        .id('message')
    }
    .backgroundColor(UtilConstants.CONST_UI_COLOR_white)
    .borderRadius(UtilConstants.CONST_UI_SIZE_15)
    .constraintSize({ minHeight: UtilConstants.CONST_UI_SIZE_35, maxHeight: UtilConstants.CONST_UI_SIZE_150 })
    .width(UtilConstants.CONST_UI_PER_100)
  }
}