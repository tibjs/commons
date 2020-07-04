// Copyright IBM Corp. 2018,2020. All Rights Reserved.
// Node module: @artlab/build
// This file is licensed under the MIT License.
// License text available at https://opensource.org/licenses/MIT

'use strict';

const util = require('util');

const originalConsole = {
  log: console.log,
  error: console.error,
  warn: console.warn,
};

console.log = recordForbiddenCall('log');
console.warn = recordForbiddenCall('warn');
console.error = recordForbiddenCall('error');

const problems = [];
const warnings = [];

function recordForbiddenCall(methodName) {
  return function recordForbiddenConsoleUsage(...args) {
    // Print the original message
    originalConsole[methodName](...args);

    // Find out who called us.
    // The first line is the error message,
    // the second line points to this very function.
    const stack = new Error().stack.split(/\n/).slice(2);

    // Mocha reporters are allowed to call console functions
    if (/[\/\\]node_modules[\/\\]mocha[\/\\]/.test(stack[0])) {
      return;
    }

    // Record the problem otherwise
    const msg = util.format(...args);
    problems.push({msg, stack});
  };
}

process.on('warning', warning => {
  warnings.push(warning);
});

process.on('exit', code => {
  // Don't complain about console logs when some of the tests have failed.
  // It's a common practice to add temporary console logs while troubleshooting.
  if (code) return;

  if (!warnings.length) {
    for (const w of warnings) {
      originalConsole.warn(w);
    }
  }
  if (!problems.length) return;
  const log = originalConsole.log;

  log(
    '\n=== ATTENTION - INVALID USAGE OF CONSOLE LOGS DETECTED ===',
    '\nLearn more at',
    'https://github.com/artlab/artlab-commons/blob/master/packages/build/README.md#a-note-on-console-logs-printed-by-tests\n',
  );

  for (const p of problems) {
    // print the first line of the console log
    log(p.msg.split(/\n/)[0]);
    // print the stack trace
    log(p.stack.join('\n'));
    // add an empty line as a delimiter
    log('\n');
  }

  // ensure the process returns non-zero exit code to indicate test failure
  process.exitCode = code || 10;
});
