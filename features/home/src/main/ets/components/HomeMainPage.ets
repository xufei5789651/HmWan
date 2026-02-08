import { PullToRefresh, PullToRefreshType } from '@ohos/pulltorefresh';
import { NetError } from 'network';
import { BreakpointType, HmRouterPathConstants, showToast, UtilConstants } from 'utils';
import { ArticleListDataSource } from 'utils/src/main/ets/model/ArticleLstDataSource';
import { BannerItem, BannerResponse } from '../model/BannerModel';
import { Article, bannerItem, HomeArticleResponse } from 'utils/src/main/ets/model/HomeArticleModel';
import { HomeNetFunc } from '../net/HomeNetFunc';
import { ItemArticle } from './ItemArticle';
import { HMRouterMgr } from '@hadss/hmrouter';

const TAG = 'HomeMainPage';

@Preview
@Component
export struct HomeMainPage {
  @StorageProp('currentWidthBreakpoint') currentWidthBreakpoint: string = UtilConstants.CONST_BREAKPOINT_MD;
  @State lazyArticleList: ArticleListDataSource = new ArticleListDataSource();
  @State bannerList: BannerItem[] = [];
  @State isRefresh: boolean = false;
  @State articleList: Article[] = [];
  pageIndex: number = 0;
  private modifier: MyListModifier = new MyListModifier();

  aboutToAppear(): void {
    this.getBannerList();
    this.getHomeArticleList(this.pageIndex);
  }

  getBannerList() {
    HomeNetFunc.getBannerList().then((response: BannerResponse) => {
      if (response.errorCode === 0) {
        this.bannerList = response.data;
        console.log(TAG, 'bannerList length:' + this.bannerList.length);
      } else {
        showToast(`bannner,errorCode:${response.errorCode},errorMsg${response.errorMsg}`);
      }
    }).catch((err: NetError) => {
      console.log(TAG, 'getBannerList error code:' + err.code + '，message:' + err.message);
    });
  }

  getHomeArticleList(pageIndex: number) {
    HomeNetFunc.getHomeArticleList(pageIndex).then((response: HomeArticleResponse) => {
      if (response.errorCode === 0) {
        let articleList = response.data.datas;
        console.log(TAG, 'getHomeArticleList pageIndex:' + pageIndex + ', ArticleList length:' + articleList.length);
        if (pageIndex === 0) {
          this.lazyArticleList.clear();
          this.lazyArticleList.pushData(bannerItem);
        }
        articleList.forEach((item) => {
          this.lazyArticleList.pushData(item);
        })

        this.articleList = this.lazyArticleList.getDataList();
      } else {
        showToast(`ArticleList,errorCode:${response.errorCode},errorMsg${response.errorMsg}`);
      }
    }).catch((err: NetError) => {
      console.error(TAG, 'getHomeArticleList error code:' + err.code + '，message:' + err.message);
    });
  }

  build() {
    Column() {
      PullToRefresh({
        pullToRefreshType: PullToRefreshType.SCROLL,
        refreshing: $isRefresh,
        customList: () => {
          this.homePageList();
        },
        onRefresh: () => {
          return new Promise((resolve, reject) => {
            resolve('刷新成功');
            this.pageIndex = 0;
            this.getHomeArticleList(this.pageIndex);
            console.log(TAG, 'onRefresh, pageIndex:' + this.pageIndex);
          })
        },
        modifierListAttribute: this.modifier,
        onLoadMore: () => {
          return new Promise((resolve, reject) => {
            resolve('加载更多');
            this.pageIndex = this.pageIndex + 1;
            console.log(TAG, 'onLoadMore, pageIndex:' + this.pageIndex);
            this.getHomeArticleList(this.pageIndex);
          })
        },
        customLoad: null,
        customRefresh: null,
      })
    }
  }

  @Builder
  homePageList() {
        LazyForEach(this.lazyArticleList, (article: Article) => {
          ListItem() {
            if (article.id === -1) {
              Swiper() {
                ForEach(this.bannerList, (item: BannerItem, index: number) => {
                  Image(item.imagePath)
                    .width(UtilConstants.CONST_WIDTH_UI)
                    .height(UtilConstants.CONST_HEIGHT_UI)
                    .onClick(() => {
                      HMRouterMgr.push({
                        pageUrl: HmRouterPathConstants.PAGE_ARTICLE_DETAIL_NAV,
                        param: { link: item.url }
                      })
                    })
                }, (item: BannerItem, index: number) => {
                  return JSON.stringify(item.id);
                })
              }
              .displayCount(new BreakpointType(1, 2, 2).getValue(this.currentWidthBreakpoint))
              .loop(true)
              .prevMargin(new BreakpointType(0, 12, 12).getValue(this.currentWidthBreakpoint))
              .nextMargin(new BreakpointType(0, 12, 12).getValue(this.currentWidthBreakpoint))
              .autoPlay(true)
              .indicator(Indicator.dot().selectedColor($r('app.color.color_67bc5e')))
              .height(UtilConstants.CONST_UI_PER_30)
              .width(UtilConstants.CONST_HEIGHT_UI)
            } else {
              ItemArticle({ item: article })
                .onClick(() => {
                  HMRouterMgr.push({
                    pageUrl: HmRouterPathConstants.PAGE_ARTICLE_DETAIL_NAV,
                    param: { link: article.link }
                  })
                })
            }
          }
        }, (item: Article, index: number) => {
          return JSON.stringify(item.id);
        })
  }
}

//动态添加list组件的属性
class MyListModifier implements AttributeModifier<ListAttribute> {
  applyNormalAttribute(instance: ListAttribute): void {
    instance.cachedCount(3);
    instance.edgeEffect(EdgeEffect.None);
    instance.backgroundColor($r('app.color.color_f6f7f6'));
    instance.width(UtilConstants.CONST_HEIGHT_UI);
    instance.height(UtilConstants.CONST_HEIGHT_UI);
  }
}

