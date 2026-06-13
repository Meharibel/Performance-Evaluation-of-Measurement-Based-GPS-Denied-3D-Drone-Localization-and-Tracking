# Preservation and Validation

## What Was Preserved

- All selected MATLAB `.m` source files were copied without modification.
- MAT measurement/workspace files were copied without numerical conversion.
- Original MATLAB `.fig`, EPS, and existing PNG result files were retained.
- Public PNG previews were exported directly from the original FIG files using MATLAB `exportgraphics`.
- No AI-generated or manually reconstructed scientific plot is included.

## Exclusions

- MATLAB editor backup files (`.asv`)
- A stray temporary file (`.tmp`)
- The IEEE Xplore publisher PDF supplied for cross-checking

The supplied PDF contains an IEEE licensed-use notice. The repository therefore links to the DOI and Aalto University's official accepted-author-manuscript record rather than republishing the restricted publisher copy.

## Shared Dependencies

Some scripts reference files that were stored outside the three selected experiment folders:

- `Test_Baro_28.mat` and `sensor_xyz_plotLauri.m` were copied from the parent `Third P` project.
- `lineXline.m` is the identical copy used in both the zigzag and combined experiment folders.
- `MUSICBelay.m` was not present under `Third P` at publication time in the available archive. The included copy was recovered from a later drone-localization project and has the function signature and 490 MHz/0.3059 array model expected by `N_Measurement.m`. It is documented as a recovered compatible dependency, not asserted to be the missing historical file.

## Static Analysis

MATLAB Code Analyzer reports performance/style advisories such as loop-array growth, unused intermediate variables, and unnecessary brackets. No syntax failure was reported for the main and measurement scripts.

Those advisories were not automatically corrected because preallocation, loop consolidation, or variable cleanup could change execution order or make the public source differ from the code used during the research.

## Figure Cross-Check

The archived figures match the paper's trajectory durations:

- Linear: X axis `0-212 s`
- Zigzag: X axis `0-84.5 s`
- Up/down: X axis `0-140 s`

The paper-specific zigzag Z figure is the four-trace version containing GPS, triangulation, barometer reading, and EKF estimate. The three-trace auxiliary copy remains archived but is not used as the public paper preview.
