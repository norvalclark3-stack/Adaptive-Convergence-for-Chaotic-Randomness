
# Adaptive Convergence for Chaotic Randomness (AC‑CR)

A minimal operator framework for developmental dynamics and contraction geometry.

This repository contains the formal specification, Lean implementation, and full empirical test suite for AC‑CR.

---

## 1. Core Files

- **ACCR_Calculus_Main.lean**  
  Formal definition of the AC‑CR operator framework. Loads with no errors.

- **AC‑CR_Structural‑Stability_TestSuite.ipynb**  
  Nine‑test S‑suite (S → S‑9): contraction, invariance, drift, basin deformation, Lyapunov behavior.

---

## 2. Falsification Suite

- **ACCR_Falsification_Suite_v1_to_v5.ipynb**  
  Five‑stage adversarial falsification ladder: anisotropic → adversarial → coordinate‑free → hybrid → spectral.

---

## 3. Operator‑Level Tests

- **ACCR_operator_composition_test.ipynb**  
  Sequential + nested operator‑chain stability and drift diagnostics.

- **ACCR_Pathological_Operator_Stack_Test.ipynb**  
  Adversarial operator‑stack stress test for invariance and contraction stability.

---

## 4. Geometry + Multi‑Scale Tests

- **ACCR_Degenerate_Geometry_Sweep_Test.ipynb**  
  Degenerate → singular geometry sweep for AC‑CR stability diagnostics.

- **ACCR_3D_BlindRG_Test.ipynb**  
  Blind 3D RG test: anisotropic field, hidden‑event detection, multi‑scale stability.

---

## 5. Meta‑Structure

- **ACCR_Meta_Structure.ipynb**  
  Framework‑level meta‑structure: axioms, invariants, diagnostics.

---

## 6. Additional Research Papers (2026)

**Developmental_ECG_Instability_Atlas_v1.ipynb**

### ACCR_Invariant_Developmental_Calculus_Clark_2026.pdf
Foundational mathematical specification of the AC‑CR invariant developmental calculus:
- deterministic operator structure
- 29‑cell developmental manifold
- structural derivatives, curvature, drift, and instability metrics
- invariance axioms and formal lemmas

### ECG Dynamics as a 29‑Cell Developmental System.pdf
First applied demonstration of AC‑CR:
- developmental geometry of ECG RR‑interval sequences
- drift and instability accumulation
- curvature‑first early‑warning signals 
- collapse‑risk trajectories
  
---


## 7. External Resources

- Zenodo (canonical DOI): https://doi.org/10.5281/zenodo.20844499
- OSF (archival project): https://doi.org/10.17605/OSF.IO/DYJC8


---

## 8. License

MIT License.
