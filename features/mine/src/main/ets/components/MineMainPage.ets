import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { HmRouterPathConstants, LoginStatus, PreferenceManager, showToast, User, UtilConstants } from 'utils';
import { PersistenceV2 } from '@kit.ArkUI';
import { MineNetFunc } from '../net/MineNetFunc';
import { CoinInfo, UserInfoResponse } from '../model/UserInfoResponse';
import { NetError } from 'network';
import { UnBadgeNumResponse } from '../model/UnBadgeNumResponse';

const TAG: string = 'MineMainPage';

/**
 * 我的
 */
@HMRouter({ pageUrl: HmRouterPathConstants.PAGE_MINE_NAV })
@Preview
@ComponentV2
export struct MineMainPage {
  manager: PreferenceManager = PreferenceManager.getInstance();
  @Local user: User | null = null;
  @Local coinInfo: CoinInfo | null = null;
  @Local loginStatus: LoginStatus = PersistenceV2.connect(LoginStatus, 'loginStatus', () => new LoginStatus())!;
  @Local badgeCount: number = 0;

  @Monitor('loginStatus.isLogin')
  updateUserInfo(monitor: IMonitor) {
    if (monitor.value()?.now) {
      this.getUpdateUserInfo();
      this.getUnBadgeNum();
    }
  }

  aboutToAppear(): void {
    this.getLocalUserInfo();
    if (this.loginStatus.isLogin) {
      this.getUpdateUserInfo();
      this.getUnBadgeNum();
    }
  }

  async getLocalUserInfo() {
    this.user = await this.manager.getValue<User>('user');
    console.log(TAG, 'isLogin:::' + this.loginStatus.isLogin);
  }

  async getUpdateUserInfo() {
    let cookie = await this.manager.getValue('cookie') as string;
    MineNetFunc.getUserInfo(cookie).then((response: UserInfoResponse) => {
      if (response.errorCode === 0) {
        this.user = response.data.userInfo;
        this.coinInfo = response.data.coinInfo;
        this.manager.setValue<User>('user', response.data.userInfo);
      } else {
        showToast(`getUpdateUserInfo,errorCode:${response.errorCode},errorMsg${response.errorMsg}`);
      }
    }).catch((err: NetError) => {
      console.log(TAG, 'getUpdateUserInfo error code:' + err.code + '，message:' + err.message);
    });
  }

  async getUnBadgeNum() {
    let cookie = await this.manager.getValue('cookie') as string;
    MineNetFunc.unBadgeNum(cookie).then((response: UnBadgeNumResponse) => {
      if (response.errorCode === 0) {
        this.badgeCount=response.data;
      } else {
        showToast(`getUnBadgeNum,errorCode:${response.errorCode},errorMsg${response.errorMsg}`);
      }
    }).catch((err: NetError) => {
      console.log(TAG, 'getUpdateUserInfo error code:' + err.code + '，message:' + err.message);
    });
  }

