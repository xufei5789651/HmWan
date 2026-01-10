import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { HmRouterPathConstants, UtilConstants } from 'utils';
import { MessageComponents } from './MessageComponents';

const TAG: string = 'MyMessagePage';

/**
 * 我的消息
 */
@HMRouter({ pageUrl: HmRouterPathConstants.PAGE_MINE_MESSAGE_NAV, interceptors: [UtilConstants.HMROUTER_INTERCEPTOR] })
@ComponentV2
export struct MyMessagePage {
  @Local messageType: string = 'unread';
  unreadMessage: string = '已读消息';
  readMessage: string = '未读消息';
  @Local currentIndex: number = 0;

  @Builder
  tabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontColor(this.currentIndex === index ? UtilConstants.CONST_UI_COLOR_black :
        UtilConstants.CONST_UI_COLOR_999999)
        .fontSize(16)
        .fontWeight(this.currentIndex === index ? UtilConstants.CONST_UI_FONT_WEIGHT_700 :
        UtilConstants.CONST_UI_FONT_WEIGHT_400)
        .lineHeight(UtilConstants.CONST_UI_SIZE_22)
        .margin({ bottom: UtilConstants.CONST_UI_SIZE_8 })

      Divider()
        .strokeWidth(2)
        .color(UtilConstants.CONST_UI_COLOR_67bc5e)
        .opacity(this.currentIndex === index ? 1 : 0)

    }.width(UtilConstants.CONST_UI_PER_100)
  }

  build() {
    Stack({alignContent:Alignment.TopStart}) {
      Tabs({ barPosition: BarPosition.Start, index: this.currentIndex }) {
        TabContent() {
          MessageComponents({ msgType: 'unread' })
        }.tabBar(this.tabBuilder(0, this.unreadMessage))

        TabContent() {
          MessageComponents({ msgType: 'read' })
        }.tabBar(this.tabBuilder(1, this.readMessage))
      }
      .vertical(false)
      .barMode(BarMode.Fixed)
      .barWidth(UtilConstants.CONST_UI_SIZE_150)
      .barHeight(UtilConstants.CONST_UI_SIZE_56)
      .margin({ top: UtilConstants.CONST_UI_SIZE_5 })
      .divider({ strokeWidth: 0.5, color: UtilConstants.CONST_UI_COLOR_999999 })
      .onChange((index: number) => {
        this.currentIndex = index
      })

      Row() {
        Image($r('app.media.chevron_left'))
          .width(UtilConstants.CONST_UI_SIZE_20)
          .height(UtilConstants.CONST_UI_SIZE_20)
          .onClick(() => {
            console.log(TAG, 'back')
            HMRouterMgr.pop()
          })
      }
      .alignItems(VerticalAlign.Center)
      .width(UtilConstants.CONST_UI_SIZE_56)
      .height(UtilConstants.CONST_UI_SIZE_56)
      .padding({ left: UtilConstants.CONST_UI_SIZE_15, right: UtilConstants.CONST_UI_SIZE_15 })
    }
    .width(UtilConstants.CONST_WIDTH_UI)
    .height(UtilConstants.CONST_HEIGHT_UI)
  }
}