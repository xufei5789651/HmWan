import { HMRouter, HMRouterMgr } from "@hadss/hmrouter";
import { NetError } from "network";
import { HmRouterPathConstants, PreferenceManager, showToast, UtilConstants } from "utils";
import { LoginNetFunc } from "../net/LoginNetFunc";
import { LoginRegisterParam } from "../net/LoginRegisterParam";

const TAG: string = 'RegisterMainPage';

@HMRouter({ pageUrl: HmRouterPathConstants.PAGE_REGISTER_NAV })
@Component
export struct RegisterMainPage {
  manager: PreferenceManager = PreferenceManager.getInstance();
  @State userName: string = '';
  @State password: string = '';
  @State repeatPassword: string = '';

  registerForUser(){
    let registerParam: LoginRegisterParam = { username: this.userName, password: this.password ,repassword:this.repeatPassword};
    LoginNetFunc.register(registerParam).then((response) => {
      if (response.errorCode === 0) {
        this.manager.setValue('user', response.data);
        PersistentStorage.persistProp('isLogin',true);
        HMRouterMgr.replace({ navigationId: 'mainNavigation', pageUrl: HmRouterPathConstants.PAGE_URL_NAV })
      } else {
        showToast('registerForUser errorCode:' + response.errorCode + ', message:' + response.errorMsg);
      }
    }).catch((err: NetError) => {
      console.error(TAG, 'registerForUser err code:' + err.code + ', message:' + err.message);
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
          Text($r('app.string.register_name'))
            .fontSize(UtilConstants.CONST_UI_FONT_SIZE_20)
            .fontWeight(UtilConstants.CONST_UI_FONT_WEIGHT_700)
            .height(UtilConstants.CONST_UI_SIZE_28)
            .margin({ top: UtilConstants.CONST_UI_SIZE_13 })

          Text($r('app.string.register_name_label'))
            .fontSize(UtilConstants.CONST_UI_FONT_SIZE_15)
            .fontWeight(UtilConstants.CONST_UI_FONT_WEIGHT_700)
            .fontColor(UtilConstants.CONST_UI_COLOR_67bc5e)
            .height(UtilConstants.CONST_UI_SIZE_28)
            .margin({ top: UtilConstants.CONST_UI_SIZE_13 })

          TextInput({ placeholder: $r('app.string.register_user_name') })
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
              this.userName = value;
            })

          TextInput({ placeholder: $r('app.string.register_user_password') })
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

          TextInput({ placeholder: $r('app.string.register_repeat_password') })
            .type(InputType.NEW_PASSWORD)
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
              this.repeatPassword = value;
            })

          Button($r('app.string.user_register'), { stateEffect: true })
            .backgroundColor(Color.Blue)
            .fontColor(UtilConstants.CONST_UI_COLOR_white)
            .align(Alignment.Center)
            .fontWeight(UtilConstants.CONST_UI_FONT_WEIGHT_400)
            .fontSize(UtilConstants.CONST_UI_FONT_SIZE_16)
            .stateEffect(this.userName.length !== 0 && this.password.length !== 0 &&this.repeatPassword.length !== 0? true : false)
            .margin({ top: UtilConstants.CONST_UI_SIZE_56, bottom: UtilConstants.CONST_UI_SIZE_25 })
            .height(UtilConstants.CONST_UI_SIZE_40)
            .width(UtilConstants.CONST_WIDTH_UI)
            .onClick(() => {
              this.registerForUser();
            })

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