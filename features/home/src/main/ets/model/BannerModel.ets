export interface BannerItem {
  desc: string;
  id: number;
  imagePath: string;
  isVisible: number;
  order: number;
  title: string;
  type: number;
  url: string;
}

export interface BannerResponse {
  data: BannerItem[];
  errorCode: number;
  errorMsg: string;
}