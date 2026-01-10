import { HMLifecycle, HMLifecycleContext, IHMLifecycle } from "@hadss/hmrouter";
import { UtilConstants } from "../common/UtilConstants";
import { showToast } from "../utils/Utils";

@HMLifecycle({ lifecycleName: 'ExitAppLifecycle' })
export class ExitAppLifecycle implements IHMLifecycle {
  private lastTime: number = 0;

  onBackPressed(ctx: HMLifecycleContext): boolean {
    let time = new Date().getTime();
    if (time - this.lastTime > UtilConstants.EXIT_APP_DURATION) {
      this.lastTime = time;
      showToast('再次返回退出应用');
      return true;
    } else {
      return false;
    }
  }
}