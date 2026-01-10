export class APIConstants {
  // 退出 api
  static readonly LOGIN_OUT_URL: string = 'user/logout/json';
  // 个人信息接口 api
  static readonly USER_INFO_URL: string = 'user/lg/userinfo/json';
  // 未读消息数量 api
  static readonly USER_UNREAD_URL: string = 'message/lg/count_unread/json';
  // 获取个人积分列表
  static readonly USER_INTEGRAL_URL: string = 'lg/coin/list/';
  // 已读消息列表
  static readonly USER_READ_MESSAGE_URL: string = 'message/lg/readed_list/';
  // 未读消息列表
  static readonly USER_UNREAD_MESSAGE_URL: string = 'message/lg/unread_list/';
  // 收藏文章列表
  static readonly USER_COLLECT_URL: string = 'lg/collect/list/';
  // 自己的分享的文章列表
  static readonly USER_SHARE_URL: string = 'user/lg/private_articles/';
  // 后缀
  static readonly INTEGRAL_LIST_SUFFIX: string = '/json';
}