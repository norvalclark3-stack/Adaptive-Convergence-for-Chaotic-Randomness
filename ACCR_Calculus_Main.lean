/-
  AC‑CR Calculus — One‑Axiom Core
  (Lean 4 compatible)

  This file defines:
  • The AC‑CR abstract syntax (ACCR)
  • One‑step operational relations via flat inductive constructors
  • A sequent calculus (Derivable) over ACCR
  • Structural equivalence (StructEq) and an Equiv_Step layer
  • Subject‑reduction principles for all reduction forms
  • Exactly one semantic axiom: ContextAllows (the external semantic admissibility interface)

-/

set_option linter.unusedVariables false

/-- Concrete Label type. --/
def Label : Type := String

/-- Concrete Formula definitions representing transition conditions. --/
inductive Formula : Type where
  | action_token : String → Formula
  | metric_check : String → Formula
  | composite    : Formula → Formula → Formula

/-- Core AC‑CR syntax (abstract process terms). --/
inductive ACCR : Type where
  | core_op     : ACCR → ACCR → ACCR
  | metric      : Label → ACCR
  | contraction : ACCR → ACCR
  | action      : Formula → ACCR
  | process     : Formula → ACCR
  | tap         : ACCR → ACCR → ACCR
  | lc          : ACCR → ACCR → ACCR
  | sp          : ACCR → ACCR → ACCR
  | bp          : ACCR → ACCR → ACCR
  | thinning    : ACCR → ACCR
  | branching   : List ACCR → ACCR
  | equivalence : ACCR → ACCR → ACCR

/-- Canonical wrappers for the core operators. --/
def TAP (M : Label) (A : Formula) (P : ACCR) : ACCR :=
  ACCR.tap (ACCR.metric M) (ACCR.core_op (ACCR.action A) P)

def LC (M : Label) (P : ACCR) : ACCR :=
  ACCR.lc (ACCR.metric M) P

def SP (P Q : ACCR) : ACCR := ACCR.sp P Q
def BP (P Q : ACCR) : ACCR := ACCR.bp P Q
def THIN (P : ACCR) : ACCR := ACCR.thinning P
def BRANCH (bs : List ACCR) : ACCR := ACCR.branching bs
def EQ (P Q : ACCR) : ACCR := ACCR.equivalence P Q

/-- Single remaining semantic side relation: local environment admissibility.
    This is the intentional interface between the calculus and its semantic interpretation layer
. --/
axiom ContextAllows : Label → ACCR → Prop

/-- Concrete implementation of InternalStep. --/
inductive InternalStep : ACCR → Formula → ACCR → Prop where
  | execute_action :
      ∀ (s : String),
        InternalStep
          (ACCR.action (Formula.action_token s))
          (Formula.action_token s)
          (ACCR.process (Formula.action_token s))

/-- Concrete implementation of MetricSatisfied. --/
inductive MetricSatisfied : Label → Formula → Prop where
  | label_match :
      ∀ (lbl : String),
        MetricSatisfied lbl (Formula.metric_check lbl)
  | default_allow :
      ∀ (lbl : String) (act : String),
        MetricSatisfied lbl (Formula.action_token act)

/-- Concrete implementation of Stable. --/
inductive Stable : ACCR → Label → Prop where
  | process_stable :
      ∀ (f : Formula) (lbl : Label),
        Stable (ACCR.process f) lbl

