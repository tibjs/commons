# sandbox

This directory can be used to add applications or modules that need to be tested
against the LoopBack 4 source code (as symbolically linked dependencies). Sub
directories with `package.json` will be picked up by `lerna` as a package of the
`commons` monorepo.

## Usage

To add a new package for sandbox testing:

```sh
git clone git@github.com:artlab/commons.git
cd commons/sandbox
```

Now you can scaffold your Node.js modules or copy existing projects into the
`sandbox` directory, for example, `sandbox/example`.

To link the `@artlab/*` dependencies for your project, run the following
commands:

```sh
cd commons
npm install
npm run build
cd sandbox/example
node .
```

Your project is now ready against the LoopBack 4 source code.
