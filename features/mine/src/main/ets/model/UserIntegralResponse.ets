export interface IntegralInfo {
  coinCount: number;
  date: number;
  desc: string;
  id: number;
  reason: string;
  type: number;
  userId: number;
  userName: string;
}

export interface IntegralInfoData {
  curPage: number;
  datas: IntegralInfo[];
  offset: number;
  over: boolean;
  pageCount: number;
  size: number;
  total: number;
}

export interface UserIntegralResponse{
  data:IntegralInfoData;
  errorCode:number;
  errorMsg:string;
}
