import { NetError } from "network";
import {
  emptyView,
  FooterView,
  HeaderView,
  LoadingStatus,
  LoadingView,
  NoMore,
  PreferenceManager,
  showToast,
  UtilConstants
} from "utils";
import { MessageInfo, MessageInfoResponse } from "../model/UserMessageResponse";
import { MineNetFunc } from "../net/MineNetFunc";
import { JSON } from "@kit.ArkTS";
import { MessageListItem } from "./MessageListItem";

const TAG: string = 'MessageComponents';

@ComponentV2
export struct MessageComponents {
  manager: PreferenceManager = PreferenceManager.getInstance();
  @Param @Require msgType: string;
  @Local loadingStatus: LoadingStatus = LoadingStatus.LOADINGSTART;
  @Local refreshStatus: RefreshStatus = RefreshStatus.Inactive;
  @Local isMore: boolean = true;
  @Local isRefresh: boolean = false;
  @Local mOffset: number = 0;
  @Local message: string = '';
  @Local pageNum: number = 1;
  @Local messageList: MessageInfo[] = [];

  aboutToAppear(): void {
    this.selectType();
  }

  private selectType() {
    if (this.msgType === 'unread') {
      this.getUserMessageUNReadList(this.pageNum);
    } else {
      this.getUserMessageReadList(this.pageNum);
    }
    console.log(TAG, `msgType:${this.msgType}`);
    this.message = this.msgType;
  }

  async getUserMessageUNReadList(pageNum: number) {
    if (!this.isRefresh && pageNum === 1) {
      this.loadingStatus = LoadingStatus.LOADINGSTART;
    }
    let cookie = await this.manager.getValue('cookie') as string;
    MineNetFunc.getUserMessageUNRead(cookie, pageNum).then((response: MessageInfoResponse) => {

      if (response.errorCode === 0) {
        let dataList = response.data.datas;

        if (this.isRefresh) {
          this.messageList.length = 0;
          this.isRefresh = false;
        }

        if (dataList.length !== 0) {
          this.isMore = true;
        } else {
          this.isMore = false;
        }

        dataList.forEach((item) => {
          this.messageList.push(item);
        })
        console.log(TAG, `getUserMessageUNReadList data length:${this.messageList.length}`);

        this.loadingStatus = LoadingStatus.LOADINGEND;
      } else {
        this.loadingStatus = LoadingStatus.LOADINGEND;
        showToast('getUserMessageUNReadList errorCode:' + response.errorCode);
      }
    }).catch((err: NetError) => {
      this.loadingStatus = LoadingStatus.LOADINGEND;
      console.log(TAG, 'getUserMessageUNReadList error code:' + err.code + '，message:' + err.message);
    });
  }

  async getUserMessageReadList(pageNum: number) {
    if (!this.isRefresh && pageNum === 1) {
      this.loadingStatus = LoadingStatus.LOADINGSTART;
    }
    let cookie = await this.manager.getValue('cookie') as string;
    MineNetFunc.getUserMessageRead(cookie, pageNum).then((response: MessageInfoResponse) => {

      if (response.errorCode === 0) {
        let dataList = response.data.datas;

        if (this.isRefresh) {
          this.messageList.length = 0;
          this.isRefresh = false;
        }

        if (dataList.length !== 0) {
          this.isMore = true;
        } else {
          this.isMore = false;
        }

        dataList.forEach((item) => {
          this.messageList.push(item);
        })
        console.log(TAG, `getUserMessageReadList messageList length:${this.messageList.length}`);

        this.loadingStatus = LoadingStatus.LOADINGEND;
      } else {
        showToast('getUserMessageReadList errorCode:' + response.errorCode);
      }
    }).catch((err: NetError) => {
      console.log(TAG, 'getUserMessageReadList error code:' + err.code + '，message:' + err.message);
    });
  }

  build() {
    Stack() {
      Refresh({ refreshing: !!this.isRefresh, builder: HeaderView(this.mOffset, this.refreshStatus, this.isRefresh) }) {
        List({ space: UtilConstants.CONST_UI_SIZE_10 }) {
          Repeat<MessageInfo>(this.messageList).each((repeatItem: RepeatItem<MessageInfo>) => {
            ListItem() {
              MessageListItem({ message: repeatItem.item })
            }
          }).key((item: MessageInfo, index: number) => {
            return index + '_' + JSON.stringify(item)
          })

          if (!this.isMore) {
            ListItemGroup({ footer: NoMore() })
          } else {
            ListItemGroup({ footer: FooterView() })
          }
        }
        .visibility(this.messageList.length === 0 && this.pageNum === 1 ? Visibility.None : Visibility.Visible)
        .cachedCount(2)
        .scrollBar(BarState.Off)
        .padding({ left: UtilConstants.CONST_UI_SIZE_10, right: UtilConstants.CONST_UI_SIZE_10 })
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
        .width(UtilConstants.CONST_UI_PER_100)
        .height(UtilConstants.CONST_UI_PER_100)
        .onScrollIndex((start: number, end: number, center: number) => {
          if (end >= this.messageList.length - 1) {
            console.log(TAG, 'onScrollIndex end:' + end);
            this.pageNum++;
            this.isRefresh = false;
            this.isMore = true;
            this.selectType();
          }
        })
      }
      .width(UtilConstants.CONST_UI_PER_100)
      .height(UtilConstants.CONST_UI_PER_100)
      .onOffsetChange((offset: number) => {
        this.mOffset = offset;
        console.log(TAG, 'onOffsetChange offset:' + offset);
      })
      .onStateChange((state: RefreshStatus) => {
        this.refreshStatus = state;
        console.log(TAG, 'onStateChange state:' + state);
      })
      .onRefreshing(() => {
        console.log(TAG, 'onRefreshing');
        this.isRefresh = true;
        this.pageNum = 1;
        this.selectType();
      })

      if (this.messageList.length === 0 && this.pageNum === 1) {
        emptyView()
      }

      LoadingView()
        .visibility(this.loadingStatus === LoadingStatus.LOADINGSTART ? Visibility.Visible : Visibility.None)
    }
    .width(UtilConstants.CONST_UI_PER_100)
    .height(UtilConstants.CONST_UI_PER_100)
    .backgroundColor(UtilConstants.CONST_UI_COLOR_F3F4F5)
  }
}