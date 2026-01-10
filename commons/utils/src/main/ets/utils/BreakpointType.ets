export class BreakpointType<T> {
  sm: T;
  md: T;
  lg: T;

  constructor(sm: T, md: T, lg: T) {
    this.sm = sm;
    this.md = md;
    this.lg = lg;
  }

  getValue(currentBreakpoint: string): T {
    if (currentBreakpoint === 'md') {
      return this.md;
    } else if (currentBreakpoint === 'lg') {
      return this.lg;
    } else {
      return this.sm;
    }
  }
}