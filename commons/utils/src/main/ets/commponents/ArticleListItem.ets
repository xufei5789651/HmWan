import { UtilConstants } from "../common/UtilConstants"
import { Article } from "../model/HomeArticleModel";

@Reusable
@Component
export struct ArticleListItem {
  @Prop item: Article;

  aboutToReuse(params: ESObject): void {
    this.item = params.item as Article;
  }

  build() {
    Stack() {
      RelativeContainer() {
        if (this.item.envelopePic !== "") {
          Image(this.item.envelopePic)
            .id('picture')
            .objectFit(ImageFit.TOP)
            .alignRules({
              top: { anchor: "__container__", align: VerticalAlign.Top },
              right: { anchor: "__container__", align: HorizontalAlign.End }
            })
            .offset({ x: UtilConstants.CONST_UI_SIZE_NEG_10, y: UtilConstants.CONST_UI_SIZE_10 })
            .width(UtilConstants.CONST_UI_SIZE_25)
            .height(UtilConstants.CONST_UI_SIZE_35)
        }

        Text(this.item.title)
          .id('title')
          .fontColor(UtilConstants.CONST_UI_COLOR_black)
          .fontWeight(FontWeight.Bold)
          .maxLines(1)
          .textAlign(TextAlign.Start)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontSize(UtilConstants.CONST_UI_FONT_SIZE_16)
          .alignRules({
            top: { anchor: "__container__", align: VerticalAlign.Top },
            left: { anchor: "__container__", align: HorizontalAlign.Start },
          })
          .offset({ x: UtilConstants.CONST_UI_SIZE_10, y: UtilConstants.CONST_UI_SIZE_10 })
          .width(UtilConstants.CONST_UI_PER_80)

        Row() {
          Text(this.item.author === '' ? this.item.shareUser : this.item.author)
            .fontColor(UtilConstants.CONST_UI_COLOR_999999)
            .fontWeight(FontWeight.Bold)
            .fontSize(14)

          Text() {
            Span(this.item.superChapterName)
            Span(" / ")
            Span(this.item.chapterName)
          }
          .fontColor(UtilConstants.CONST_UI_COLOR_999999)
          .fontSize(14)
          .margin({ left: 10 })

          Blank()
        }
        .alignItems(VerticalAlign.Center)
        .offset({ x: UtilConstants.CONST_UI_SIZE_10, y: UtilConstants.CONST_UI_SIZE_NEG_10 })
        .alignRules({
          bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
          left: { anchor: "__container__", align: HorizontalAlign.Start },
          right: { anchor: "__container__", align: HorizontalAlign.End }
        })
        .width(UtilConstants.CONST_WIDTH_UI)
      }
      .width(UtilConstants.CONST_WIDTH_UI)
      .height(UtilConstants.CONST_UI_SIZE_80)
      .borderRadius(UtilConstants.CONST_UI_SIZE_15)
      .backgroundColor(UtilConstants.CONST_UI_COLOR_white)
    }.padding({ left: 10, right: 10 })
  }
}