import { HMRouter, HMRouterMgr } from "@hadss/hmrouter"
import { NetError } from "network";
import { HmRouterPathConstants, LoadingMore,
  LoadingStatus,
  LoadingView,NoMore,PreferenceManager, showToast, TitleComponent, UtilConstants } from "utils"
import { UserIntegralListDataSource } from "../model/UserIntegralListDataSource";
import { IntegralInfo, UserIntegralResponse } from "../model/UserIntegralResponse";
import { MineNetFunc } from "../net/MineNetFunc";
import { IntegralListItem } from "./IntegralListItem";

const TAG: string = 'MyIntegralPage';

/**
 * 我的积分
 */
@HMRouter({ pageUrl: HmRouterPathConstants.PAGE_MINE_INTEGRAL_NAV, interceptors: [UtilConstants.HMROUTER_INTERCEPTOR] })
@ComponentV2
export struct MyIntegralPage {
  manager: PreferenceManager = PreferenceManager.getInstance();
  param: ESObject | null = null;
  @Local integral: number = 0;
  @Local lazyIntegralList: UserIntegralListDataSource = new UserIntegralListDataSource();
  pageNum: number = 1;
  cacheCount: number = 3;
  @Local isMore: boolean = true;
  @Local isRefresh:boolean =true;
  @Local loadingStatus:LoadingStatus=LoadingStatus.LOADINGSTART;

  aboutToAppear(): void {
    this.param = HMRouterMgr.getCurrentParam() as ESObject;
    this.integral = this.param.coinCount;
    this.getUserIntegralList(this.pageNum);
  }

  async getUserIntegralList(pageNum: number) {
    if (pageNum == 1) {
      this.loadingStatus=LoadingStatus.LOADINGSTART;
    }

    let cookie = await this.manager.getValue('cookie') as string;
    MineNetFunc.getUserIntegral(cookie, pageNum).then((response: UserIntegralResponse) => {
      
      if (response.errorCode === 0) {
        let dataList = response.data.datas;

        if (dataList.length === 0) {
          this.isMore = false;
        } else {
          this.isMore = true;
        }

        if (pageNum === 1 && dataList.length > 0) {
          this.lazyIntegralList.clear();
          this.isRefresh = true;
          this.loadingStatus=LoadingStatus.LOADINGEND;
        } else {
          this.isRefresh = false;
        }

        dataList.forEach((item) => {
          this.lazyIntegralList.pushData(item);
        })
        console.log(TAG, `data length:${dataList.length}`);
      } else {
        showToast('getUserIntegralList errorCode:' + response.errorCode);
      }
    }).catch((err: NetError) => {
      console.error(TAG, 'getUserIntegral error code:' + err.code + '，message:' + err.message);
    });
  }

  build() {
    Column() {
      TitleComponent({
        title: $r('app.string.mine_name_integral'), onBackClick: () => {
          HMRouterMgr.pop()
        }
      })

      Stack(){
        List() {
          ListItem() {
            Column() {
              Text(`${this.integral}`)
                .fontColor(UtilConstants.CONST_UI_COLOR_white)
                .fontSize(UtilConstants.CONST_UI_FONT_SIZE_30)
                .fontWeight(UtilConstants.CONST_UI_FONT_WEIGHT_700)
            }
            .justifyContent(FlexAlign.Center)
            .backgroundColor(UtilConstants.CONST_UI_COLOR_67bc5e)
            .width(UtilConstants.CONST_UI_PER_100)
            .height(UtilConstants.CONST_UI_PER_30)
          }


          LazyForEach(this.lazyIntegralList, (integral: IntegralInfo, index: number) => {
            ListItem() {
              IntegralListItem({ item: integral })
            }
            .onAppear(() => {
              if (index + this.cacheCount === this.lazyIntegralList.totalCount() && this.isMore) {
                this.pageNum++;
                this.getUserIntegralList(this.pageNum);
              }
            })
          }, (item: IntegralInfo, index: number) => JSON.stringify(item.id) + '_' + index)

          if (this.isMore&&!this.isRefresh){
            ListItemGroup({footer:LoadingMore()})
          }

          if (!this.isMore){
            ListItemGroup({footer:NoMore()})
          }
        }
        .scrollBar(BarState.Off)
        .cachedCount(this.cacheCount)
        .width(UtilConstants.CONST_UI_PER_100)
        .height(UtilConstants.CONST_UI_PER_100)
        .layoutWeight(1)

        LoadingView()
          .visibility(this.loadingStatus === LoadingStatus.LOADINGSTART ? Visibility.Visible : Visibility.None)
      }
    }
    .width(UtilConstants.CONST_UI_PER_100)
    .height(UtilConstants.CONST_UI_PER_100)
  }
}
