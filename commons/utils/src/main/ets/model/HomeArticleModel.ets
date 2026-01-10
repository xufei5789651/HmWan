export interface Tag {
  name: string;
  url: string;
}

export interface Article {
  adminAdd: boolean;
  apkLink: string;
  audit: number;
  author: string;
  canEdit: boolean;
  chapterId: number;
  chapterName: string;
  collect: boolean;
  courseId: number;
  desc: string;
  descMd: string;
  envelopePic: string;
  fresh: boolean;
  host: string;
  id: number;
  isAdminAdd: boolean;
  link: string;
  niceDate: string;
  niceShareDate: string;
  origin: string;
  prefix: string;
  projectLink: string;
  publishTime: number;
  realSuperChapterId: number;
  selfVisible: number;
  shareDate: number;
  shareUser: string;
  superChapterId: number;
  superChapterName: string;
  tags: Tag[];
  title: string;
  type: number;
  userId: number;
  visible: number;
  zan: number;
}

export interface ResponseData {
  curPage: number;
  datas: Article[];
  offset: number;
  over: boolean;
  pageCount: number;
  size: number;
  total: number;
}

export interface HomeArticleResponse {
  data: ResponseData;
  errorCode: number;
  errorMsg: string;
}

export const bannerItem: Article = {
  adminAdd: false,
  apkLink: '',
  audit: 0,
  author: '',
  canEdit: false,
  chapterId: 0,
  chapterName: '',
  collect: false,
  courseId: 0,
  desc: '',
  descMd: '',
  envelopePic: '',
  fresh: false,
  host: '',
  id: -1,
  isAdminAdd: false,
  link: '',
  niceDate: '',
  niceShareDate: '',
  origin: '',
  prefix: '',
  projectLink: '',
  publishTime: 0,
  realSuperChapterId: 0,
  selfVisible: 0,
  shareDate: 0,
  shareUser: '',
  superChapterId: 0,
  superChapterName: '',
  tags: [],
  title: '',
  type: -1,
  userId: 0,
  visible: 0,
  zan: 0
};