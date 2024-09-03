## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
library(sdtm.oak)
library(tibble)

## -----------------------------------------------------------------------------
(df <- tibble(x = 1L:3L, y = letters[1L:3L]))

## -----------------------------------------------------------------------------
(cnd_df <- condition_add(dat = df, x > 1L))

## -----------------------------------------------------------------------------
cm_raw <- tibble::tibble(
  oak_id = seq_len(14L),
  raw_source = "ConMed",
  patient_number = c(375L, 375L, 376L, 377L, 377L, 377L, 377L, 378L, 378L, 378L, 378L, 379L, 379L, 379L),
  MDNUM = c(1L, 2L, 1L, 1L, 2L, 3L, 5L, 4L, 1L, 2L, 3L, 1L, 2L, 3L),
  MDRAW = c(
    "BABY ASPIRIN", "CORTISPORIN", "ASPIRIN",
    "DIPHENHYDRAMINE HCL", "PARCETEMOL", "VOMIKIND",
    "ZENFLOX OZ", "AMITRYPTYLINE", "BENADRYL",
    "DIPHENHYDRAMINE HYDROCHLORIDE", "TETRACYCLINE",
    "BENADRYL", "SOMINEX", "ZQUILL"
  )
)
cm_raw

## -----------------------------------------------------------------------------
tgt_dat <- assign_no_ct(
  tgt_var = "CMTRT",
  raw_dat = cm_raw,
  raw_var = "MDRAW"
)
tgt_dat

## -----------------------------------------------------------------------------
(cnd_tgt_dat <- condition_add(tgt_dat, CMTRT == "BENADRYL"))

## -----------------------------------------------------------------------------
derived_tgt_dat <- assign_no_ct(
  tgt_dat = cnd_tgt_dat,
  tgt_var = "CMGRPID",
  raw_dat = cm_raw,
  raw_var = "MDNUM"
)
derived_tgt_dat

