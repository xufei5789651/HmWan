import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { NodeItem, RecyclerView, WaterFlowManager } from '@hadss/scroll_components';
import { PullToRefresh, PullToRefreshType } from '@ohos/pulltorefresh';
import { NetError } from 'network';
import { HmRouterPathConstants, PreferenceManager, showToast, TitleComponent, UtilConstants } from 'utils';
import { ArticleInfo, ShareArticleResponse } from '../model/ShareArticleResponse';
import { MineNetFunc } from '../net/MineNetFunc';
import { ShareArticleItem } from './ShareArticleItem';

const TAG: string = 'MySharePage';

@HMRouter({ pageUrl: HmRouterPathConstants.PAGE_MINE_SHARE_NAV, interceptors: [UtilConstants.HMROUTER_INTERCEPTOR] })
@Component
export struct MySharePage {
  waterViewManager: WaterViewManager =
    new WaterViewManager({ defaultNodeItem: 'ShareWaterView', context: this.getUIContext() });
  manager: PreferenceManager = PreferenceManager.getInstance();
  pageNum: number = 1;
  scroller: Scroller = new Scroller();
  @State dataList: ArticleInfo[] = [];
  @State isRefresh: boolean = false;
  @State isMore: boolean = false;

  aboutToAppear(): void {
    this.waterViewManager.registerNodeItem('ShareWaterView', wrapBuilder(ShareWaterView));

    this.waterViewManager.setViewStyle({ scroller: this.scroller })
      .width(UtilConstants.CONST_UI_PER_100)
      .height(UtilConstants.CONST_UI_PER_100)
      .columnsTemplate('1fr 1fr')
      .columnsGap(10)
      .rowsGap(12)
      .padding({
        top:10,
        left: 10,
        right: 10
      })

    this.waterViewManager.setItemViewStyle((item: FlowItemInterface, index: number, data: ESObject)=>{
      item().width(UtilConstants.CONST_UI_PER_100)
    })

    this.getShareList(this.pageNum);
  }

  async getShareList(pageNum: number) {
    let cookie = await this.manager.getValue('cookie') as string;
    MineNetFunc.getShareList(cookie, pageNum).then((response: ShareArticleResponse) => {
      console.log(TAG, 'getShareList length:' + response.data.shareArticles.datas.length);
      if (response.errorCode === 0) {
        let list = response.data.shareArticles.datas;

        if (this.isRefresh) {
          this.waterViewManager.nodeAdapter.deleteData(0, this.dataList.length);
          this.dataList.length = 0;
          this.isRefresh = false;
        }
        if (list.length === 0 && this.pageNum !== 0) {
          this.isMore = false;
        } else {
          this.isMore = true;
        }

        list.forEach((item) => {
          this.dataList.push(item);
        })

        this.waterViewManager.nodeAdapter.pushData(list);
      } else {
        showToast('getCollectList errorCode:' + response.errorCode);
      }
    }).catch((err: NetError) => {
      console.error(TAG, 'getShareList error code:' + err.code + '，message:' + err.message);
    });
  }
  @Builder
  getWaterFlow() {
    RecyclerView({
      viewManager: this.waterViewManager
    })
  }

  build() {
    Column() {
      TitleComponent({
        title: $r('app.string.my_share'), onBackClick: () => {
          HMRouterMgr.pop()
        }
      }).backgroundColor(UtilConstants.CONST_UI_COLOR_white)

      PullToRefresh({
        pullToRefreshType: PullToRefreshType.WATERFLOW,
        refreshing: $isRefresh,
        customList: () => {
          this.getWaterFlow();
        },
        onRefresh: () => {
          return new Promise((resolve, reject) => {
            resolve(UtilConstants.CONST_PULL_HINT);
            this.pageNum = 0;
            this.isRefresh = true;
            this.getShareList(this.pageNum);
          })
        },
        onLoadMore: () => {
          return new Promise((resolve, reject) => {
            if (this.isMore) {
              resolve(UtilConstants.CONST_LOAD_HINT);
            } else {
              resolve(UtilConstants.CONST_LOAD_END_HINT);
            }
            this.pageNum = this.pageNum + 1;
            this.getShareList(this.pageNum);
          })
        }
      })
    }
    .width(UtilConstants.CONST_UI_PER_100)
    .backgroundColor(UtilConstants.CONST_UI_COLOR_f6f7f6)
  }
}

@Builder
function ShareWaterView(data: ArticleInfo) {
  ShareArticleItem({ info: data });
}

class WaterViewManager extends WaterFlowManager {
  onWillCreateItem(index: number, data: ArticleInfo): NodeItem<ArticleInfo> | null {
    let node: NodeItem<ArticleInfo> | null = this.dequeueReusableNodeByType('ShareWaterView');
    node.setData(data);
    return node;
  }
}