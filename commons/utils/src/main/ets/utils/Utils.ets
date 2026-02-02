import { promptAction } from "@kit.ArkUI";
import { systemShare } from "@kit.ShareKit";
import { uniformTypeDescriptor } from "@kit.ArkData";
import { common } from "@kit.AbilityKit";
import { BusinessError } from '@kit.BasicServicesKit';

export function showToast(message: string, duration: number = 2000) {
  try {
    promptAction.showToast({
      message: message,
      duration: duration,
      bottom: "center",
    })
  } catch (error) {
    console.error(`showToast args error code is ${error.code}, message is ${error.message}`);
  }
}

export function shareLink(context: common.UIAbilityContext, title: string = '', link: string = '',
  description: string = '') {
  let shareData: systemShare.SharedData = new systemShare.SharedData({
    utd: uniformTypeDescriptor.UniformDataType.HYPERLINK,
    content: link,
    title: title,
    description: description,
  });

  let controller: systemShare.ShareController = new systemShare.ShareController(shareData);
  controller.show(context, {
    selectionMode: systemShare.SelectionMode.SINGLE,
    previewMode: systemShare.SharePreviewMode.DEFAULT,
  }).then(() => {
    console.info('shareLink show success.');
  }).catch((error: BusinessError) => {
    console.error(`shareLink show error. code: ${error.code}, message: ${error.message}`);
  });
}
