import { display } from "@kit.ArkUI";
import { UtilConstants } from "../common/UtilConstants";

const TAG:string='WindowUtils';

export class WindowUtils {
  static updateWidthBp(windowWidth: number) {
    console.log(TAG,'--->updateWidthBp');
    let windowWidthVp = windowWidth / display.getDefaultDisplaySync().densityPixels;
    let widthBp: string = '';
    if (windowWidthVp < UtilConstants.CONST_WIDTH_BREAKPOINT_XS) {
      widthBp = 'xs';
    } else if (windowWidthVp >= UtilConstants.CONST_WIDTH_BREAKPOINT_XS &&
      windowWidthVp < UtilConstants.CONST_WIDTH_BREAKPOINT_SM) {
      widthBp = 'sm';
    } else if (windowWidthVp >= UtilConstants.CONST_WIDTH_BREAKPOINT_SM &&
      windowWidthVp < UtilConstants.CONST_WIDTH_BREAKPOINT_LG) {
      widthBp = 'md';
    } else if (windowWidthVp >= UtilConstants.CONST_WIDTH_BREAKPOINT_LG &&
      windowWidthVp < UtilConstants.CONST_WIDTH_BREAKPOINT_XL) {
      widthBp = 'lg';
    } else {
      widthBp = 'xl';
    }
    AppStorage.setOrCreate('currentWidthBreakpoint', widthBp);
  }

  static updateHeightBp(windowWidth: number, windowHeight: number) {
    console.log(TAG,'--->updateHeightBp');
    let windowWidthVp = windowWidth / display.getDefaultDisplaySync().densityPixels;
    let windowHeightVp = windowHeight / display.getDefaultDisplaySync().densityPixels
    let heightBp: string = '';
    let aspectRatio: number = windowHeightVp / windowWidthVp;
    if (aspectRatio < UtilConstants.CONST_HEIGHT_BREAKPOINT_RATIO_0) {
      heightBp = 'sm';
    } else if (aspectRatio >= UtilConstants.CONST_HEIGHT_BREAKPOINT_RATIO_0 &&
      aspectRatio < UtilConstants.CONST_HEIGHT_BREAKPOINT_RATIO_1) {
      heightBp = 'md';
    } else {
      heightBp = 'lg';
    }
    AppStorage.setOrCreate('currentHeightBreakpoint', heightBp);
  }
}