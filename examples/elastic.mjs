// GDBS Free — Materials elastic scan example
// Run: node examples/elastic.mjs

import { readFile } from 'fs/promises';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const dir = dirname(fileURLToPath(import.meta.url));
const { default: init, run_elastic_scan } = await import(join(dir, '../gdbs_web_client.js'));
await init({ module_or_path: await readFile(join(dir, '../gdbs_web_client_bg.wasm')) });

const result = JSON.parse(run_elastic_scan(JSON.stringify({
  materials: ['Diamond', 'Silicon', 'Iron', 'Titanium', 'Aluminium', 'Copper'],
  precision: 0
})));

console.log('\nElastic Properties — Voigt-Reuss-Hill\n');
console.table(result.map(r => ({
  Material:   r.name,
  'B (GPa)':  r.bulk_modulus?.toFixed(1),
  'G (GPa)':  r.shear_modulus?.toFixed(1),
  'E (GPa)':  r.youngs_modulus?.toFixed(1),
  'Poisson':  r.poisson_ratio?.toFixed(3),
  'Debye (K)': r.debye_temp?.toFixed(0)
})));
