export interface MessageInfo{
  category:number;
  date:number;
  fromUser:string;
  fromUserId:number;
  fullLink:string;
  id:number;
  isRead:number;
  link:string;
  message:string;
  niceDate:string;
  tag:string;
  title:string;
  userId:number
}

export interface MessageInfoData {
  curPage: number;
  datas: MessageInfo[];
  offset: number;
  over: boolean;
  pageCount: number;
  size: number;
  total: number;
}

export interface MessageInfoResponse{
  data:MessageInfoData;
  errorCode:number;
  errorMsg:string;
}