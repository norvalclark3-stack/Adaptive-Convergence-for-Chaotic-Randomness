# **Adaptive Convergence for Chaotic Randomness (ACCR)**
A closed, domain‑independent operator framework for developmental dynamics, contraction geometry, and early‑warning analysis.

This repository contains the formal specification, Lean 4 verification, and the complete empirical test suite for ACCR, including the Omega‑Spec two‑funnel early‑warning architecture and the NB Power real‑world case study.

## 1. Core Specification
ACCR_Calculus_Main.lean
Formal definition of the ACCR operator framework. Loads with no errors.

## 2. Structural Stability Suite
AC‑CR_Structural‑Stability_TestSuite.ipynb
ACCR_Stability_Atlas_v1_0_pdf.pdf Nine‑test S‑suite (S1–S9): contraction, invariance, drift, basin deformation, Lyapunov behavior.

## 3. Falsification & Adversarial Tests
ACCR_Falsification_Suite_v1_to_v5.ipynb
ACCR_v5_Spectral_Framework_Confirmation_tex.pdf Five‑stage adversarial falsification ladder: anisotropic → adversarial → coordinate‑free → hybrid → spectral.

ACCR_operator_composition_test.ipynb
ACCR_Descriptive_Analysis_2026_pdf.pdf Sequential and nested operator‑chain diagnostics.

ACCR_Pathological_Operator_Stack_Test.ipynb
ACCR_Structural_Resilience_Report_2026.pdf (shared) Stress‑test for invariance and contraction stability.

## 4. Geometry & Multi‑Scale Tests
ACCR_Degenerate_Geometry_Sweep_Test.ipynb
ACCR_Structural_Resilience_Report_2026.pdf (shared) Degenerate → singular geometry sweep for AC‑CR stability diagnostics.

ACCR_3D_BlindRG_Test.ipynb
AC_CR__Adaptive_Convergence_for_Chaotic_Randomness___Blind_RG_Evaluation.pdf Blind 3D RG evaluation: anisotropic field, hidden‑event detection, multi‑scale stability.

## 5. Meta‑Structure
ACCR_Meta_Structure.ipynb
ACCR_Structural_Resilience_Report_2026.pdf (shared) Framework‑level meta‑structure: axioms, invariants, diagnostic structure.

## 6. Applied Demonstrations
Developmental_ECG_Instability_Atlas_v1.ipynb
ECG_Dynamics_as_a_29_Cell_Developmental_System__Geometry__Instability__and_Early_Warning_Structure.pdf               ECG developmental geometry, drift accumulation, instability metrics, and early‑warning signals.
ACCR_IDC_Clark_2026_tex.pdf — A developmental geometry framework that maps physiological waveforms into a symmetry‑preserving manifold to track drift, instability, and curvature.

ACCR_as_an_Operational_Realization_of_the_Kuehn_Critical_Transition_Framework.ipynb
ACCR_as_an_Operational_Realization_of_the_Kuehn_Critical_Transition_Framework.pdf Operational demonstration that ACCR reproduces Kuehn (2011) universality‑class geometry (fold, Hopf, noise‑escape).

## 7. Omega‑Spec Early‑Warning Architecture
ACCR_Two_Funnel_Early_Warning_OmegaSpec.ipynb
ACCR_Two_Funnel_Early_Warning_OmegaSpec.pdf Full implementation of the Omega‑Spec two‑funnel early‑warning system:

Funnel 1: predictive curvature‑instability × thinning

Collapse boundary: argmax of ACCR

Funnel 2: reactive volatility × alignment flips

Severity: continuous trapezoidal tail integration

## 8. Real‑World Case Study
ACCR_NB_Power_March_2026.ipynb
ACCR_NB_Power_Case_Study_March_2026_tex.pdf Real NB Power hourly load data processed through ACCR:

Plain‑text (GitHub‑safe) values:

Early‑warning trigger: t1 = 0

Collapse boundary: tc = 16

Reactive activation: t2 = 17

Predictive horizon: H1 = 16

Reactive horizon: H2 = 1

Severity score: 0.064

Demonstrates ACCR’s operational viability on real utility telemetry.

## 9. Quick Start
ACCR_QuickStart.ipynb
Minimal 3‑cell ACCR notebook for rapid evaluation:

Directional change

Acceleration

Instability gradient

Collapse funnel

Early‑warning signal

## 10. External Resources
Zenodo (canonical DOI): https://doi.org/10.5281/zenodo.20844499

OSF (archival project): https://doi.org/10.17605/OSF.IO/DYJC8

## 11. License
MIT License.
