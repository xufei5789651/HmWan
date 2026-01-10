import { UtilConstants } from "../common/UtilConstants";

@Builder
export function HeaderView(offset: number, state: RefreshStatus, isRefresh: boolean) {
  Row() {
    if (state != RefreshStatus.Inactive && state != RefreshStatus.Done) {
      Progress({ value: offset, total: UtilConstants.REFRESH_OFFSET_TOTAL, type: ProgressType.Ring })
        .width(UtilConstants.CONST_UI_SIZE_32)
        .height(UtilConstants.CONST_UI_SIZE_32)
        .style({ status: isRefresh ? ProgressStatus.LOADING : ProgressStatus.PROGRESSING })
        .margin(UtilConstants.CONST_UI_SIZE_10)

      Text(state == RefreshStatus.Drag ? UtilConstants.CONST_PULL_DOWN_HINT : UtilConstants.CONST_PULL_HINT)
        .fontSize(UtilConstants.CONST_UI_SIZE_15)
        .margin({ left: UtilConstants.CONST_UI_SIZE_20 })
    }
  }
  .clip(true)
  .justifyContent(FlexAlign.Center)
  .width(UtilConstants.CONST_UI_PER_100)
  .height(UtilConstants.CONST_UI_PER_100)
}

@Builder
export function FooterView() {
  Row() {
    LoadingProgress()
      .height(UtilConstants.CONST_UI_SIZE_32)
      .width(UtilConstants.CONST_UI_SIZE_45)

    Text(UtilConstants.CONST_LOADING_HINT)
  }
  .width(UtilConstants.CONST_UI_PER_100)
  .height(UtilConstants.CONST_UI_SIZE_64)
  .justifyContent(FlexAlign.Center)
}