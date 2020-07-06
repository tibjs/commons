const {mergeMochaConfigs} = require('./packages/build');
const defaultConfig = require('./packages/build/config/.mocharc.json');

const MONOREPO_CONFIG = {
  parallel: true,
};

module.exports = mergeMochaConfigs(defaultConfig, MONOREPO_CONFIG);
