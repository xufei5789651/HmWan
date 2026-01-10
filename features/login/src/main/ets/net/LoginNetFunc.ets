import { AxiosManager, NetError } from "network";
import { LoginResponse } from "utils";
import { APIConstants } from "../api/APIConstants";
import { LoginRegisterParam } from "./LoginRegisterParam";

export class LoginNetFunc {
  static login(params: LoginRegisterParam): Promise<LoginResponse> {
    return new Promise((resolve: (value: LoginResponse | PromiseLike<LoginResponse>) => void,
      reject: (reason?: NetError) => void) => {
      AxiosManager.getInstance().requestFromPost(APIConstants.LOGIN_URL, params).then((response: string) => {
        let loginResult: LoginResponse = JSON.parse(response);
        resolve(loginResult);
      }).catch((err: NetError) => {
        reject(err);
      })
    });
  }

  static register(params: LoginRegisterParam): Promise<LoginResponse> {
    return new Promise((resolve: (value: LoginResponse | PromiseLike<LoginResponse>) => void,
      reject: (reason?: NetError) => void) => {
      AxiosManager.getInstance().requestFromPost(APIConstants.REGISTER_URL, params).then((response: string) => {
        let loginResult: LoginResponse = JSON.parse(response);
        resolve(loginResult);
      }).catch((err: NetError) => {
        reject(err);
      })
    });
  }
}