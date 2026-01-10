import { HMInterceptor, HMInterceptorAction, HMInterceptorInfo, HMRouterMgr, IHMInterceptor } from "@hadss/hmrouter";
import { LoginStatus } from "../model/LoginStatus";
import { PersistenceV2 } from "@kit.ArkUI";
import { showToast } from "../utils/Utils";
import { HmRouterPathConstants } from "../common/HmRouterPathConstants";

@HMInterceptor({ interceptorName: 'LoginCheckInterceptor' })
export class LoginCheckInterceptor implements IHMInterceptor {
  loginStatus: LoginStatus = PersistenceV2.connect(LoginStatus, 'loginStatus', () => new LoginStatus())!;

  handle(info: HMInterceptorInfo): HMInterceptorAction {
    if (this.loginStatus.isLogin) {
      return HMInterceptorAction.DO_NEXT;
    } else {
      showToast('请先登录');
      HMRouterMgr.push({ pageUrl: HmRouterPathConstants.PAGE_LOGIN_NAV, skipAllInterceptor: true })
      return HMInterceptorAction.DO_REJECT;
    }
  }
}