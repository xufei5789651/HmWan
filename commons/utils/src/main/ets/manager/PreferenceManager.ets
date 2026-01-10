import { common } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';

const PREFERENCES_NAME: string = 'DataStore';

/**
 * 用户首选项
 */
export class PreferenceManager {
  private preferences?: preferences.Preferences;
  private context = getContext(this) as common.UIAbilityContext;
  private static instance: PreferenceManager;

  private constructor() {
    this.initPreference(PREFERENCES_NAME);
  }

  static getInstance(): PreferenceManager {
    if (!PreferenceManager.instance) {
      PreferenceManager.instance = new PreferenceManager();
    }
    return PreferenceManager.instance;
  }

  /**
   * 获取Preferences实例
   * @param storeName
   * @returns
   */
  async initPreference(storeName: string): Promise<void> {
    return preferences.getPreferences(this.context, storeName)
      .then((preferences: preferences.Preferences) => {
        this.preferences = preferences;
      });
  }

  /**
   * 将数据写入Preferences实例
   * @param key
   * @param value
   * @returns
   */
  async setValue<T>(key: string, value: T): Promise<void> {
    if (this.preferences) {
      this.preferences.put(key, JSON.stringify(value)).then(() => {
        this.saveUserData();
      })
    } else {
      this.initPreference(PREFERENCES_NAME).then(() => {
        this.setValue<T>(key, value);
      });
    }
  }

  /**
   * 获取key对应的值
   * @param key
   * @returns
   */
  async getValue<T>(key: string): Promise<T | null> {
    if (this.preferences) {
      return this.preferences.get(key, '').then((res: preferences.ValueType) => {
        let value: T | null = null;
        if (res) {
          value = JSON.parse(res as string) as T;
        }
        return value;
      });
    } else {
      return this.initPreference(PREFERENCES_NAME).then(() => {
        return this.getValue<T>(key);
      });
    }
  }

  /**
   * 是否包含名为给定Key的存储键值对
   * @param key
   * @returns
   */
  async hasValue(key: string): Promise<boolean> {
    if (this.preferences) {
      return this.preferences.has(key);
    } else {
      return this.initPreference(PREFERENCES_NAME).then(() => {
        return this.hasValue(key);
      });
    }
  }

  /**
   * 删除名为给定Key的存储键值对
   * @param key
   * @returns
   */
  async deleteValue(key: string): Promise<void> {
    if (this.preferences) {
      this.preferences.delete(key).then(() => {
        this.saveUserData();
      });
    } else {
      this.initPreference(PREFERENCES_NAME).then(() => {
        this.deleteValue(key);
      });
    }
  }

  /**
   * 保存用户数据到用户首选项持久化文件中
   */
  private saveUserData() {
    this.preferences?.flush();
  }
}