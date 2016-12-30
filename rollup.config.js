import babel from 'rollup-plugin-babel';
import babelrc from 'babelrc-rollup';
import nodeResolve from 'rollup-plugin-node-resolve';
import commonjs from 'rollup-plugin-commonjs';
import string from 'rollup-plugin-string';

let pkg = require('./package.json');

export default {
  entry: 'lib/index.js',
  plugins: [
    string({
      include: '**/*.glsl'
    }),
    nodeResolve({
      main: true,
      jsnext: true,
      preferBuiltins: false
    }),
    commonjs(),
    babel(babelrc())
  ],
  targets: [
    {
      dest: pkg['main'],
      format: 'umd',
      moduleName: 'Backgrund',
      sourceMap: true
    }
  ]
};
