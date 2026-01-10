import { User } from "utils";

@ObservedV2
export class CoinInfo {
  @Trace coinCount: number = 0;
  @Trace level: number = 0;
  @Trace nickname: string = '';
  @Trace rank: string = '';
  @Trace userId: number = 0;
  @Trace username: string = ''
}

export interface UserInfo {
  coinInfo: CoinInfo;
  userInfo: User
}

export interface UserInfoResponse {
  data: UserInfo;
  errorCode: number;
  errorMsg: string;
}