  build() {
    Column() {
      Column() {
        Row(){
          Badge({
            count: this.badgeCount,
            style: {},
            position: BadgePosition.RightTop,
          }) {
            Image($r('app.media.envelope'))
              .width(UtilConstants.CONST_UI_SIZE_25)
              .height(UtilConstants.CONST_UI_SIZE_25)
          }
          .margin({right:UtilConstants.CONST_UI_SIZE_10})
          .width(UtilConstants.CONST_UI_SIZE_28)
          .height(UtilConstants.CONST_UI_SIZE_28)
          .onClick(() => {
            HMRouterMgr.push({ pageUrl: HmRouterPathConstants.PAGE_MINE_MESSAGE_NAV })
          })
        }
        .justifyContent(FlexAlign.End)
        .width(UtilConstants.CONST_UI_PER_100)
        .height(UtilConstants.CONST_UI_AUTO)

        Image(this.loginStatus.isLogin ? this.user?.icon : $r('app.media.portrait'))
          .width(UtilConstants.CONST_UI_SIZE_35)
          .borderRadius(UtilConstants.CONST_UI_SIZE_35)
          .alt($r('app.media.portrait'))
          .aspectRatio(1)
          .margin({ top: UtilConstants.CONST_UI_SIZE_32 })
          .backgroundColor(UtilConstants.CONST_UI_COLOR_white)
          .onClick(() => {
            if (!this.loginStatus.isLogin) {
              HMRouterMgr.push({ pageUrl: HmRouterPathConstants.PAGE_LOGIN_NAV })
            }
          })

        Text(this.user?.nickname)
          .margin({ top: UtilConstants.CONST_UI_SIZE_15 })
          .visibility(this.loginStatus.isLogin ? Visibility.Visible : Visibility.Hidden)
          .fontColor(UtilConstants.CONST_UI_COLOR_white)
          .fontSize(UtilConstants.CONST_UI_FONT_SIZE_18)

        Text('ID:' + this.user?.id)
          .margin({ top: UtilConstants.CONST_UI_SIZE_10 })
          .visibility(this.loginStatus.isLogin ? Visibility.Visible : Visibility.Hidden)
          .fontColor(UtilConstants.CONST_UI_COLOR_white)
          .fontSize(UtilConstants.CONST_UI_FONT_SIZE_13)

        Text(`等级：${this.coinInfo?.level} 排名：${this.coinInfo?.rank}`)
          .margin({ top: UtilConstants.CONST_UI_SIZE_10, bottom: UtilConstants.CONST_UI_SIZE_15 })
          .visibility(this.loginStatus.isLogin ? Visibility.Visible : Visibility.Hidden)
          .fontColor(UtilConstants.CONST_UI_COLOR_white)
          .fontSize(UtilConstants.CONST_UI_FONT_SIZE_15)
      }
      .width(UtilConstants.CONST_WIDTH_UI)
      .height('auto')
      .linearGradient({
        direction: GradientDirection.Top,
        colors: [[UtilConstants.CONST_UI_COLOR_67bc5e, 0.0], [UtilConstants.CONST_UI_COLOR_F3F4F5, 0.8],
          [UtilConstants.CONST_UI_COLOR_white, 1.0]]
      })

      Row() {
        Row() {
          Image($r('app.media.star'))
            .width(UtilConstants.CONST_UI_SIZE_25)
            .height(UtilConstants.CONST_UI_SIZE_25)

          Text($r('app.string.mine_name_integral'))
            .commonTextStyle()
        }

        Row() {
          Text(`${this.coinInfo?.coinCount}`)
            .fontColor(UtilConstants.CONST_UI_COLOR_999999)
            .fontSize(UtilConstants.CONST_UI_FONT_SIZE_13)
            .visibility(this.loginStatus.isLogin ? Visibility.Visible : Visibility.None)

          Image($r('app.media.chevron_right'))
            .width(UtilConstants.CONST_UI_SIZE_15)
            .height(UtilConstants.CONST_UI_SIZE_15)
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .padding({ left: UtilConstants.CONST_UI_SIZE_13, right: UtilConstants.CONST_UI_SIZE_13 })
      .height(UtilConstants.CONST_UI_SIZE_45)
      .width(UtilConstants.CONST_WIDTH_UI)
      .onClick(() => {
        HMRouterMgr.push({ pageUrl: HmRouterPathConstants.PAGE_MINE_INTEGRAL_NAV ,param:{coinCount:this.coinInfo?.coinCount}})
      })

      Row() {
        Row() {
          Image($r('app.media.share'))
            .width(UtilConstants.CONST_UI_SIZE_25)
            .height(UtilConstants.CONST_UI_SIZE_25)

          Text($r('app.string.mine_name_share'))
            .commonTextStyle()
        }

        Image($r('app.media.chevron_right'))
          .width(UtilConstants.CONST_UI_SIZE_15)
          .height(UtilConstants.CONST_UI_SIZE_15)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .padding({ left: UtilConstants.CONST_UI_SIZE_13, right: UtilConstants.CONST_UI_SIZE_13 })
      .height(UtilConstants.CONST_UI_SIZE_45)
      .width(UtilConstants.CONST_WIDTH_UI)
      .onClick(() => {
        HMRouterMgr.push({ pageUrl: HmRouterPathConstants.PAGE_MINE_SHARE_NAV })
      })


      Row() {
        Row() {
          Image($r('app.media.heart'))
            .width(UtilConstants.CONST_UI_SIZE_25)
            .height(UtilConstants.CONST_UI_SIZE_25)

          Text($r('app.string.mine_name_collection'))
            .commonTextStyle()
        }

        Image($r('app.media.chevron_right'))
          .width(UtilConstants.CONST_UI_SIZE_15)
          .height(UtilConstants.CONST_UI_SIZE_15)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .padding({ left: UtilConstants.CONST_UI_SIZE_13, right: UtilConstants.CONST_UI_SIZE_13 })
      .height(UtilConstants.CONST_UI_SIZE_45)
      .width(UtilConstants.CONST_WIDTH_UI)
      .onClick(() => {
        HMRouterMgr.push({ pageUrl: HmRouterPathConstants.PAGE_MINE_COLLECTION_NAV })
      })


      Row() {
        Row() {
          Image($r('app.media.setting'))
            .width(UtilConstants.CONST_UI_SIZE_25)
            .height(UtilConstants.CONST_UI_SIZE_25)

          Text($r('app.string.mine_name_setting'))
            .commonTextStyle()
        }

        Image($r('app.media.chevron_right'))
          .width(UtilConstants.CONST_UI_SIZE_15)
          .height(UtilConstants.CONST_UI_SIZE_15)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .padding({ left: UtilConstants.CONST_UI_SIZE_13, right: UtilConstants.CONST_UI_SIZE_13 })
      .height(UtilConstants.CONST_UI_SIZE_45)
      .width(UtilConstants.CONST_WIDTH_UI)
      .onClick(() => {
        HMRouterMgr.push({ pageUrl: HmRouterPathConstants.PAGE_SETTING_NAV })
      })
    }
    .width(UtilConstants.CONST_WIDTH_UI)
    .height(UtilConstants.CONST_HEIGHT_UI)
    .backgroundColor(UtilConstants.CONST_UI_COLOR_white)
  }
}

@Extend(Text)
function commonTextStyle() {
  .fontColor(UtilConstants.CONST_UI_COLOR_black)
  .margin({ left: UtilConstants.CONST_UI_SIZE_10 })
  .fontSize(UtilConstants.CONST_UI_FONT_SIZE_16)
}