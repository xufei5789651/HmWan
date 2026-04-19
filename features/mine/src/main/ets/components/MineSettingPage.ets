import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { NetError } from 'network';
import {
  ActiveCloseBuilder,
  GlobalContext,
  HmRouterPathConstants,
  LightDarkStatus,
  LoginStatus,
  PreferenceManager,
  showToast,
  UtilConstants
} from 'utils';
import { LoginOutResponse } from '../model/LogoutModel';
import { MineNetFunc } from '../net/MineNetFunc';
import { PersistenceV2 } from '@kit.ArkUI';
import { DialogAction, DialogHub } from '@hadss/dialoghub';
import { ActiveCloseParams } from 'utils/src/main/ets/dialoghub/ActiveCloseBuilder';
import { common, ConfigurationConstant } from '@kit.AbilityKit';

const TAG = 'MineSettingPage'

@HMRouter({ pageUrl: HmRouterPathConstants.PAGE_SETTING_NAV })
@ComponentV2
export struct MineSettingPage {
  globalContext:common.UIAbilityContext=GlobalContext.getInstance().getContext('mainContext')!;
  manager: PreferenceManager = PreferenceManager.getInstance();
  @Local loginStatus: LoginStatus = PersistenceV2.connect(LoginStatus, 'loginStatus', () => new LoginStatus())!;
  @Local lightDarkStatus: LightDarkStatus = PersistenceV2.globalConnect({type:LightDarkStatus,key:'lightDarkStatus',defaultCreator:()=>new LightDarkStatus()})!;
  mContext = this.getUIContext().getHostContext() as common.UIAbilityContext;

  async aboutToAppear(): Promise<void> {
    let isDark = await this.manager.getValue(this.mContext,'dark') as string;
    console.log(TAG,'aboutToAppear isDark:'+isDark);
  }

  logOut() {
    MineNetFunc.logOut().then((response: LoginOutResponse) => {
      if (response.errorCode === 0) {
        this.manager.deleteValue(this.mContext,'user')
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
          .fontColor($r('app.color.mine_project_item_font_color'))
          .fontSize(UtilConstants.CONST_UI_FONT_SIZE_16)
          .margin({ left: UtilConstants.CONST_UI_PER_35 })
      }
      .height(UtilConstants.CONST_UI_SIZE_40)
      .width(UtilConstants.CONST_UI_PER_100)
      .backgroundColor($r('app.color.mine_project_background'))

      Column() {
        Row() {
          Text($r('app.string.my_setting_dark'))
            .fontColor($r('app.color.my_setting_item_font_color'))
            .fontSize(UtilConstants.CONST_UI_FONT_SIZE_16)

          Toggle({ type: ToggleType.Switch, isOn: this.lightDarkStatus.isDark })
            .selectedColor(UtilConstants.CONST_UI_COLOR_67bc5e)
            .switchPointColor(UtilConstants.CONST_UI_COLOR_white)
            .onChange((isOn: boolean) => {
              console.info(TAG, 'Toggle isOn:' + isOn);
              if (isOn) {
                this.manager.setValue(this.globalContext,'dark','1');
                this.mContext.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_DARK)
                this.lightDarkStatus.isDark=true;
              } else {
                this.manager.setValue(this.globalContext,'dark','0');
                this.mContext.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)
                this.lightDarkStatus.isDark=false;
              }
            })
        }
        .width(UtilConstants.CONST_UI_PER_100)
        .padding({ left: UtilConstants.CONST_UI_PER_3, right: UtilConstants.CONST_UI_PER_3 })
        .margin({ top: UtilConstants.CONST_UI_SIZE_5, bottom: UtilConstants.CONST_UI_SIZE_5 })
        .justifyContent(FlexAlign.SpaceBetween)
        .height(UtilConstants.CONST_UI_SIZE_40)
        .backgroundColor($r('app.color.my_setting_item_background'))
      }
      .width(UtilConstants.CONST_UI_PER_100)
      .layoutWeight(UtilConstants.CONST_UI_SIZE_1)
      .backgroundColor($r('app.color.my_setting_background'))

      Button($r('app.string.mine_setting_logout'))
        .width(UtilConstants.CONST_UI_PER_80)
        .height(UtilConstants.CONST_UI_SIZE_40)
        .fontColor(UtilConstants.CONST_UI_COLOR_67bc5e)
        .fontSize(UtilConstants.CONST_UI_FONT_SIZE_16)
        .backgroundColor($r('app.color.button_background'))
        .visibility(this.loginStatus.isLogin ? Visibility.Visible : Visibility.None)
        .margin({ bottom: UtilConstants.CONST_UI_PER_10 })
        .alignSelf(ItemAlign.Center)
        .onClick(() => {
          this.confirmDialog()
        })
    }
    .width(UtilConstants.CONST_UI_PER_100)
    .height(UtilConstants.CONST_UI_PER_100)
    .backgroundColor($r('app.color.my_setting_background'))
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
        backgroundColor: $r('app.color.mine_project_background'),
      })
      .build();

    loginOutDialog.show();
  }
}