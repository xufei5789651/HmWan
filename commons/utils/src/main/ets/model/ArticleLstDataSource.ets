import { ArticleDataSource } from "./ArticleDataSource";
import { Article } from "./HomeArticleModel";

export class ArticleListDataSource extends ArticleDataSource {
  private dataArray: Article[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getDataList():Article[]{
    return this.dataArray;
  }

  public getData(index: number): Object {
    return this.dataArray[index];
  }

  public addData(index: number, data: Article): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: Article): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public clear(): void {
    this.dataArray = [];
  }
}