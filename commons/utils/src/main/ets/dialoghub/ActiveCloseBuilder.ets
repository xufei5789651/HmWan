import { UtilConstants } from "../common/UtilConstants";

export class ActiveCloseParams {
  title: string;
  content: string;
  leftButton: string;
  rightButton: string;
  onCancel: () => void
  action?: () => void;
  actionColor?: ResourceColor;

  constructor(title: string, content: string, leftButton: string, rightButton: string, onCancel: () => void,
    action?: () => void, actionColor?: ResourceColor) {
    this.title = title;
    this.content = content;
    this.leftButton = leftButton;
    this.rightButton = rightButton;
    this.actionColor = actionColor;
    this.onCancel = onCancel;
    this.action = action;
  }
}

@Builder
export function ActiveCloseBuilder(params: ActiveCloseParams) {

  Column() {
    Text(params.title)
      .height($r('app.float.active_close_title_height'))
      .fontWeight(FontWeight.Bold)
      .fontSize($r('app.float.font_size_large'))
      .fontColor($r('app.color.item_text_color'))

    Text(params.content)
      .fontSize($r('app.float.font_size_regular'))
      .fontColor($r('app.color.active_close_content_color'))
      .margin({ bottom: $r('app.float.active_close_content_margin') })

    Row() {
      Button(params.leftButton, { type: ButtonType.Normal })
        .commonButton($r('app.color.base_blue'))
        .onClick(() => {
          params.onCancel();
        })
      Button(params.rightButton, { type: ButtonType.Normal })
        .commonButton(params.actionColor ?? $r('app.color.base_red'))
        .onClick(() => {
          params.action?.();
        })
    }.width(UtilConstants.CONST_UI_PER_100).justifyContent(FlexAlign.SpaceBetween)
  }
  .width($r('app.float.active_close_builder_width'))
  .height($r('app.float.active_close_builder_height'))
  .padding({ left: $r('app.float.active_close_builder_padding'), right: $r('app.float.active_close_builder_padding') })
}

@Extend(Button)
function commonButton(fontColor: ResourceColor) {
  .width($r('app.float.active_close_action_width'))
  .height($r('app.float.active_close_action_height'))
  .fontSize($r('app.float.font_size_medium'))
  .fontWeight(FontWeight.Medium)
  .fontColor(fontColor)
  .backgroundColor(Color.Transparent)
}