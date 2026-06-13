# MATLAB Code Flow

## Paper-to-Code Mapping

| Paper result | Experiment archive | Samples | Duration at 0.5 s |
|---|---|---:|---:|
| Fig. 5: linear/back-and-forth | `ZigzaganLinear_3` | 424 | 212 s |
| Fig. 6: zigzag | `Zigzagand_2` and the final `Zigzag2` figure archive | 169 | 84.5 s |
| Fig. 7: up/down | `UpDown_1 and Zigzag/UpDown` | 280 | 140 s |
| Fig. 8: error distributions | `pdf_lz.fig`, `PDF_zig.fig`, and `pdf_ud.fig` | - | - |

The sample counts, axes, legends, and 0.5 s interval were checked against the paper.

## Processing Sequence

1. `sensor_xyz_plotLauri.m` aligns drone sensor/GPS timestamps with VNA measurement windows, rotates the coordinate frame, applies the recorded offsets, and selects the trajectory period.
2. `N_Measurement.m` defines the 4-by-4 uniform rectangular array geometry.
3. For each sample, the 32 complex channels are separated into the two 16-element arrays.
4. The signal covariance is decomposed by SVD.
5. `MUSICBelay.m` searches the azimuth/elevation grid and selects the MUSIC peak for each array.
6. The two estimated directions form two 3D lines.
7. `lineXline.m` obtains their least-squares intersection, producing the triangulated position `X_1`.
8. `FinalMeasurement_EKF_P3.m` initializes and predicts the six-state EKF.
9. The triangulated 3D position is used in the first EKF update.
10. Where enabled, the barometer supplies a second update for the Z state.
11. The script produces position, spherical-coordinate, and error-distribution figures.

## Scientific Parameters Preserved

The original files retain all recorded values, including:

- Carrier frequency: `490.0e6` Hz
- Element spacing model: `L = 0.3059`
- Sampling interval: `0.5` s
- Array separation: entered as `13` m
- Array height: `2.1` m
- Original process-noise, measurement-noise, covariance, rotation, and offset values

No variable names, numeric constants, EKF equations, random variables, loops, or plotting commands in the original scripts were changed.

## Original Experimental State

The scripts are research-working files rather than a single parameterized application:

- `ZigzaganLinear_3/FinalMeasurement_EKF_P3.m` is configured for the linear/back-and-forth data and barometer update.
- `Zigzagand_2/FinalMeasurement_EKF_P3.m` expects the zigzag measurement variables to be available before `N_Measurement.m` executes.
- `UpDown_1 and Zigzag/FinalMeasurement_EKF_P3.m` contains commented switches for zigzag and up/down processing. Its active lines reflect the last selected zigzag branch, even though the folder also contains the final up/down workspaces and figures.

This state has deliberately not been normalized because changing those switches would alter the submitted source. The archived `.fig` files are the authoritative outputs used for the public result previews.
