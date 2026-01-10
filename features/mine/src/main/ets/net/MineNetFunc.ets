import { AxiosManager, EmptyParams, NetError } from "network";
import { APIConstants } from "../api/APIConstants";
import { CollectArticleResponse } from "../model/CollectArticleResponse";
import { LoginOutResponse } from "../model/LogoutModel";
import { ShareArticleResponse } from "../model/ShareArticleResponse";
import { UnBadgeNumResponse } from "../model/UnBadgeNumResponse";
import { UserInfoResponse } from "../model/UserInfoResponse";
import { UserIntegralResponse } from "../model/UserIntegralResponse";
import { MessageInfoResponse } from "../model/UserMessageResponse";


export class MineNetFunc {
  static logOut(): Promise<LoginOutResponse> {
    let params = new EmptyParams();
    return new Promise((resolve: (value: LoginOutResponse | PromiseLike<LoginOutResponse>) => void,
      reject: (reason?: NetError) => void) => {
      AxiosManager.getInstance().requestFromGet(APIConstants.LOGIN_OUT_URL, params).then((response: string) => {
        let result: LoginOutResponse = JSON.parse(response);
        resolve(result);
      }).catch((err: NetError) => {
        reject(err);
      })
    });
  }

  static getUserInfo(cookie: string): Promise<UserInfoResponse> {
    let params = new EmptyParams();
    return new Promise((resolve: (value: UserInfoResponse | PromiseLike<UserInfoResponse>) => void,
      reject: (reason?: NetError) => void) => {
      AxiosManager.getInstance().requestFromGet(APIConstants.USER_INFO_URL, params, cookie).then((response: string) => {
        let result: UserInfoResponse = JSON.parse(response);
        resolve(result);
      }).catch((err: NetError) => {
        reject(err);
      })
    });
  }

  static unBadgeNum(cookie: string): Promise<UnBadgeNumResponse> {
    let params = new EmptyParams();
    return new Promise((resolve: (value: UnBadgeNumResponse | PromiseLike<UnBadgeNumResponse>) => void,
      reject: (reason?: NetError) => void) => {
      AxiosManager.getInstance()
        .requestFromGet(APIConstants.USER_UNREAD_URL, params, cookie)
        .then((response: string) => {
          let result: UnBadgeNumResponse = JSON.parse(response);
          resolve(result);
        })
        .catch((err: NetError) => {
          reject(err);
        })
    });
  }

  static getUserIntegral(cookie: string, pageNum: number): Promise<UserIntegralResponse> {
    let params = new EmptyParams();
    return new Promise((resolve: (value: UserIntegralResponse | PromiseLike<UserIntegralResponse>) => void,
      reject: (reason?: NetError) => void) => {
      AxiosManager.getInstance()
        .requestFromGet(APIConstants.USER_INTEGRAL_URL + pageNum + APIConstants.INTEGRAL_LIST_SUFFIX, params, cookie)
        .then((response: string) => {
          let result: UserIntegralResponse = JSON.parse(response);
          resolve(result);
        })
        .catch((err: NetError) => {
          reject(err);
        })
    });
  }

  static getUserMessageRead(cookie: string, pageNum: number): Promise<MessageInfoResponse> {
    let params = new EmptyParams();
    return new Promise((resolve: (value: MessageInfoResponse | PromiseLike<MessageInfoResponse>) => void,
      reject: (reason?: NetError) => void) => {
      AxiosManager.getInstance()
        .requestFromGet(APIConstants.USER_READ_MESSAGE_URL + pageNum + APIConstants.INTEGRAL_LIST_SUFFIX, params,
          cookie)
        .then((response: string) => {
          let result: MessageInfoResponse = JSON.parse(response);
          resolve(result);
        })
        .catch((err: NetError) => {
          reject(err);
        })
    });
  }

  static getUserMessageUNRead(cookie: string, pageNum: number): Promise<MessageInfoResponse> {
    let params = new EmptyParams();
    return new Promise((resolve: (value: MessageInfoResponse | PromiseLike<MessageInfoResponse>) => void,
      reject: (reason?: NetError) => void) => {
      AxiosManager.getInstance()
        .requestFromGet(APIConstants.USER_UNREAD_MESSAGE_URL + pageNum + APIConstants.INTEGRAL_LIST_SUFFIX, params,
          cookie)
        .then((response: string) => {
          let result: MessageInfoResponse = JSON.parse(response);
          resolve(result);
        })
        .catch((err: NetError) => {
          reject(err);
        })
    });
  }

  static getCollectList(cookie: string, pageNum: number): Promise<CollectArticleResponse> {
    let params = new EmptyParams();
    return new Promise((resolve: (value: CollectArticleResponse | PromiseLike<CollectArticleResponse>) => void,
      reject: (reason?: NetError) => void) => {
      AxiosManager.getInstance()
        .requestFromGet(APIConstants.USER_COLLECT_URL + pageNum + APIConstants.INTEGRAL_LIST_SUFFIX, params,
          cookie)
        .then((response: string) => {
          let result: CollectArticleResponse = JSON.parse(response);
          resolve(result);
        })
        .catch((err: NetError) => {
          reject(err);
        })
    });
  }

  static getShareList(cookie: string, pageNum: number): Promise<ShareArticleResponse> {
    let params = new EmptyParams();
    return new Promise((resolve: (value: ShareArticleResponse | PromiseLike<ShareArticleResponse>) => void,
      reject: (reason?: NetError) => void) => {
      AxiosManager.getInstance()
        .requestFromGet(APIConstants.USER_SHARE_URL + pageNum + APIConstants.INTEGRAL_LIST_SUFFIX, params,
          cookie)
        .then((response: string) => {
          console.log('getShareList==>response:'+response);
          let result: ShareArticleResponse = JSON.parse(response);
          resolve(result);
        })
        .catch((err: NetError) => {
          reject(err);
        })
    });
  }
}