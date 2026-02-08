import { UtilConstants } from "utils";
import { Article } from "utils/src/main/ets/model/HomeArticleModel"

@Preview
@Component
export struct ItemArticle {
  @Prop item: Article;

  build() {
    Stack() {
      Column() {
        Text(this.item.title)
          .fontColor($r('app.color.color_black'))
          .fontWeight(FontWeight.Bold)
          .fontSize(16)
          .margin({ left: UtilConstants.CONST_UI_SIZE_10, top: UtilConstants.CONST_UI_SIZE_10 })
          .width(UtilConstants.CONST_WIDTH_UI)

        Row() {
          Text(this.item.author === '' ? this.item.shareUser : this.item.author)
            .fontColor($r('app.color.color_999999'))
            .fontWeight(FontWeight.Bold)
            .fontSize(14)

          Text() {
            Span(this.item.superChapterName)
            Span(" / ")
            Span(this.item.chapterName)
          }
          .fontColor($r('app.color.color_999999'))
          .fontSize(14)
          .margin({ left: 10 })

          Blank()

          Image($r('app.media.share'))
            .objectFit(ImageFit.Contain)
            .width(16)
            .margin({ right: 15 })
            .aspectRatio(1)
        }
        .alignItems(VerticalAlign.Center)
        .margin({
          left: UtilConstants.CONST_UI_SIZE_10,
          top: UtilConstants.CONST_UI_SIZE_25,
          bottom: UtilConstants.CONST_UI_SIZE_10
        })
        .width(UtilConstants.CONST_WIDTH_UI)
      }
      .width(UtilConstants.CONST_WIDTH_UI)
      .borderRadius(UtilConstants.CONST_UI_SIZE_15)
      .backgroundColor(UtilConstants.CONST_UI_COLOR_white)
    }
    .padding({
      top: UtilConstants.CONST_UI_SIZE_5,
      left: UtilConstants.CONST_UI_SIZE_10,
      bottom: UtilConstants.CONST_UI_SIZE_5,
      right: UtilConstants.CONST_UI_SIZE_10
    })
  }
}