import { AxiosManager, EmptyParams, NetError } from "network";
import { APIConstants } from "../api/APIConstants";
import { BannerResponse } from "../model/BannerModel";
import { HomeArticleResponse } from "utils/src/main/ets/model/HomeArticleModel";

const TAG = 'HomeNetFunc';

export class HomeNetFunc {
  static getBannerList(): Promise<BannerResponse> {
    let params = new EmptyParams();
    return new Promise((resolve: (value: BannerResponse | PromiseLike<BannerResponse>) => void,
      reject: (reason?: NetError) => void) => {
      AxiosManager.getInstance().requestFromGet(APIConstants.BANNER_URL, params).then((response: string) => {
        let banner: BannerResponse = JSON.parse(response);
        resolve(banner);
      }).catch((err: NetError) => {
        reject(err);
      })
    });
  }

  static getHomeArticleList(pageNumber: number = 0): Promise<HomeArticleResponse> {
    let params = new EmptyParams();
    return new Promise((resolve: (value: HomeArticleResponse | PromiseLike<HomeArticleResponse>) => void,
      reject: (reason?: NetError) => void) => {
      AxiosManager.getInstance()
        .requestFromGet(APIConstants.ARTICLE_LIST_URL + pageNumber + APIConstants.ARTICLE_LIST_SUFFIX, params)
        .then((response: string) => {
          let articleResponse: HomeArticleResponse = JSON.parse(response);
          resolve(articleResponse);
        })
        .catch((err: NetError) => {
          reject(err);
        })
    });
  }
}