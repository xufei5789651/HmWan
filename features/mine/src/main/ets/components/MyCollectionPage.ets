import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { GridManager, NodeItem, RecyclerView } from '@hadss/scroll_components';
import { PullToRefresh } from '@ohos/pulltorefresh';
import { NetError } from 'network';
import {
  BreakpointType,
  HmRouterPathConstants,
  PreferenceManager,
  showToast,
  TitleComponent,
  UtilConstants
} from 'utils';
import { ArticleInfo, CollectArticleResponse } from '../model/CollectArticleResponse';
import { MineNetFunc } from '../net/MineNetFunc';
import { MineArticleItem } from './MineArticleItem';

const TAG: string = 'MyCollectionPage';

@HMRouter({ pageUrl: HmRouterPathConstants.PAGE_MINE_COLLECTION_NAV, interceptors: ['LoginCheckInterceptor'] })
@Component
export struct MyCollectionPage {
  @StorageProp('currentWidthBreakpoint') @Watch('changeBreakpoint') currentWidthBreakpoint: string =
    UtilConstants.CONST_BREAKPOINT_MD;
  gridViewManager: GridViewManager =
    new GridViewManager({ defaultNodeItem: 'CollectGridView', context: this.getUIContext() });
  manager: PreferenceManager = PreferenceManager.getInstance();
  pageNum: number = 0;
  scroller: Scroller = new Scroller();
  @State dataList: ArticleInfo[] = [];
  @State isRefresh: boolean = true;
  @State isMore: boolean = false;

  changeBreakpoint() {
    console.log(TAG, 'changeBreakpoint currentWidthBreakpoint: ' + this.currentWidthBreakpoint);

    this.gridViewManager.setViewStyle()
      .columnsTemplate(new BreakpointType('repeat(auto-stretch, 160)', 'repeat(auto-stretch, 160)',
        'repeat(auto-stretch, 160)').getValue(this.currentWidthBreakpoint));
  }

  aboutToAppear(): void {
    console.log(TAG, 'aboutToAppear currentWidthBreakpoint: ' + this.currentWidthBreakpoint);

    this.gridViewManager.registerNodeItem('CollectGridView', wrapBuilder(CollectGridView));

    this.gridViewManager.setViewStyle()
      .width(UtilConstants.CONST_UI_PER_95)
      .margin({ top: UtilConstants.CONST_UI_SIZE_5 })
      .columnsTemplate(new BreakpointType('repeat(auto-stretch, 160)', 'repeat(auto-stretch, 160)',
        'repeat(auto-stretch, 160)').getValue(this.currentWidthBreakpoint))
      .alignItems(GridItemAlignment.STRETCH)
      .columnsGap(5)
      .rowsGap(5);

    this.getCollectList(this.pageNum);
  }

  async getCollectList(pageNum: number) {
    let cookie = await this.manager.getValue('cookie') as string;
    MineNetFunc.getCollectList(cookie, pageNum).then((response: CollectArticleResponse) => {
      if (response.errorCode === 0) {
        let list = response.data.datas;

        if (this.isRefresh) {
          this.gridViewManager.nodeAdapter.deleteData(0, this.dataList.length);
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

        this.gridViewManager.nodeAdapter.pushData(list);
      } else {
        showToast('getCollectList errorCode:' + response.errorCode);
      }
    }).catch((err: NetError) => {
      console.error(TAG, 'getCollectList error code:' + err.code + '，message:' + err.message);
    });
  }

  @Builder
  gridView() {
    RecyclerView({ viewManager: this.gridViewManager })
  }

  build() {
    Column() {
      TitleComponent({
        title: $r('app.string.my_collect'), onBackClick: () => {
          HMRouterMgr.pop()
        }
      }).backgroundColor(UtilConstants.CONST_UI_COLOR_white)

      PullToRefresh({
        data: $dataList,
        scroller: this.scroller,
        customList: () => {
          this.gridView();
        },
        onRefresh: () => {
          return new Promise((resolve, reject) => {
            resolve(UtilConstants.CONST_PULL_HINT);
            this.pageNum = 0;
            this.isRefresh = true;
            this.getCollectList(this.pageNum);
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
            this.getCollectList(this.pageNum);
          })
        }
      })
    }
    .width(UtilConstants.CONST_UI_PER_100)
    .backgroundColor(UtilConstants.CONST_UI_COLOR_f6f7f6)
  }
}

@Builder
function CollectGridView(data: ArticleInfo) {
  MineArticleItem({ info: data });
}

class GridViewManager extends GridManager {
  onWillCreateItem(index: number, data: ArticleInfo): NodeItem<ArticleInfo> | null {
    let node: NodeItem<ArticleInfo> | null = this.dequeueReusableNodeByType('CollectGridView');
    node.setData(data);
    return node;
  }
}