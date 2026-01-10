import { UtilConstants } from "utils";
import { ProjectSortModel } from "../model/ProjectSortModel";
import { ArticleList } from "./ArticleList";

@Component
export struct ArticleTabBar {
  @Prop tabArray: ProjectSortModel[];
  @State currentIndex: number = 0;
  @State tabMargin: number = -500;
  @State tabGutter: number = 10;

  @Builder
  tabBuilder(index: number) {
    Column() {
      Text(this.tabArray[index].name)
        .height(UtilConstants.CONST_UI_PER_80)
        .margin({ top: UtilConstants.CONST_UI_SIZE_5, bottom: UtilConstants.CONST_UI_SIZE_5 })
        .fontSize(this.currentIndex === index ? UtilConstants.CONST_UI_FONT_SIZE_22 :
        UtilConstants.CONST_UI_FONT_SIZE_18)
        .fontWeight(this.currentIndex === index ? UtilConstants.CONST_UI_FONT_WEIGHT_700 :
        UtilConstants.CONST_UI_FONT_WEIGHT_400)

      Divider()
        .strokeWidth(UtilConstants.CONST_UI_SIZE_2)
        .color(UtilConstants.CONST_UI_COLOR_67bc5e)
        .width(UtilConstants.CONST_UI_SIZE_45)
        .lineCap(LineCapStyle.Round)
        .opacity(this.currentIndex === index ? 1 : 0)
    }
    .justifyContent(FlexAlign.Center)
    .padding({ left: UtilConstants.CONST_UI_PER_3, right: UtilConstants.CONST_UI_PER_3 })
  }

  build() {
    Tabs({ barPosition: BarPosition.Start }) {
      ForEach(this.tabArray, (item: ProjectSortModel, index: number) => {
        TabContent() {
          ArticleList({tabId:item.id})
        }.tabBar(this.tabBuilder(index))
      }, (item: ProjectSortModel) => {
        return JSON.stringify(item.id);
      })
    }
    .barMode(BarMode.Scrollable)
    .vertical(false)
    .barWidth(UtilConstants.CONST_WIDTH_UI)
    .barHeight(UtilConstants.CONST_UI_SIZE_56)
    .divider({ color: UtilConstants.CONST_UI_COLOR_f6f7f6, strokeWidth: UtilConstants.CONST_UI_SIZE_1 })
    .onChange((index: number) => {
      this.currentIndex=index;
    })
    .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
      this.currentIndex = targetIndex;
    })
  }
}