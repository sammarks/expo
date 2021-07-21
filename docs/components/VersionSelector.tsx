import { css } from '@emotion/react';
import { theme } from '@expo/styleguide';
import * as React from 'react';

import * as Utilities from '~/common/utilities';
import { paragraph } from '~/components/base/typography';
import ChevronDownIcon from '~/components/icons/ChevronDown';
import * as Constants from '~/constants/theme';
import { VERSIONS, LATEST_VERSION, BETA_VERSION } from '~/constants/versions';

const STYLES_SELECT = css`
  position: relative;
  margin: 0;
  padding: 8px 16px;
  border-radius: 5px;
  margin-bottom: 15px;
  width: 100%;
  background-color: ${theme.background.default};
  border: 1px solid ${theme.border.default};
  box-shadow: 0 2px 2px 0 rgba(0, 0, 0, 0.015), 0 0 0 1px rgba(0, 0, 0, 0.0075);

  :hover {
    background-color: ${theme.background.secondary};
  }
`;

const STYLES_SELECT_TEXT = css`
  ${paragraph}
  display: flex;
  align-items: center;
  flex: 1;
  justify-content: space-between;
  font-family: ${Constants.fontFamilies.demi};
  color: ${theme.text.default};
  font-size: 14px;
`;

const STYLES_SELECT_ELEMENT = css`
  position: absolute;
  height: 100%;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  opacity: 0;
  width: 100%;
  border-radius: 0px;
  cursor: pointer;
`;

type Props = {
  version: string;
  onSetVersion: (value: string) => void;
  style?: React.CSSProperties;
};

const VersionSelector: React.FC<Props> = ({ version, style, onSetVersion }) => (
  <div css={STYLES_SELECT} style={style}>
    <label css={STYLES_SELECT_TEXT} htmlFor="version-menu">
      <div>{Utilities.getUserFacingVersionString(version, LATEST_VERSION, BETA_VERSION)}</div>
      <ChevronDownIcon style={{ height: '16px', width: '16px' }} />
    </label>
    {
      // hidden links to help test-links spidering
      VERSIONS.map(v => (
        <a key={v} style={{ display: 'none' }} href={`/versions/${v}/`} />
      ))
    }
    <select
      id="version-menu"
      css={STYLES_SELECT_ELEMENT}
      value={version}
      onChange={e => onSetVersion(e.target.value)}>
      {VERSIONS.map(v => (
        <option key={v} value={v}>
          {Utilities.getUserFacingVersionString(v, LATEST_VERSION, BETA_VERSION)}
        </option>
      ))}
    </select>
  </div>
);

export default VersionSelector;
