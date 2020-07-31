# sandbox

This directory can be used to add applications or modules that need to be tested
against the Tib 4 source code (as symbolically linked dependencies). Sub
directories with `package.json` will be picked up by `lerna` as a package of the
`framework` monorepo.

## Usage

To add a new package for sandbox testing:

```sh
git clone git@github.com:tib/framework.git
cd framework/sandbox
```

Now you can scaffold your Node.js modules or copy existing projects into the
`sandbox` directory, for example, `sandbox/example`.

To link the `@tib/*` dependencies for your project, run the following
commands:

```sh
cd framework
npm install
npm run build
cd sandbox/example
node .
```

Your project is now ready against the Tib 4 source code.
