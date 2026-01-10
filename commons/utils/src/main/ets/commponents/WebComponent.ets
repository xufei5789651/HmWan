import { UtilConstants } from '../common/UtilConstants';
import { getNWeb } from '../web/WebUtils';

@ComponentV2
export struct WebComponent {
  @Param @Require url: string;

  build() {
    Column() {
      NodeContainer(getNWeb(this.url))
        .height(UtilConstants.CONST_HEIGHT_UI)
        .width(UtilConstants.CONST_WIDTH_UI)
    }
    .width(UtilConstants.CONST_WIDTH_UI)
  }
}