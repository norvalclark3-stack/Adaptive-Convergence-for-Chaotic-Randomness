
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

## 6. External Resources

- **OSF (archival)**: DOI link (to be added)  
- **arXiv (preprint)**: link (to be added)

---

## 7. License

MIT License.
