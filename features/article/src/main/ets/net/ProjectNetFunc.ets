import { AxiosManager, EmptyParams, NetError } from "network";
import { RequestParams } from "network/src/main/ets/param/RequestParams";
import { HomeArticleResponse } from "utils";
import { APIConstants } from "../api/APIConstants";
import { ProjectSortResponse } from "../model/ProjectSortModel";

export class ProjectNetFunc {
  static getProjectSortList(): Promise<ProjectSortResponse> {
    let params = new EmptyParams();
    return new Promise((resolve: (value: ProjectSortResponse | PromiseLike<ProjectSortResponse>) => void,
      reject: (reason?: NetError) => void) => {
      AxiosManager.getInstance().requestFromGet(APIConstants.PROJECT_URL, params).then((response: string) => {
        let projectSort: ProjectSortResponse = JSON.parse(response);
        resolve(projectSort);
      }).catch((err: NetError) => {
        reject(err);
      })
    });
  }

  static getProjectArticleList(id: number, pageNumber: number = 1): Promise<HomeArticleResponse> {
    let params = new RequestParams();
    params.cid = id;
    return new Promise((resolve: (value: HomeArticleResponse | PromiseLike<HomeArticleResponse>) => void,
      reject: (reason?: NetError) => void) => {
      AxiosManager.getInstance()
        .requestFromGet(APIConstants.PROJECT_LIST_URL + pageNumber + APIConstants.PROJECT_LIST_SUFFIX, params)
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