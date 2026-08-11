

<!-- !!! attention PRE-REQUISITES
    The content of the following files serves as required pre-requisite reading and should be treated as a substituion for this admonition.  
    * Common to all Planning Topics: `docs/.ai/planning/common/PLAN_*.md` 
    * Common to this Planinng Topic: `docs/.ai/planning/__planning_topics[n]__/common/PLAN___planning_topics[n]___COMMON*.md` 
    * Common to all Planning Topic Tasks: []()
    - -->
# Prerequisites


## Gloassary

The following terms may be expressed using `zsh` variable syntax for the remainder of this document
* `product_dir` - Root dir where the product's source code is located
  * This is often (but not always) where the `.git` dir is located
  <!-- * This directory should contain  `docs/.ai/planning/` -->
* `product_docs_dir` - Path to the root directory of where the product's source code is located

```zsh

typeset -r git_root_dir="$(git rev-parse --show-toplevel)"

# Dir where the product's source code is located
# This is commonly where the `.git` dir is located
typeset -r product_dir="${git_root_dir}"
typeset -r docs_dir="${product_dir}/docs"
typeset -r ai_docs_dir="${product_dir}/docs/.ai"
typeset -r ai_planning_dir="${product_dir}/docs/.ai/planning"
typeset -r ai_planning_dir="${product_dir}/docs/.ai/planning"
```



!!! attention PRE-REQUISITES
    
    * Common in Product Scope: Contents are applied to all planning files under this product
      * filepath: `${planning_product}/docs/.ai/planning/common/PLAN_COMMON.md`
      * applies to: `${planning_product}/.ai/planning/**/PLAN_*.md`
    * Common in Planning Topic Scope / Phase Common: Contents are common across all planning file phases
      * filepath: `${planning_product}/.ai/planning/__planning_topics[n]__/PLAN_COMMON_PHASE`
      * applies to: `${planning_product}/.ai/planning/__planning_topics[n]__/PLAN___planning_topics[n]___PHASE-*.md`
    * Common across product: `${planning_product}/.ai/planning/common/PLAN_COMMON.md`






# Common
Information in this section is common across subsequent H1 sections in this document (aka: `Tasks`)

**References**


---

## About

__about__

---

<!-- # Plan: __planning_topics[n]__ — Phase 01 -->
# Task


## Goals

- [ ] Define objectives for this planning session

## Context

<!-- Add relevant context and background information here -->

## Tasks

- [ ] 

## Notes

<!-- Add any notes or observations here -->
