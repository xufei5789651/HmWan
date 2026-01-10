import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { NetError } from 'network';
import { HmRouterPathConstants, LoginStatus, PreferenceManager, showToast, User, UtilConstants } from 'utils';
import { LoginNetFunc } from '../net/LoginNetFunc';
import { LoginRegisterParam } from '../net/LoginRegisterParam';
import { PersistenceV2 } from '@kit.ArkUI';

const TAG: string = 'LoginMainPage';

@HMRouter({ pageUrl: HmRouterPathConstants.PAGE_LOGIN_NAV })
@ComponentV2
export struct LoginMainPage {
  manager: PreferenceManager = PreferenceManager.getInstance();
  @Local username: string = '';
  @Local password: string = '';
  @Local isChecked: boolean = false;
  @Local loginStatus: LoginStatus = PersistenceV2.connect(LoginStatus,'loginStatus',()=>new LoginStatus())!;

  loginForUser() {
    let loginParam: LoginRegisterParam = { username: this.username, password: this.password };
    LoginNetFunc.login(loginParam).then((response) => {
      if (response.errorCode === 0) {
        this.manager.setValue('user', response.data);
        this.loginStatus.isLogin=true;
        // this.manager.setValue('isLogin',true);
        HMRouterMgr.replace({ navigationId: 'mainNavigation',pageUrl: HmRouterPathConstants.PAGE_URL_NAV })
      } else {
        showToast('loginForUser errorCode:' + response.errorCode + ', message:' + response.errorMsg);
      }
    }).catch((err: NetError) => {
      console.error(TAG, 'loginForUser err code:' + err.code + ', message:' + err.message);
    })
  }

  build() {
    GridRow({
      columns: {
        sm: UtilConstants.COLUMN_SM,
        md: UtilConstants.COLUMN_MD,
        lg: UtilConstants.COLUMN_LG
      }
    }) {
      GridCol({
        span: {
          sm: UtilConstants.SPAN_SM,
          md: UtilConstants.SPAN_MD,
          lg: UtilConstants.SPAN_LG
        },
        offset: {
          sm: UtilConstants.OFFSET_SM,
          md: UtilConstants.OFFSET_MD,
          lg: UtilConstants.OFFSET_LG
        }
      }) {
        Column() {
          Image($r('app.media.login_harmonyos'))
            .width(UtilConstants.CONST_UI_SIZE_56)
            .height(UtilConstants.CONST_UI_SIZE_56)
            .fillColor(UtilConstants.CONST_UI_COLOR_67bc5e)
            .margin({ top: UtilConstants.CONST_UI_SIZE_76 })

          Text($r('app.string.login_name'))
            .fontSize(UtilConstants.CONST_UI_FONT_SIZE_20)
            .fontWeight(UtilConstants.CONST_UI_FONT_WEIGHT_700)
            .height(UtilConstants.CONST_UI_SIZE_28)
            .margin({ top: UtilConstants.CONST_UI_SIZE_13 })

          TextInput({ placeholder: $r('app.string.user_name') })
            .type(InputType.Normal)
            .enterKeyType(EnterKeyType.Next)
            .backgroundColor(UtilConstants.CONST_UI_COLOR_white)
            .placeholderColor(UtilConstants.CONST_UI_COLOR_999999)
            .placeholderFont({ size: UtilConstants.CONST_UI_FONT_SIZE_15 })
            .width(UtilConstants.CONST_WIDTH_UI)
            .constraintSize({ minHeight: UtilConstants.CONST_UI_SIZE_56 })
            .borderRadius(UtilConstants.CONST_UI_SIZE_35)
            .padding({ left: UtilConstants.CONST_UI_SIZE_20 })
            .margin({ top: UtilConstants.CONST_UI_SIZE_56, bottom: UtilConstants.CONST_UI_SIZE_15 })
            .onChange((value: string) => {
              this.username = value;
            })

          TextInput({ placeholder: $r('app.string.user_password') })
            .type(InputType.Password)
            .enterKeyType(EnterKeyType.Next)
            .backgroundColor(UtilConstants.CONST_UI_COLOR_white)
            .placeholderColor(UtilConstants.CONST_UI_COLOR_999999)
            .placeholderFont({ size: UtilConstants.CONST_UI_FONT_SIZE_15 })
            .width(UtilConstants.CONST_WIDTH_UI)
            .constraintSize({ minHeight: UtilConstants.CONST_UI_SIZE_56 })
            .borderRadius(UtilConstants.CONST_UI_SIZE_35)
            .padding({ left: UtilConstants.CONST_UI_SIZE_20 })
            .margin({ bottom: UtilConstants.CONST_UI_SIZE_15 })
            .onChange((value: string) => {
              this.password = value;
            })

          Button($r('app.string.user_login'), { stateEffect: true })
            .backgroundColor(Color.Blue)
            .fontColor(UtilConstants.CONST_UI_COLOR_white)
            .align(Alignment.Center)
            .fontWeight(UtilConstants.CONST_UI_FONT_WEIGHT_400)
            .fontSize(UtilConstants.CONST_UI_FONT_SIZE_16)
            .stateEffect(this.username.length !== 0 && this.password.length !== 0 ? true : false)
            .margin({ top: UtilConstants.CONST_UI_SIZE_56, bottom: UtilConstants.CONST_UI_SIZE_25 })
            .height(UtilConstants.CONST_UI_SIZE_40)
            .width(UtilConstants.CONST_WIDTH_UI)
            .onClick(() => {
              this.loginForUser();
            })

          Row() {
            Text($r('app.string.user_register'))
              .fontSize(UtilConstants.CONST_UI_FONT_SIZE_16)
              .fontColor(Color.Blue)
              .textAlign(TextAlign.Center)
              .onClick(() => {
                HMRouterMgr.push({pageUrl: HmRouterPathConstants.PAGE_REGISTER_NAV})
              })
          }
          .justifyContent(FlexAlign.Center)
          .height(UtilConstants.CONST_UI_SIZE_40)
          .width(UtilConstants.CONST_WIDTH_UI)
        }
        .width(UtilConstants.CONST_WIDTH_UI)
        .height(UtilConstants.CONST_HEIGHT_UI)
        .padding({ left: UtilConstants.CONST_UI_SIZE_25, right: UtilConstants.CONST_UI_SIZE_25 })
      }
    }
    .width(UtilConstants.CONST_WIDTH_UI)
    .height(UtilConstants.CONST_HEIGHT_UI)
    .backgroundColor(UtilConstants.CONST_UI_COLOR_F3F4F5)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
