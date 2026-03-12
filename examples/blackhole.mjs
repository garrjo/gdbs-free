// GDBS Free — Black hole thermodynamics example
// Run: node examples/blackhole.mjs

import { readFile } from 'fs/promises';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const dir = dirname(fileURLToPath(import.meta.url));
const { default: init, run_blackhole_scan } = await import(join(dir, '../gdbs_web_client.js'));
await init({ module_or_path: await readFile(join(dir, '../gdbs_web_client_bg.wasm')) });

const result = JSON.parse(run_blackhole_scan(JSON.stringify({
  black_holes: [
    { mass_solar: 1.0,   spin_parameter: 0.0, charge_parameter: 0.0 }, // Schwarzschild
    { mass_solar: 10.0,  spin_parameter: 0.9, charge_parameter: 0.0 }, // Kerr stellar BH
    { mass_solar: 4.1e6, spin_parameter: 0.9, charge_parameter: 0.0 }, // Sgr A*
  ],
  precision: 0
})));

console.log('\nBlack Hole Thermodynamics\n');
result.forEach((r, i) => {
  console.log(`[${i + 1}] M = ${r.mass_solar ?? '?'} M☉`);
  console.log(JSON.stringify(r, null, 2));
  console.log();
});
