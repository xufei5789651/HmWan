import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';

const PREFERENCES_NAME: string = 'DataStore';

const TAG: string = 'PreferenceManager';

/**
 * 用户首选项
 */
export class PreferenceManager {
  private preferences?: preferences.Preferences;
  private static instance: PreferenceManager;

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
  private async initPreference(context: Context, storeName: string): Promise<void> {
    return preferences.getPreferences(context, storeName)
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
  async setValue<T>(context: Context, key: string, value: T): Promise<void> {
    this.initPreference(context, PREFERENCES_NAME);
    this.preferences!.put(key, JSON.stringify(value)).then(() => {
      this.saveUserData();
    })
  }

  /**
   * 获取key对应的值
   * @param key
   * @returns
   */

  async getValue<T>(context: Context, key: string): Promise<T | null> {
    this.initPreference(context, PREFERENCES_NAME);
    return this.preferences!.get(key, '').then((res: preferences.ValueType) => {
      let value: T | null = null;
      if (res) {
        value = JSON.parse(res as string) as T;
      }
      console.log(TAG, 'getValue value:' + value);
      return value;
    }).catch((err: BusinessError) => {
      console.error(TAG, 'getValue code:' + err.code + ',message:' + err.message);
      return null;
    });
  }

  /**
   * 是否包含名为给定Key的存储键值对
   * @param key
   * @returns
   */
  async hasValue(context: Context, key: string): Promise<boolean> {
    this.initPreference(context, PREFERENCES_NAME);
    return this.preferences!.has(key);
  }

  /**
   * 删除名为给定Key的存储键值对
   * @param key
   * @returns
   */
  async deleteValue(context: Context, key: string): Promise<void> {
    this.initPreference(context, PREFERENCES_NAME);
    this.preferences!.delete(key).then(() => {
      this.saveUserData();
    });
  }

  /**
   * 保存用户数据到用户首选项持久化文件中
   */
  private saveUserData() {
    console.log(TAG,'saveUserData');
    this.preferences!.flush();
  }
}