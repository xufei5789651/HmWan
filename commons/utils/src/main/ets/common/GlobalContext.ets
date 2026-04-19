// GlobalContext.ts
import { common } from '@kit.AbilityKit';

export class GlobalContext {
  private static instance: GlobalContext;
  private contexts = new Map<string, common.UIAbilityContext>();

  private constructor() {} // 私有构造

  public static getInstance(): GlobalContext {
    if (!GlobalContext.instance) {
      GlobalContext.instance = new GlobalContext();
    }
    return GlobalContext.instance;
  }

  // 存储Context
  setContext(key: string, context: common.UIAbilityContext): void {
    this.contexts.set(key, context);
  }

  // 获取Context
  getContext(key: string): common.UIAbilityContext | undefined {
    return this.contexts.get(key);
  }
}