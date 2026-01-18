import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { GridManager, NodeItem, RecyclerView } from '@hadss/scroll_components';
import { NetError } from 'network';
import {
  FooterView,
  HeaderView,
  HmRouterPathConstants,
  LoadingStatus,
  NoMore,
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
  gridViewManager: GridViewManager =
    new GridViewManager({ defaultNodeItem: 'CollectGridView', context: this.getUIContext() });
  manager: PreferenceManager = PreferenceManager.getInstance();
  pageNum: number = 0;
  total: number = 0;
  @State dataList: ArticleInfo[] = [];
  @State isRefresh: boolean = false;
  @State isMore: boolean = false;
  @State isFinish: boolean = false;
  @State mOffset: number = 0;
  @State loadingStatus: LoadingStatus = LoadingStatus.LOADINGSTART;
  @State refreshStatus: RefreshStatus = RefreshStatus.Inactive;

  aboutToAppear(): void {
    this.gridViewManager.registerNodeItem('CollectGridView', wrapBuilder(CollectGridView));

    this.gridViewManager.setViewStyle()
      .width(UtilConstants.CONST_UI_PER_95)
      .margin({ top: UtilConstants.CONST_UI_SIZE_5 })
      .columnsTemplate('repeat(auto-stretch, 160)')
      .alignItems(GridItemAlignment.STRETCH)
      .columnsGap(5)
      .rowsGap(5);

    this.gridViewManager.setViewStyle()
      .onScrollIndex((first: number, last: number) => {
        console.log(TAG, 'onScrollIndex first:' + first + '  last:' + last + '  集合:' + (this.dataList.length - 1));
        if (last >= this.dataList.length - 1) {
          this.pageNum++;
          this.isRefresh = false;
          this.isMore = true;
          this.getCollectList(this.pageNum);
        }
      })

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
          this.total = response.data.size;
        }
        if (list.length === 0 && this.pageNum !== 0) {
          this.isFinish = true;
          this.isMore = false;
        } else {
          this.isFinish = false;
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

  build() {
    Column() {
      TitleComponent({
        title: $r('app.string.my_collect'), onBackClick: () => {
          HMRouterMgr.pop()
        }
      })
        .backgroundColor(UtilConstants.CONST_UI_COLOR_white)

      Refresh({ refreshing: $$this.isRefresh, builder: HeaderView(this.mOffset, this.refreshStatus, this.isRefresh) }) {
        Column() {
          RecyclerView({ viewManager: this.gridViewManager })

          Row() {
            FooterView()
          }
          .height(30)
          .visibility(this.isMore ? Visibility.Visible : Visibility.None)

          Row() {
            NoMore()
          }
          .height(30)
          .visibility(this.isFinish ? Visibility.Visible : Visibility.None)
        }
      }
      .onOffsetChange((offset: number) => {
        this.mOffset = offset;
      })
      .onStateChange((state: RefreshStatus) => {
        this.refreshStatus = state;
        console.log(TAG, 'onStateChange state:' + state);
      })
      .onRefreshing(() => {
        console.log(TAG, 'onRefreshing');
        this.isRefresh = true;
        this.pageNum = 0;
        this.getCollectList(this.pageNum);
      })
      .width(UtilConstants.CONST_UI_PER_100)
      .height(UtilConstants.CONST_UI_PER_100)
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