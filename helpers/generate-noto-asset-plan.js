#!/usr/bin/env node
'use strict';

const data = require('../data/openmoji.json');

const outputRoot = (process.argv[2] || 'build/noto-android/png').replace(/\\/g, '/');
const sourceRoot = (process.argv[3] || 'color/svg').replace(/\\/g, '/');

const toNotoFilename = (hexcode) =>
  `emoji_u${hexcode.toLowerCase().replace(/-/g, '_')}.png`;

for (const {hexcode} of data) {
  process.stdout.write(
    `${outputRoot}/${toNotoFilename(hexcode)}\t${sourceRoot}/${hexcode}.svg\n`,
  );
}
