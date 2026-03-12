// GDBS Free — Plasma circular tokamak example
// Run: node examples/plasma.mjs

import { readFile } from 'fs/promises';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const dir = dirname(fileURLToPath(import.meta.url));
const { default: init, run_circular_scan } = await import(join(dir, '../gdbs_web_client.js'));
await init({ module_or_path: await readFile(join(dir, '../gdbs_web_client_bg.wasm')) });

const result = JSON.parse(run_circular_scan(JSON.stringify({
  configs: [
    { major_radius: 6.2, minor_radius: 2.0, magnetic_field: 5.3, plasma_current: 15.0, elongation: 1.7, triangularity: 0.33 }, // ITER
    { major_radius: 2.96, minor_radius: 0.89, magnetic_field: 4.0, plasma_current: 4.5, elongation: 1.6, triangularity: 0.24 }, // JET
  ],
  precision: 0
})));

console.log('\nCircular Tokamak Parameters\n');
result.forEach((r, i) => {
  console.log(`Config ${i + 1}:`);
  console.log(JSON.stringify(r, null, 2));
  console.log();
});
