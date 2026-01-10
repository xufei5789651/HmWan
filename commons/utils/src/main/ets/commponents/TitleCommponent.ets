import { UtilConstants } from "../common/UtilConstants";

@Builder
function DefaultBuilder() {}

@ComponentV2
export struct TitleComponent {
  @Param @Require title?: ResourceStr;
  @BuilderParam menuView?: CustomBuilder = DefaultBuilder;
  @Param @Require onBackClick?: Function;

  build() {
    Row() {
      if (this.onBackClick) {
        Image($r('app.media.chevron_left'))
          .width(UtilConstants.CONST_UI_SIZE_20)
          .height(UtilConstants.CONST_UI_SIZE_20)
          .onClick(() => this.onBackClick?.())
      }

      Text(this.title)
        .fontSize(UtilConstants.CONST_UI_FONT_SIZE_22)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .layoutWeight(1)

      Row() {
        if (this.menuView) {
          this.menuView()
        }
      }
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .width(UtilConstants.CONST_WIDTH_UI)
    .height(UtilConstants.CONST_UI_SIZE_56)
    .padding({ left: UtilConstants.CONST_UI_SIZE_15, right: UtilConstants.CONST_UI_SIZE_15 })
  }
}