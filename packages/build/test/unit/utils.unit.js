// Copyright IBM Corp. 2019,2020. All Rights Reserved.
// Node module: @tib/build
// This file is licensed under the MIT License.
// License text available at https://opensource.org/licenses/MIT

'use strict';

const assert = require('assert');
const utils = require('../../bin/utils');

describe('Build utils', () => {
  describe('getPackageName()', () => {
    it('supports simple packages', () => {
      assert.equal(utils.getPackageName('typescript/bin/tsc'), 'typescript');
    });

    it('supports scoped packages', () => {
      assert.equal(utils.getPackageName('@tib/cli/bin/cli-main'), '@tib/cli');
    });
  });
});
