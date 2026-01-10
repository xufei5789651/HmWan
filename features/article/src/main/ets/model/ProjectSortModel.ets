export interface ProjectSortModel {
  author: string,
  courseId: number,
  cover: string,
  desc: string,
  id: number,
  lisense: string,
  lisenseLink: string,
  name: string,
  order: number,
  parentChapterId: number,
  type: number,
  userControlSetTop: boolean,
  visible: number
}

export interface ProjectSortResponse {
  data: ProjectSortModel[];
  errorCode: number;
  errorMsg: string;
}
