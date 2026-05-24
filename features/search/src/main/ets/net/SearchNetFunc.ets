import { AxiosManager, NetError } from "network";
import { HomeArticleResponse } from "utils";
import { APIConstants } from "../api/APIConstants";
import { SearchParam } from "../model/SearchParam";

export class SearchNetFunc {
  static search(params: SearchParam): Promise<HomeArticleResponse> {
    return new Promise((resolve: (value: HomeArticleResponse | PromiseLike<HomeArticleResponse>) => void,
      reject: (reason?: NetError) => void) => {
      AxiosManager.getInstance()
        .requestFromPost(APIConstants.SEARCH_URL + params.pageNum + APIConstants.INTEGRAL_LIST_SUFFIX, params)
        .then((response: string) => {
          let searchResult: HomeArticleResponse = JSON.parse(response);
          resolve(searchResult);
        })
        .catch((err: NetError) => {
          reject(err);
        })
    });
  }
}