export class DateUtils {
  static timestampToDateTime(timestamp: number): string {
    const date = new Date(timestamp); // 创建一个Date对象
    const year = date.getFullYear(); // 获取年、月、日、时、分、秒
    const month = String(date.getMonth() + 1).padStart(2, '0'); // 月份是从0开始的，所以要加1，并确保是两位数
    const day = String(date.getDate()).padStart(2, '0'); // 日期
    const hours = String(date.getHours()).padStart(2, '0'); // 小时
    const minutes = String(date.getMinutes()).padStart(2, '0'); // 分钟
    const seconds = String(date.getSeconds()).padStart(2, '0'); // 秒
    // 返回格式化的字符串
    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
  }
}