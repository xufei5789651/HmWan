import {
  controllerMap,
  nodeMap,
  onPageEndMap,
  onProgressChangeMap,
  onResourceLoadMap,
  WebNodeController
} from "./WebNodeController";
import { webview } from "@kit.ArkWeb";


/**
 * 动态创建Web组件
 * @param url
 * @param uiContext
 */
export function createNWeb(url: string, uiContext: UIContext) {
  if (nodeMap.has(url)) {
    return;
  }
  let baseNode = new WebNodeController();
  let controller = new webview.WebviewController();

  baseNode.initWeb(url, uiContext, controller);
  // Save the controller of the web page to the map so that the controller can be used when the web page is returned.
  controllerMap.set(url, controller)
  nodeMap.set(url, baseNode);
}

/**
 * 获取web 组件
 * @param url
 * @returns
 */
export const getNWeb = (url: string): WebNodeController | undefined => {
  return nodeMap.get(url);
}
/**
 * 获取web控制器
 * @param url
 * @returns
 */
export const getController = (url: string): WebviewController | undefined => {
  return controllerMap.get(url);
}
/**
 * 设置页面结束回调方法
 * @param url
 * @param onPageEndAction
 */
export const setOnPageEndAction = (url: string, onPageEndAction: Function): void => {
  onPageEndMap.set(url, onPageEndAction);
}
/**
 * 设置进度变化回调方法
 * @param url
 * @param onProgressChangeAction
 */
export const setOnProgressChangeAction = (url: string, onProgressChangeAction: Function): void => {
  onProgressChangeMap.set(url, onProgressChangeAction);
}
/**
 * 设置资源文件url回调方法
 * @param url
 * @param onResourceLoadAction
 */
export const setOnResourceLoadAction = (url: string, onResourceLoadAction: Function): void => {
  onResourceLoadMap.set(url, onResourceLoadAction);
}

/**
 * 销毁指定创建的节点
 */
export const deleteNode = (url: string) => {
  let nodeController = nodeMap.get(url);
  nodeController?.disposeNode();
  nodeMap.delete(url);
  controllerMap.delete(url);
  onPageEndMap.delete(url);
}

