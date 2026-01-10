import axios, { AxiosError, AxiosInstance, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios';
import { JSON } from '@kit.ArkTS';
import { NetError } from '../param/NetError';
import { PreferenceManager } from 'utils';

const TAG: string = 'AxiosManager';
const BASEURL: string = 'https://www.wanandroid.com/';

/**
 *  Axios 管理类
 */
export class AxiosManager {
  private static instance: AxiosManager | null = null;
  private axiosInstance: AxiosInstance | null = null;
  private manager: PreferenceManager = PreferenceManager.getInstance();

  private constructor() {
    this.createAxiosConfig();
  }

  static getInstance(): AxiosManager {
    if (AxiosManager.instance === null) {
      AxiosManager.instance = new AxiosManager();
    }
    return AxiosManager.instance;
  }

  private createAxiosConfig() {
    this.axiosInstance = axios.create({
      baseURL: BASEURL,
      headers: { 'Content-Type': 'application/json' },
      readTimeout: 0,
      connectTimeout: 60000,
      maxBodyLength: 5 * 1024 * 1024,
      maxContentLength: 100 * 1024 * 1024,
      responseType: 'string'
    })

    // 添加请求拦截器
    this.axiosInstance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
      console.log(TAG, `url:${config.baseURL}${config.url};\n header:${config.headers};
      method:${config.method}; params:${config.method === 'get' ? config.params : config.data}`);
      return config;
    }, (error: AxiosError) => {
      console.error(TAG, `request error code:${error.code},msg:${error.message}`)
      return Promise.reject(error);
    });

    // 添加响应拦截器
    this.axiosInstance.interceptors.response.use((response: AxiosResponse) => {
      if (response.config.url === 'user/login') {
        let cookieStr = JSON.stringify(response.headers['set-cookie'] as string[]);
        this.manager.setValue('cookie', cookieStr);
        console.warn(TAG, `cookie:${cookieStr}`);
      }
      console.log(TAG, `response:::${JSON.stringify(response)}`);
      return response;
    }, (error: AxiosError) => {
      console.error(TAG, `response error code:${error.code},msg:${error.message}`)
      return Promise.reject(error);
    });
  }

  private getApiRequest(): AxiosInstance {
    return this.axiosInstance!;
  }

  requestFromGet<T>(url: string, param: T, cookieValue: string = ''): Promise<string> {
    return new Promise((resolve: (value: string | PromiseLike<string>) => void,
      reject: (reason?: Object) => void) => {
      this.getApiRequest()
        .get<string, AxiosResponse<string>, null>(url, { params: param, headers: { 'Cookie': cookieValue } })
        .then((response: AxiosResponse<string>) => {
          resolve(response.data);
        })
        .catch((error: AxiosError) => {
          let netError = error as NetError;
          reject(netError);
        })
    });
  }

  requestFromPost<T>(url: string, param: T): Promise<string> {
    return new Promise((resolve: (value: string | PromiseLike<string>) => void,
      reject: (reason?: Object) => void) => {
      this.getApiRequest()
        .postForm<string, AxiosResponse<string>, T>(url, param)
        .then((response: AxiosResponse<string>) => {
          resolve(response.data);
        })
        .catch((error: AxiosError) => {
          let netError = error as NetError;
          reject(netError);
        })
    });
  }
}