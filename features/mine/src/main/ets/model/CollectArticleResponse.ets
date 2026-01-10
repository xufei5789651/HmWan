export interface ArticleInfo {
  author: string,
  chapterId: number,
  chapterName: string,
  courseId: number,
  desc: string,
  envelopePic: string,
  id: number,
  link: string,
  niceDate: string,
  origin: string,
  originId: number,
  publishTime: number,
  title: string,
  userId: number,
  visible: number,
  zan: number,
}

export interface ArticleInfoData {
  curPage: number;
  datas: ArticleInfo[];
  offset: number;
  over: boolean;
  pageCount: number;
  size: number;
  total: number;
}

export interface CollectArticleResponse {
  data: ArticleInfoData;
  errorCode: number;
  errorMsg: string;
}