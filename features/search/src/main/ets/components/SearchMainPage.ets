import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { ListManager, NodeItem, RecyclerView } from '@hadss/scroll_components';
import { NetError } from 'network';
import { Article, FooterView, HmRouterPathConstants, NoMore, showToast, UtilConstants } from 'utils';
import { SearchParam } from '../model/SearchParam';
import { SearchNetFunc } from '../net/SearchNetFunc';
import { SearchListItem } from './SearchListItem';

const TAG: string = 'SearchMainPage';

@HMRouter({ pageUrl: HmRouterPathConstants.PAGE_SEARCH_NAV })
@Component
export struct SearchMainPage {
  searchListManager: ListViewManager =
    new ListManager({ defaultNodeItem: 'SearchListView', context: this.getUIContext() })
  @State keyWord: string = '';
  @State pageNum: number = 0;
  @State isMore: boolean = false;
  @State noMore: boolean = false;
  @State dataList: Article[] = [];
  scroller: Scroller = new Scroller();

  aboutToAppear(): void {
    this.initListView();
  }

  private requestSearch() {
    if (this.keyWord.length === 0) {
      showToast('请输入搜索内容')
      return;
    }
    this.isMore = true;

    let search: SearchParam = { k: this.keyWord, pageNum: this.pageNum };
    SearchNetFunc.search(search).then((response) => {
      console.log(TAG, 'search length:' + response.data.datas.length);
      if (response.errorCode === 0) {
        let list = response.data.datas;

        if (this.pageNum === 0) {
          this.searchListManager.nodeAdapter.deleteData(0, this.dataList.length);
        }

        list.forEach((item) => {
          this.dataList.push(item);
        })

        this.searchListManager.nodeAdapter.pushData(list);

        if (list.length === 0 && this.pageNum !== 0) {
          this.noMore = true;
        } else {
          this.isMore = false;
        }
      } else {
        showToast('requestSearch errorCode:' + response.errorCode);
      }
    }).catch((err: NetError) => {
      console.error(TAG, 'search err code:' + err.code + ', message:' + err.message);
    });
  }

  initListView() {
    this.searchListManager.registerNodeItem('SearchListView', wrapBuilder(SearchListView));

    this.searchListManager.setViewStyle({ scroller: this.scroller })
      .width(UtilConstants.CONST_UI_PER_100)
      .height(UtilConstants.CONST_UI_PER_100)
      .onReachEnd(() => {
        if(!this.isMore){
          this.pageNum++;
          this.requestSearch();
        }
      })

    this.searchListManager.setItemViewStyle((item:ListItemInterface,index:number,data:Article)=>{
       item().onClick(()=>{
         HMRouterMgr.push({
           pageUrl: HmRouterPathConstants.PAGE_SEARCH_DETAIL_NAV,
           param: { link: data.link }
         })
       })
    })
  }

  build() {
    Column() {
      Search({ value: this.keyWord, placeholder: '搜索内容' })
        .width(UtilConstants.CONST_UI_PER_95)
        .height(40)
        .placeholderColor($r('app.color.search_placeholder_background'))
        .backgroundColor($r('app.color.article_item_background'))
        .textAlign(TextAlign.Start)
        .borderColor($r('app.color.search_border_color'))
        .enterKeyType(EnterKeyType.Search)
        .onSubmit((value: string) => {
          this.keyWord = value;
          this.pageNum = 0;
          this.requestSearch();
        })
        .onChange((value: string) => {
          this.keyWord = value;
        })

      this.buildListView()

      if (this.isMore) {
        FooterView();
      }

      if (this.noMore) {
        NoMore();
      }
    }
    .width(UtilConstants.CONST_UI_PER_100)
    .backgroundColor($r('app.color.search_background'))
  }

  @Builder
  buildListView() {
    RecyclerView({ viewManager: this.searchListManager })
  }
}

@Builder
function SearchListView(data: Article) {
  SearchListItem({ item: data });
}

class ListViewManager extends ListManager {
  onWillCreateItem(index: number, data: Article): NodeItem<Article> | null {
    let node: NodeItem<Article> | null = this.dequeueReusableNodeByType('SearchListView');
    node.setData(data);
    return node;
  }
}
