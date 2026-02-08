import { NetError } from "network";
import {
  Article,
  ArticleListItem,
  BreakpointType,
  HmRouterPathConstants,
  HomeArticleResponse,
  showToast,
  UtilConstants
} from "utils";
import { ProjectNetFunc } from "../net/ProjectNetFunc";
import { ArticleListDataSource } from "utils/src/main/ets/model/ArticleLstDataSource";
import { PullToRefresh, PullToRefreshType } from "@ohos/pulltorefresh";
import { HMRouterMgr } from "@hadss/hmrouter";

const TAG: string = 'ArticleList';

@Component
export struct ArticleList {
  @StorageProp('currentWidthBreakpoint') currentWidthBreakpoint: string = UtilConstants.CONST_BREAKPOINT_MD;
  @Prop tabId: number;
  @State isMore: boolean = true;
  @State lazyArticleList: ArticleListDataSource = new ArticleListDataSource();
  @State isRefresh: boolean = false;
  pageIndex: number = 1;
  @State articleList: Article[] = [];
  private scroller: Scroller = new Scroller();
  private modifier: MyListModifier = new MyListModifier(new BreakpointType(1, 2, 3).getValue(this.currentWidthBreakpoint));

  aboutToAppear(): void {
    this.getProjectArticleList(this.tabId, this.pageIndex);
  }

  getProjectArticleList(id: number, pageIndex: number) {
    ProjectNetFunc.getProjectArticleList(id, pageIndex).then((response: HomeArticleResponse) => {
      if (response.errorCode === 0) {
        let articleList = response.data.datas;
        if (response.data.size === UtilConstants.CONST_PAGE_SIZE) {
          this.isMore = true;
        } else {
          this.isMore = false;
        }
        if (pageIndex === 0) {
          this.lazyArticleList.clear();
          this.isRefresh = false;
        }

        articleList.forEach((item) => {
          this.lazyArticleList.pushData(item);
        })

        this.articleList = this.lazyArticleList.getDataList();
        console.log(TAG, `data length:${response.data.size}`);
      } else {
        showToast('getProjectArticleList errorCode:' + response.errorCode);
      }
    }).catch((err: NetError) => {
      console.error(TAG, 'getProjectArticleList err code:' + err.code + ', message:' + err.message);
    })
  }

  build() {
    Column() {
      PullToRefresh({
        pullToRefreshType: PullToRefreshType.LIST,
        // data: this.articleList,
        refreshing: $isRefresh,
        customList: () => {
          this.articleListPage();
        },
        onRefresh: () => {
          return new Promise((resolve, reject) => {
            resolve(UtilConstants.CONST_PULL_HINT);
            this.pageIndex = 0;
            this.getProjectArticleList(this.tabId, this.pageIndex);
            console.log(TAG, 'onRefresh, pageIndex:' + this.pageIndex);
          })
        },
        modifierListAttribute: this.modifier,
        onLoadMore: () => {
          return new Promise((resolve, reject) => {
            if (this.isMore) {
              resolve(UtilConstants.CONST_LOAD_HINT);
            } else {
              resolve(UtilConstants.CONST_LOAD_END_HINT);
            }
            this.pageIndex = this.pageIndex + 1;
            console.log(TAG, 'onLoadMore, pageIndex:' + this.pageIndex);
            this.getProjectArticleList(this.tabId, this.pageIndex);
          })
        },
        customLoad: null,
        customRefresh: null,
      })
    }
    .width(UtilConstants.CONST_WIDTH_UI)
    .height(UtilConstants.CONST_HEIGHT_UI)
  }

  @Builder
  articleListPage() {
    // List({ space: UtilConstants.CONST_UI_SIZE_10, scroller: this.scroller }) {
      LazyForEach(this.lazyArticleList, (article: Article) => {
        ListItem() {
          ArticleListItem({ item: article })
            .onClick(() => {
              HMRouterMgr.push({
                pageUrl: HmRouterPathConstants.PAGE_ARTICLE_DETAIL_NAV,
                param: { title: article.title, link: article.link, desc: article.superChapterName }
              })
            })
        }
      }, (item: Article, index: number) => JSON.stringify(item.id) + '_' + this.tabId)
    // }
    // .cachedCount(3)
    // .lanes(new BreakpointType(1, 2, 3).getValue(this.currentWidthBreakpoint))
    // .edgeEffect(EdgeEffect.None)
    // .width(UtilConstants.CONST_HEIGHT_UI)
    // .height(UtilConstants.CONST_HEIGHT_UI)
    // .backgroundColor(UtilConstants.CONST_UI_COLOR_f6f7f6)
  }
}

//动态添加list组件的属性
class MyListModifier implements AttributeModifier<ListAttribute> {

  private lanes :number;

  constructor(lanes:number) {
    this.lanes=lanes;
  }

  applyNormalAttribute(instance: ListAttribute): void {
    instance.cachedCount(3);
    instance.edgeEffect(EdgeEffect.None);
    instance.lanes(this.lanes);
    instance.backgroundColor(UtilConstants.CONST_UI_COLOR_f6f7f6);
    instance.width(UtilConstants.CONST_HEIGHT_UI);
    instance.height(UtilConstants.CONST_HEIGHT_UI);
  }
}