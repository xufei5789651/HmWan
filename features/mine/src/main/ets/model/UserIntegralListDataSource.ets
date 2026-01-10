import { IntegralDataSource } from "./IntegralDataSource";
import { IntegralInfo } from "./UserIntegralResponse";

export class UserIntegralListDataSource extends IntegralDataSource{
  private dataArray: IntegralInfo[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): Object {
    return this.dataArray[index];
  }

  public addData(index: number, data: IntegralInfo): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: IntegralInfo): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public clear(): void {
    this.dataArray = [];
  }
}