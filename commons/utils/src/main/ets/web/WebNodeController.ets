import { BuilderNode, NodeController } from "@kit.ArkUI";

const TAG:string='WebNodeController'

/**
 * node控制器集合
 */
let nodeMap: Map<string, WebNodeController | undefined> = new Map();
/**
 * web控制器集合
 */
let controllerMap: Map<string, WebviewController | undefined> = new Map();
/**
 * 页面加载完成集合
 */
let onPageEndMap: Map<string, Function | undefined> = new Map();
/**
 * 进度变化集合
 */
let onProgressChangeMap: Map<string, Function | undefined> = new Map();
/**
 * 资源文件url信息集合
 */
let onResourceLoadMap: Map<string, Function | undefined> = new Map();

let wrap = wrapBuilder<WebData[]>(webBuilder);

class WebData {
  /**
   * 网页url
   */
  public url: string;
  /**
   * web控制器
   */
  public controller: WebviewController;
  /**
   * 页面加载完成回调
   */
  public onPageEndAction?: Function;
  /**
   * 进度变化回调
   */
  public onProgressChangeAction?: Function;
  /**
   * 资源加载回调
   */
  public onResourceLoadAction?: Function;

  constructor(url: string, controller: WebviewController) {
    this.url = url;
    this.controller = controller;
  }
}

@Builder
function webBuilder(data: WebData) {
  Web({ src: data.url.split('~')[0], controller: data.controller })
  // 设置是否开启文档对象模型存储接口（DOM Storage API）权限，默认未开启
    .domStorageAccess(true)
    // 设置是否支持手势进行缩放，默认允许执行缩放
    .zoomAccess(true)
    // 设置是否开启应用中文件系统的访问
    .fileAccess(true)
    // 设置是否允许加载超文本传输协议（HTTP）和超文本传输安全协议（HTTPS）混合内容，默认不允许加载HTTP和HTTPS混合内容
    .mixedMode(MixedMode.All)
    // 设置缓存模式
    .cacheMode(CacheMode.Default)
    // 设置是否显示纵向滚动条，包括系统默认滚动条和用户自定义滚动条。默认显示
    .verticalScrollBarAccess(false)
    // 设置是否允许执行JavaScript脚本，默认允许执行
    .javaScriptAccess(true)
    // 设置网页是否开启捏合流畅模式，默认不开启
    .pinchSmooth(true)
    // 设置网页首次内容绘制回调函数
    .onFirstContentfulPaint(() => {
      nodeMap.set('HmWan_' + data.url, undefined);
    })
    // 网页加载完成时触发该回调，且只在主frame触发
    .onPageEnd(() => {
      onPageEndMap.get(data.url)?.();
    })
    // 网页加载进度变化时触发该回调
    .onProgressChange((event) => {
      console.info(TAG, 'newProgress:' + event?.newProgress);

      if (event?.newProgress === 100) {
        onProgressChangeMap.get(data.url)?.();
      }

      console.info(TAG, 'onProgressChange weburl: ' + data.url);
    })
    // 通知Web组件所加载的资源文件url信息
    .onResourceLoad((event) => {
      console.info(TAG, 'onResourceLoad:' + event?.url);

      onResourceLoadMap.get(data.url)?.(event.url);
    })
    .width('100%')
    .height('100%')
}

/**
 * 控制并反馈相应NodeContainer上节点的行为
 * 它必须与NodeContainer一起使用
 */
export class WebNodeController extends NodeController {
  private rootNode: BuilderNode<WebData[]> | null | undefined = null;

  private isRemove: boolean = false;

  // 用于构造节点数量，并返回对应NodeContainer中的节点挂载。
  // 当创建相应的NodeContainer或使用rebuild方法时调用此API
  makeNode(uiContext: UIContext): FrameNode | null {
    console.info(TAG, ' uiContext is undifined : ' + (uiContext === undefined));

    if (this.isRemove) {
      return null;
    }

    if (this.rootNode != undefined) {
      // 返回FrameNode节点
      return this.rootNode.getFrameNode();
    }
    // 返回null控制动态组件脱离绑定节点
    return null;
  }

  // 立即处理BuilderNode
  disposeNode() {
    this.rootNode?.dispose();
  }

  // 当布局大小发生变化时进行回调
  aboutToResize(size: Size) {
    console.info(TAG, 'aboutToResize width : ' + size.width + ' height : ' + size.height);
  }

  aboutToAppear() {
    if (this.rootNode == undefined) {
      return;
    }
  }

  aboutToDisappear() {
    console.info(TAG, 'aboutToDisappear');
  }

  /**
   * 初始化web 组件
   * @param url
   * @param uiContext
   * @param control
   * @param onPageEndAction
   */
  initWeb(url: string, uiContext: UIContext, control: WebviewController, onPageEndAction?: Function) {
    if (this.rootNode != null) {
      return;
    }
    // uiContext is required for creating a node.
    this.rootNode = new BuilderNode(uiContext);
    this.rootNode.dispose()
    // Creating an Offline Component
    this.rootNode.build(wrap, { url: url, controller: control });
  }
}

export {nodeMap,controllerMap,onPageEndMap,onProgressChangeMap,onResourceLoadMap};