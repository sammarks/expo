import { css } from '@emotion/react';

import * as Constants from '~/constants/theme';

export const globalFonts = css`
  @font-face {
    font-family: ${Constants.fonts.bold};
    font-style: normal;
    font-weight: 600;
    src: url('/static/fonts/Inter-SemiBold.woff2?v=3.15') format('woff2'),
      url('/static/fonts/Inter-SemiBold.woff?v=3.15') format('woff');
  }

  @font-face {
    font-family: ${Constants.fonts.book};
    font-style: normal;
    font-weight: 400;
    src: url('/static/fonts/Inter-Regular.woff2?v=3.15') format('woff2'),
      url('/static/fonts/Inter-Regular.woff?v=3.15') format('woff');
  }

  @font-face {
    font-family: ${Constants.fonts.demi};
    font-style: normal;
    font-weight: 500;
    src: url('/static/fonts/Inter-Medium.woff2?v=3.15') format('woff2'),
      url('/static/fonts/Inter-Medium.woff?v=3.15') format('woff');
  }

  @font-face {
    font-family: ${Constants.fonts.mono};
    src: url('/static/fonts/Menlo-Regular.woff2'),
      url('/static/fonts/Menlo-Regular.woff') format('woff');
  }
`;