/-- TAP one‑step operational rule. --/
inductive TAP_Step : ACCR → ACCR → Prop where
  | transition :
      ∀ (M : Label) (A : Formula) (P P' : ACCR),
        InternalStep P A P' →
        MetricSatisfied M A →
        Stable P' M →
        TAP_Step (TAP M A P) P'

/-- LC one‑step operational rule (guarded by ContextAllows). --/
inductive LC_Step : ACCR → ACCR → Prop where
  | local_env :
      ∀ (M : Label) (P P' : ACCR),
        ContextAllows M P →
        ContextAllows M P' →
        LC_Step (LC M P) P'

/-- BP one‑step operational rule: nondeterministic binary choice. --/
inductive BP_Step : ACCR → ACCR → Prop where
  | branch_left :
      ∀ (P Q : ACCR),
        BP_Step (BP P Q) P
  | branch_right :
      ∀ (P Q : ACCR),
        BP_Step (BP P Q) Q

/-- Atomic choice step: nondeterministic selection of any branch in the set. --/
inductive AtomicChoice_Step : ACCR → ACCR → Prop where
  | select_branch :
      ∀ (bs : List ACCR) (b : ACCR),
        b ∈ bs →
        AtomicChoice_Step (BRANCH bs) b

/-- Expansion step: distributing a core operator over a branch set. --/
inductive Expansion_Step : ACCR → ACCR → Prop where
  | distribute_core :
      ∀ (bs : List ACCR) (P : ACCR),
        Expansion_Step
          (ACCR.core_op P (BRANCH bs))
          (BRANCH (bs.map (fun b => ACCR.core_op P b)))

/-- Structural equivalence: purely structural, non‑computational rewrites. --/
inductive StructEq : ACCR → ACCR → Prop where
  | refl  : ∀ {P}, StructEq P P
  | sym   : ∀ {P Q}, StructEq P Q → StructEq Q P
  | trans : ∀ {P Q R}, StructEq P Q → StructEq Q R → StructEq P R
  | sp_comm :
      ∀ {P Q}, StructEq (SP P Q) (SP Q P)
  | sp_assoc :
      ∀ {P Q R}, StructEq (SP (SP P Q) R) (SP P (SP Q R))
  | branch_perm :
      ∀ {bs₁ bs₂},
        List.Perm bs₂ bs₁ →
        StructEq (BRANCH bs₁) (BRANCH bs₂)

/-- Equivalence step: collapsing an explicit equivalence node to its right argument. --/
inductive Equiv_Step : ACCR → ACCR → Prop where
  | use_eq :
      ∀ {P Q},
        StructEq P Q →
        Equiv_Step (EQ P Q) Q

/-- Global one‑step AC‑CR reduction relation. --/
inductive ACCR_Step : ACCR → ACCR → Prop where
  | tap_step :
      ∀ {P P'},
        TAP_Step P P' →
        ACCR_Step P P'
  | lc_step :
      ∀ {P P'},
        LC_Step P P' →
        ACCR_Step P P'
  | bp_step :
      ∀ {P P'},
        BP_Step P P' →
        ACCR_Step P P'
  | equiv_step :
      ∀ {P P'},
        Equiv_Step P P' →
        ACCR_Step P P'
  | atomic_choice_step :
      ∀ {P P'},
        AtomicChoice_Step P P' →
        ACCR_Step P P'
  | expansion_step :
      ∀ {P P'},
        Expansion_Step P P' →
        ACCR_Step P P'
  | sp_left_step :
      ∀ (P P' Q : ACCR),
        ACCR_Step P P' →
        ACCR_Step (SP P Q) (SP P' Q)
  | sp_right_step :
      ∀ (P Q Q' : ACCR),
        ACCR_Step Q Q' →
        ACCR_Step (SP P Q) (SP P Q')

/-- Sequents: Γ ⊢ Δ, with Γ and Δ lists of ACCR terms. --/
structure Sequent where
  Γ : List ACCR
  Δ : List ACCR

/-- Sequent calculus over ACCR. --/
inductive Derivable : Sequent → Prop where
  | ax :
      ∀ {Γ A}, Derivable ⟨Γ, [A]⟩

  | thinningL :
      ∀ {Γ Δ P},
        Derivable ⟨Γ, Δ⟩ →
        Derivable ⟨P :: Γ, Δ⟩

  | thinningR :
      ∀ {Γ Δ P},
        Derivable ⟨Γ, Δ⟩ →
        Derivable ⟨Γ, P :: Δ⟩

  | branch_choice :
      ∀ {Γ Δ bs b},
        b ∈ bs →
        Derivable ⟨Γ, b :: Δ⟩ →
        Derivable ⟨Γ, BRANCH bs :: Δ⟩

  | branch_choice_elim :
      ∀ {Γ Δ bs b},
        b ∈ bs →
        Derivable ⟨Γ, BRANCH bs :: Δ⟩ →
        Derivable ⟨Γ, b :: Δ⟩

  | branch_expand :
      ∀ {Γ bs},
        (∀ b ∈ bs, Derivable ⟨Γ, [b]⟩) →
        Derivable ⟨Γ, [BRANCH bs]⟩

  | expansion_rule :
      ∀ {Γ Δ bs P},
        Derivable ⟨Γ, ACCR.core_op P (BRANCH bs) :: Δ⟩ →
        Derivable ⟨Γ, BRANCH (bs.map (fun b => ACCR.core_op P b)) :: Δ⟩

  | equiv_rule :
      ∀ {Γ Δ P Q},
        StructEq P Q →
        Derivable ⟨Γ, P :: Δ⟩ →
        Derivable ⟨Γ, Q :: Δ⟩

  | eq_node_rule :
      ∀ {Γ Δ P Q},
        StructEq P Q →
        Derivable ⟨Γ, EQ P Q :: Δ⟩ →
        Derivable ⟨Γ, Q :: Δ⟩

  | tap_rule :
      ∀ {Γ Δ M A P P'},
        TAP_Step (TAP M A P) P' →
        Derivable ⟨Γ, (TAP M A P) :: Δ⟩ →
        Derivable ⟨Γ, P' :: Δ⟩

  | lc_rule :
      ∀ {Γ Δ M P P'},
        LC_Step (LC M P) P' →
        Derivable ⟨Γ, (LC M P) :: Δ⟩ →
        Derivable ⟨Γ, P' :: Δ⟩

  | sp_left_rule :
      ∀ {Γ Δ P P' Q},
        ACCR_Step P P' →
        Derivable ⟨Γ, SP P Q :: Δ⟩ →
        Derivable ⟨Γ, SP P' Q :: Δ⟩

  | sp_right_rule :
      ∀ {Γ Δ P Q Q'},
        ACCR_Step Q Q' →
        Derivable ⟨Γ, SP P Q :: Δ⟩ →
        Derivable ⟨Γ, SP P Q' :: Δ⟩

  | bp_rule :
      ∀ {Γ Δ P Q P'},
        BP_Step (BP P Q) P' →
        Derivable ⟨Γ, (BP P Q) :: Δ⟩ →
        Derivable ⟨Γ, P' :: Δ⟩

/-- Symmetry of structural equivalence. --/
theorem structEq_symm {P Q : ACCR} (h : StructEq P Q) : StructEq Q P :=
  StructEq.sym h

/-- Reflexivity of structural equivalence. --/
theorem structEq_refl (P : ACCR) : StructEq P P :=
  StructEq.refl

/-- Left thinning preserves derivability. --/
theorem thinningL_preserves
  {Γ Δ : List ACCR} {P : ACCR}
  (h : Derivable ⟨Γ, Δ⟩) :
  Derivable ⟨P :: Γ, Δ⟩ :=
  Derivable.thinningL h

/-- Right thinning preserves derivability. --/
theorem thinningR_preserves
  {Γ Δ : List ACCR} {P : ACCR}
  (h : Derivable ⟨Γ, Δ⟩) :
  Derivable ⟨Γ, P :: Δ⟩ :=
  Derivable.thinningR h

/-- Structural equivalence preserves derivability in the succedent. --/
theorem structEq_preserves_derivability
  {Γ Δ : List ACCR} {P Q : ACCR}
  (hPQ : StructEq P Q)
  (h : Derivable ⟨Γ, P :: Δ⟩) :
  Derivable ⟨Γ, Q :: Δ⟩ :=
  Derivable.equiv_rule hPQ h

/-- Commutativity of SP lifted to sequents. --/
theorem sp_comm_sequent
  {Γ Δ : List ACCR} {P Q : ACCR}
  (h : Derivable ⟨Γ, (SP P Q) :: Δ⟩) :
  Derivable ⟨Γ, (SP Q P) :: Δ⟩ :=
  Derivable.equiv_rule (StructEq.sp_comm) h

/-- Permutation of branches preserves derivability. --/
theorem branch_perm_preserves_derivability
  {Γ Δ : List ACCR} {bs₁ bs₂ : List ACCR}
  (hperm : List.Perm bs₂ bs₁)
  (h : Derivable ⟨Γ, (BRANCH bs₁) :: Δ⟩) :
  Derivable ⟨Γ, (BRANCH bs₂) :: Δ⟩ :=
  Derivable.equiv_rule (StructEq.branch_perm hperm) h

/-- Soundness of branch expansion: if each branch is derivable, the branch set is derivable. --/
theorem branch_expand_sound
  {Γ : List ACCR} {bs : List ACCR}
  (h : ∀ b ∈ bs, Derivable ⟨Γ, [b]⟩) :
  Derivable ⟨Γ, [BRANCH bs]⟩ :=
  Derivable.branch_expand h

/-- Equiv_Step reflects structural equivalence. --/
theorem equiv_step_sound
  {P Q : ACCR}
  (h : Equiv_Step (EQ P Q) Q) :
  StructEq P Q :=
by
  cases h with
  | use_eq hPQ => exact hPQ

/-- TAP steps preserve derivability when applied to TAP‑wrapped terms. --/
theorem tap_step_preserves_derivability
  {Γ Δ : List ACCR} {M : Label} {A : Formula} {P P' : ACCR}
  (hS : TAP_Step (TAP M A P) P')
  (hD : Derivable ⟨Γ, (TAP M A P) :: Δ⟩) :
  Derivable ⟨Γ, P' :: Δ⟩ :=
  Derivable.tap_rule hS hD

/-- LC steps preserve derivability when applied to LC‑wrapped terms. --/
theorem lc_step_preserves_derivability
  {Γ Δ : List ACCR} {M : Label} {P P' : ACCR}
  (hS : LC_Step (LC M P) P')
  (hD : Derivable ⟨Γ, (LC M P) :: Δ⟩) :
  Derivable ⟨Γ, P' :: Δ⟩ :=
  Derivable.lc_rule hS hD

/-- Left SP steps preserve derivability. --/
theorem subject_reduction_sp_left
  {Γ Δ : List ACCR} {P P' Q : ACCR}
  (hS : ACCR_Step P P')
  (hD : Derivable ⟨Γ, SP P Q :: Δ⟩) :
  Derivable ⟨Γ, SP P' Q :: Δ⟩ :=
  Derivable.sp_left_rule hS hD

/-- Right SP steps preserve derivability. --/
theorem subject_reduction_sp_right
  {Γ Δ : List ACCR} {P Q Q' : ACCR}
  (hS : ACCR_Step Q Q')
  (hD : Derivable ⟨Γ, SP P Q :: Δ⟩) :
  Derivable ⟨Γ, SP P Q' :: Δ⟩ :=
  Derivable.sp_right_rule hS hD

/-- BP steps preserve derivability when applied to BP‑composed terms. --/
theorem bp_step_preserves_derivability
  {Γ Δ : List ACCR} {P Q P' : ACCR}
  (hS : BP_Step (BP P Q) P')
  (hD : Derivable ⟨Γ, (BP P Q) :: Δ⟩) :
  Derivable ⟨Γ, P' :: Δ⟩ :=
  Derivable.bp_rule hS hD

/-
  Subject‑reduction layer:
  Proven directly from the sequent calculus rules.
-/

/-- Subject reduction for TAP steps. --/
theorem subject_reduction_tap
  {Γ Δ : List ACCR} {P P' : ACCR}
  (hS : TAP_Step P P')
  (hD : Derivable ⟨Γ, P :: Δ⟩) :
  Derivable ⟨Γ, P' :: Δ⟩ :=
by
  match hS with
  | TAP_Step.transition M A Q Q' hInt hMet hStab =>
      exact Derivable.tap_rule (TAP_Step.transition M A Q Q' hInt hMet hStab) hD

/-- Subject reduction for LC steps. --/
theorem subject_reduction_lc
  {Γ Δ : List ACCR} {P P' : ACCR}
  (hS : LC_Step P P')
  (hD : Derivable ⟨Γ, P :: Δ⟩) :
  Derivable ⟨Γ, P' :: Δ⟩ :=
by
  match hS with
  | LC_Step.local_env M Q Q' hAllowP hAllowP' =>
      exact Derivable.lc_rule (LC_Step.local_env M Q Q' hAllowP hAllowP') hD

/-- Subject reduction for BP steps. --/
theorem subject_reduction_bp
  {Γ Δ : List ACCR} {P P' : ACCR}
  (hS : BP_Step P P')
  (hD : Derivable ⟨Γ, P :: Δ⟩) :
  Derivable ⟨Γ, P' :: Δ⟩ :=
by
  match hS with
  | BP_Step.branch_left Q R =>
      exact Derivable.bp_rule (BP_Step.branch_left Q R) hD
  | BP_Step.branch_right Q R =>
      exact Derivable.bp_rule (BP_Step.branch_right Q R) hD

/-- Subject reduction for Equiv steps:
    collapsing an EQ node to its right argument preserves derivability. --/
theorem subject_reduction_equiv
  {Γ Δ : List ACCR} {P P' : ACCR}
  (hS : Equiv_Step P P')
  (hD : Derivable ⟨Γ, P :: Δ⟩) :
  Derivable ⟨Γ, P' :: Δ⟩ :=
by
  match hS with
  | Equiv_Step.use_eq hPQ =>
      exact Derivable.eq_node_rule hPQ hD

/-- Subject reduction for AtomicChoice steps:
    collapsing a BRANCH node to a chosen branch preserves derivability. --/
theorem subject_reduction_atomic
  {Γ Δ : List ACCR} {P P' : ACCR}
  (hS : AtomicChoice_Step P P')
  (hD : Derivable ⟨Γ, P :: Δ⟩) :
  Derivable ⟨Γ, P' :: Δ⟩ :=
by
  match hS with
  | AtomicChoice_Step.select_branch bs b hb =>
      exact Derivable.branch_choice_elim hb hD

/-- Subject reduction for Expansion steps:
    expanding a core operator over a branch set preserves derivability. --/
theorem subject_reduction_expansion
  {Γ Δ : List ACCR} {P P' : ACCR}
  (hS : Expansion_Step P P')
  (hD : Derivable ⟨Γ, P :: Δ⟩) :
  Derivable ⟨Γ, P' :: Δ⟩ :=
by
  match hS with
  | Expansion_Step.distribute_core bs Q =>
      exact Derivable.expansion_rule hD

/-- Global subject‑reduction theorem for the AC‑CR one‑step relation. --/
theorem subject_reduction
  {Γ Δ : List ACCR} {P P' : ACCR}
  (hS : ACCR_Step P P')
  (hD : Derivable ⟨Γ, P :: Δ⟩) :
  Derivable ⟨Γ, P' :: Δ⟩ :=
by
  cases hS with
  | tap_step hTap =>
      exact subject_reduction_tap hTap hD
  | lc_step hLc =>
      exact subject_reduction_lc hLc hD
  | bp_step hBp =>
      exact subject_reduction_bp hBp hD
  | equiv_step hEq =>
      exact subject_reduction_equiv hEq hD
  | atomic_choice_step hAC =>
      exact subject_reduction_atomic hAC hD
  | expansion_step hEx =>
      exact subject_reduction_expansion hEx hD
  | sp_left_step P P' Q hSubStep =>
      exact subject_reduction_sp_left hSubStep hD
  | sp_right_step P Q Q' hSubStep =>
      exact subject_reduction_sp_right hSubStep hD
