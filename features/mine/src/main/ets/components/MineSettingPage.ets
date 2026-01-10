import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { NetError } from 'network';
import {
  ActiveCloseBuilder,
  HmRouterPathConstants, LoginStatus, PreferenceManager, showToast, UtilConstants } from 'utils';
import { LoginOutResponse } from '../model/LogoutModel';
import { MineNetFunc } from '../net/MineNetFunc';
import { PersistenceV2 } from '@kit.ArkUI';
import { DialogAction, DialogHub } from '@hadss/dialoghub';
import { ActiveCloseParams } from 'utils/src/main/ets/dialoghub/ActiveCloseBuilder';

const TAG = 'MineSettingPage'

@HMRouter({ pageUrl: HmRouterPathConstants.PAGE_SETTING_NAV })
@ComponentV2
export struct MineSettingPage {
  manager: PreferenceManager = PreferenceManager.getInstance();
  @Local loginStatus: LoginStatus = PersistenceV2.connect(LoginStatus, 'loginStatus', () => new LoginStatus())!;

  logOut() {
    MineNetFunc.logOut().then((response: LoginOutResponse) => {
      if (response.errorCode === 0) {
        this.manager.deleteValue('user')
        this.loginStatus.isLogin = false;
        showToast(`退出成功！`);
      } else {
        showToast(`logOut,errorCode:${response.errorCode},errorMsg${response.errorMsg}`);
      }
    }).catch((err: NetError) => {
      console.log(TAG, 'logOut error code:' + err.code + '，message:' + err.message);
    });
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.chevron_left'))
          .width(UtilConstants.CONST_UI_SIZE_20)
          .height(UtilConstants.CONST_UI_SIZE_20)
          .margin({ left: UtilConstants.CONST_UI_PER_3 })
          .onClick(() => {
            HMRouterMgr.pop({ pageUrl: HmRouterPathConstants.PAGE_SETTING_NAV })
          })

        Text($r('app.string.mine_name_setting'))
          .fontColor(UtilConstants.CONST_UI_COLOR_black)
          .fontSize(UtilConstants.CONST_UI_FONT_SIZE_16)
          .margin({ left: UtilConstants.CONST_UI_PER_35 })
      }
      .height(UtilConstants.CONST_UI_SIZE_40)
      .width(UtilConstants.CONST_UI_PER_100)
      .backgroundColor(UtilConstants.CONST_UI_COLOR_white)

      Blank()

      Button($r('app.string.mine_setting_logout'))
        .width(UtilConstants.CONST_UI_PER_80)
        .height(UtilConstants.CONST_UI_SIZE_40)
        .fontColor(UtilConstants.CONST_UI_COLOR_67bc5e)
        .fontSize(UtilConstants.CONST_UI_FONT_SIZE_16)
        .backgroundColor(UtilConstants.CONST_UI_COLOR_white)
        .visibility(this.loginStatus.isLogin ? Visibility.Visible : Visibility.None)
        .margin({ bottom: UtilConstants.CONST_UI_PER_30 })
        .alignSelf(ItemAlign.Center)
        .onClick(() => {
          this.confirmDialog()
        })
    }
    .width(UtilConstants.CONST_UI_PER_100)
    .height(UtilConstants.CONST_UI_PER_100)
    .backgroundColor(UtilConstants.CONST_UI_COLOR_F3F4F5)
  }

  confirmDialog() {
    DialogHub.init(this.getUIContext());

    let loginOutDialog = DialogHub.getCustomDialog()
      .setOperableContent(wrapBuilder(ActiveCloseBuilder), (action: DialogAction) => {
        let param = new ActiveCloseParams(UtilConstants.LOGOUT, UtilConstants.LOGOUT_TIPS,
          UtilConstants.CANCEL, UtilConstants.OUT, () => {
            action.dismiss();
          }, () => {
            this.logOut()
            action.dismiss();
          })
        return param;
      })
      .setConfig({ dialogBehavior: { isModal: true, autoDismiss: false, passThroughGesture: false } })
      .setStyle({
        radius: UtilConstants.CONST_UI_SIZE_32,
        backgroundColor: Color.White,
      })
      .build();

    loginOutDialog.show();
  }
}