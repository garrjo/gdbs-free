# GDBS Free

WebAssembly physics computation engine — compiled from Rust, runs in any browser or Node.js environment. No server, no GPU, no build step required.

**Patent Pending — 63/970,430**

---

## What's included

40+ physics simulation functions across 8 domains, compiled to a single ~750 KB `.wasm` binary:

| Domain | Functions |
|--------|-----------|
| Materials | Elastic constants (VRH), band gaps, phase diagrams, thermal properties, defect formation |
| Plasma | Circular / shaped tokamak, negative triangularity, stellarator, FRC, eigenmode, stability |
| Fluids | Compressible flow, pipe flow, heat transfer, heat flow, drag |
| Molecular Dynamics | Geometric MD, nanoparticle interaction, molecular binding |
| Quantum | Circuits, entanglement, decoherence, error correction, fidelity, state binding |
| Geophysics | Seismic wave propagation, earthquake parameters, boundary conditions, stress analysis |
| Cosmology | Black hole thermodynamics, CMB spectrum, gravitational constants, orbital mechanics |
| Medical | QSAR molecular property prediction |

---

## Quick start

### Browser (ES module)

```html
<script type="module">
  import init, { run_elastic_scan } from './gdbs_web_client.js';

  await init();

  const result = JSON.parse(run_elastic_scan(JSON.stringify({
    materials: ['Diamond', 'Silicon', 'Aluminium'],
    precision: 0
  })));

  console.log(result);
  // [{ name: 'Diamond', bulk_modulus: 442.7, shear_modulus: 535.3, ... }, ...]
</script>
```

### Node.js (≥18)

```js
import { readFile } from 'fs/promises';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

// Load the wasm-bindgen glue
const { default: init, run_elastic_scan, run_circular_scan } =
  await import('./gdbs_web_client.js');

// Point init() at the .wasm file
const wasmPath = join(dirname(fileURLToPath(import.meta.url)), 'gdbs_web_client_bg.wasm');
await init({ module_or_path: await readFile(wasmPath) });

// Run a materials scan
const elastic = JSON.parse(run_elastic_scan(JSON.stringify({
  materials: ['Diamond', 'Silicon', 'Iron', 'Titanium'],
  precision: 0
})));
console.table(elastic.map(r => ({
  name: r.name,
  B_GPa: r.bulk_modulus,
  G_GPa: r.shear_modulus,
  E_GPa: r.youngs_modulus,
  poisson: r.poisson_ratio
})));
```

---

## Examples

### Diamond bulk modulus

```js
const result = JSON.parse(run_elastic_scan(JSON.stringify({
  materials: ['Diamond'],
  precision: 0
})));
// result[0].bulk_modulus → 442.7 GPa   (literature: 442 GPa, error < 0.2%)
```

### Tokamak plasma parameters

```js
const result = JSON.parse(run_circular_scan(JSON.stringify({
  configs: [{
    major_radius: 6.2,      // ITER — metres
    minor_radius: 2.0,
    magnetic_field: 5.3,    // Tesla
    plasma_current: 15.0,   // MA
    elongation: 1.7,
    triangularity: 0.33
  }],
  precision: 0
})));
// result[0].beta, safety_factor, energy_confinement_time, ...
```

### Black hole thermodynamics

```js
const result = JSON.parse(run_blackhole_scan(JSON.stringify({
  black_holes: [{
    mass_solar: 1.0,          // solar masses
    spin_parameter: 0.0,      // Schwarzschild (a=0)
    charge_parameter: 0.0
  }],
  precision: 0
})));
// result[0].hawking_temperature_k → 6.17e-8 K   (literature: 6.17e-8 K)
```

### Molecular dynamics — surface erosion

```js
const result = JSON.parse(run_geometric_md(JSON.stringify({
  n_atoms: 500,
  n_steps: 1000,
  temperature: 300,
  timestep: 0.001,
  lattice_constant: 3.52,   // Ni-like FCC, Angstroms
  precision: 0
})));
// result.msd_final, manifold_curvature, surface_coherence, ...
```

### Seismic wave propagation

```js
const result = JSON.parse(run_seismic_scan(JSON.stringify({
  configs: [{
    vp: 6.0,       // P-wave velocity km/s
    vs: 3.5,       // S-wave velocity km/s
    density: 2700, // kg/m³
    depth: 10.0    // km
  }],
  precision: 0
})));
```

---

## All functions

Every function takes a JSON string and returns a JSON string. All accept a `precision` field (integer 0–3) trading speed for accuracy.

**Defaults** — call these first to see accepted parameter shapes:
```
get_materials_defaults()  get_fluid_defaults()  get_cosmic_defaults()
get_geo_defaults()        get_md_defaults()      get_quantum_defaults()
get_molecular_defaults()  get_defaults()
```

**Computation functions:**
```
Materials:   run_elastic_scan      run_bandgap_scan      run_phase_scan
             run_thermal_scan      run_defect_scan

Plasma:      run_circular_scan     run_shaped_scan       run_neg_tri_scan
             run_stellarator_scan  run_frc_scan          run_eigenmode
             run_optimizer         run_simulation        run_stability_sim

Fluids:      run_compressible_scan run_pipeflow_scan     run_heatflow_scan
             run_heattransfer_scan run_drag_scan

Molecular:   run_geometric_md      run_interaction_scan  run_nanoparticle_scan
             run_binding_scan

Quantum:     run_circuit_scan      run_entanglement_scan run_decoherence_scan
             run_errorcorrection_scan run_fidelity_scan

Geophysics:  run_seismic_scan      run_earthquake_scan   run_boundary_scan
             run_stress_scan       run_gravity_scan

Cosmology:   run_blackhole_scan    run_cmb_scan          run_constants_scan
             run_ratios_scan       run_rotation_scan

Medical:     run_qsar_scan
```

---

## Precision parameter

```
precision: 0   →  standard IEEE 754 speed  (fastest)
precision: 1   →  256-shade GeoNum tier
precision: 2   →  512-shade GeoNum tier
precision: 3   →  1024-shade GeoNum tier   (highest accuracy)
```

Results at precision ≥ 1 include additional fields: `tiered_coherence`, uncertainty metrics.

---

## Build from source

The Rust source is not included in this distribution. The WASM binary was built with:

```
wasm-pack build --target web --release
```

Requires [wasm-pack](https://rustwasm.github.io/wasm-pack/) and the `wasm32-unknown-unknown` Rust target.

---

## Attribution

If you use GDBS Free in published work, a citation is appreciated:

> GDBS Free (2025). WebAssembly Physics Engine. VaultSync Solutions Inc.
> https://gdbs.getvaultsync.com

---

Apache License 2.0 — see [LICENSE](LICENSE).
