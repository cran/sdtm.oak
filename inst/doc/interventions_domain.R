## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

library(sdtm.oak)
library(admiraldev)
library(rlang)
library(dplyr, warn.conflicts = FALSE)

## ----eval=TRUE, echo=FALSE----------------------------------------------------
cm_raw <- read.csv(system.file("raw_data/cm_raw_data.csv",
  package = "sdtm.oak"
))

## ----eval=TRUE, echo=FALSE----------------------------------------------------
sdtm.oak:::dataset_oak_vignette(
  cm_raw,
  display_vars = exprs(
    PATNUM, FORML, MDNUM, MDRAW, MDIND, MDBDR, MDBTM, MDPRIOR, MDEDR,
    MDETM, MDONG, DOS, DOSU, MDFORM, MDRTE, MDFRQ, MDPROPH
  )
)

## ----eval=TRUE----------------------------------------------------------------
cm_raw <- read.csv(system.file("raw_data/cm_raw_data.csv",
  package = "sdtm.oak"
))

## ----eval=TRUE----------------------------------------------------------------
cm_raw <- cm_raw %>%
  generate_oak_id_vars(
    pat_var = "PATNUM",
    raw_src = "cm_raw"
  )

## ----eval=TRUE, echo=FALSE----------------------------------------------------
sdtm.oak:::dataset_oak_vignette(
  cm_raw,
  display_vars = exprs(
    oak_id, raw_source, patient_number, PATNUM, FORML, MDNUM, MDRAW
  )
)

## ----eval=TRUE----------------------------------------------------------------
dm <- read.csv(system.file("raw_data/dm.csv",
  package = "sdtm.oak"
))

## ----eval=TRUE----------------------------------------------------------------
study_ct <- read.csv(system.file("raw_data/sdtm_ct.csv",
  package = "sdtm.oak"
))

## ----eval=TRUE, echo=FALSE----------------------------------------------------
sdtm.oak:::dataset_oak_vignette(
  study_ct,
  display_vars = exprs(
    codelist_code, term_code, term_value, collected_value, term_preferred_term,
    term_synonyms
  )
)

## ----eval=TRUE----------------------------------------------------------------
cm <-
  # Map topic variable
  assign_no_ct(
    raw_dat = cm_raw,
    raw_var = "MDRAW",
    tgt_var = "CMTRT"
  )

## ----eval=TRUE, echo=FALSE----------------------------------------------------
sdtm.oak:::dataset_oak_vignette(
  cm,
  display_vars = exprs(
    oak_id, raw_source, patient_number, CMTRT
  )
)

## ----eval=TRUE----------------------------------------------------------------
cm <- cm %>%
  # Map CMGRPID
  assign_no_ct(
    raw_dat = cm_raw,
    raw_var = "MDNUM",
    tgt_var = "CMGRPID",
    id_vars = oak_id_vars()
  )

## ----eval=TRUE, echo=FALSE----------------------------------------------------
sdtm.oak:::dataset_oak_vignette(
  cm,
  display_vars = exprs(
    oak_id, raw_source, patient_number, CMTRT, CMGRPID
  )
)

## ----eval=TRUE----------------------------------------------------------------
cm <- cm %>%
  # Map qualifier CMDOSU
  assign_ct(
    raw_dat = cm_raw,
    raw_var = "DOSU",
    tgt_var = "CMDOSU",
    ct_spec = study_ct,
    ct_clst = "C71620",
    id_vars = oak_id_vars()
  )

## ----eval=TRUE, echo=FALSE----------------------------------------------------
sdtm.oak:::dataset_oak_vignette(
  cm,
  display_vars = exprs(
    oak_id, raw_source, patient_number, CMTRT, CMGRPID, CMDOSU
  )
)

## ----eval=TRUE----------------------------------------------------------------
cm <- cm %>%
  # Map CMSTDTC. This function calls create_iso8601
  assign_datetime(
    raw_dat = cm_raw,
    raw_var = c("MDBDR", "MDBTM"),
    tgt_var = "CMSTDTC",
    raw_fmt = c(list(c("d-m-y", "dd mmm yyyy")), "H:M"),
    raw_unk = c("UN", "UNK"),
    id_vars = oak_id_vars()
  )

## ----eval=TRUE, echo=FALSE----------------------------------------------------
sdtm.oak:::dataset_oak_vignette(
  cm,
  display_vars = exprs(
    oak_id, raw_source, patient_number, CMTRT, CMGRPID, CMDOSU, CMSTDTC
  )
)

## ----eval=TRUE----------------------------------------------------------------
cm <- cm %>%
  # Map qualifier CMSTRTPT  Annotation text is If MDPRIOR == 1 then CM.CMSTRTPT = 'BEFORE'
  hardcode_ct(
    raw_dat = condition_add(cm_raw, MDPRIOR == "1"),
    raw_var = "MDPRIOR",
    tgt_var = "CMSTRTPT",
    tgt_val = "BEFORE",
    ct_spec = study_ct,
    ct_clst = "C66728",
    id_vars = oak_id_vars()
  )

## ----eval=TRUE, echo=FALSE----------------------------------------------------
sdtm.oak:::dataset_oak_vignette(
  cm,
  display_vars = exprs(
    oak_id, raw_source, patient_number, CMTRT, CMGRPID, CMDOSU, CMSTDTC, CMSTRTPT
  )
)

## ----eval=TRUE----------------------------------------------------------------
cm <- cm %>%
  # Map qualifier CMSTTPT  Annotation text is If MDPRIOR == 1 then CM.CMSTTPT = 'SCREENING'
  hardcode_no_ct(
    raw_dat = condition_add(cm_raw, MDPRIOR == "1"),
    raw_var = "MDPRIOR",
    tgt_var = "CMSTTPT",
    tgt_val = "SCREENING",
    id_vars = oak_id_vars()
  )

## ----eval=TRUE, echo=FALSE----------------------------------------------------
sdtm.oak:::dataset_oak_vignette(
  cm,
  display_vars = exprs(
    oak_id, raw_source, patient_number, CMTRT, CMGRPID, CMDOSU, CMSTDTC, CMSTRTPT, CMSTTPT
  )
)

## ----eval=TRUE----------------------------------------------------------------
cm <- cm %>%
  # Map qualifier CMDOSFRQ  Annotation text is If CMTRT is not null then map
  # the collected value in raw dataset cm_raw and raw variable MDFRQ to CMDOSFRQ
  {
    assign_ct(
      raw_dat = cm_raw,
      raw_var = "MDFRQ",
      tgt_dat =  condition_add(., !is.na(CMTRT)),
      tgt_var = "CMDOSFRQ",
      ct_spec = study_ct,
      ct_clst = "C66728",
      id_vars = oak_id_vars()
    )
  }

## ----eval=TRUE, echo=FALSE----------------------------------------------------
sdtm.oak:::dataset_oak_vignette(
  cm,
  display_vars = exprs(
    oak_id, raw_source, patient_number, CMTRT, CMGRPID, CMDOSU, CMSTDTC, CMSTRTPT, CMSTTPT, CMDOSFRQ
  )
)

## ----eval=FALSE---------------------------------------------------------------
#  cm <- cm %>%
#    condition_add(!is.na(CMTRT)) %>%
#    assign_ct(
#      raw_dat = cm_raw,
#      raw_var = "DOSU",
#      tgt_var = "CMDOSU",
#      ct_spec = study_ct,
#      ct_clst = "C71620",
#      id_vars = oak_id_vars()
#    )

## ----eval=TRUE----------------------------------------------------------------
cm <- cm %>%
  # Map CMMODIFY  Annotation text  If collected value in MODIFY in cm_raw is
  # different to CM.CMTRT then assign the collected value to CMMODIFY in
  # CM domain (CM.CMMODIFY)
  {
    assign_no_ct(
      raw_dat = cm_raw,
      raw_var = "MODIFY",
      tgt_dat = condition_add(., MODIFY != CMTRT, .dat2 = cm_raw),
      tgt_var = "CMMODIFY",
      id_vars = oak_id_vars()
    )
  }

## ----eval=TRUE, echo=FALSE----------------------------------------------------
sdtm.oak:::dataset_oak_vignette(
  cm,
  display_vars = exprs(
    oak_id, raw_source, patient_number, CMTRT, CMGRPID, CMDOSU, CMSTDTC, CMSTRTPT, CMSTTPT, CMDOSFRQ, CMMODIFY
  )
)

## ----eval=FALSE---------------------------------------------------------------
#  cm <- cm %>%
#    condition_add(MODIFY != CMTRT, .dat2 = cm_raw) %>%
#    assign_no_ct(
#      raw_dat = cm_raw,
#      raw_var = "MODIFY",
#      tgt_var = "CMMODIFY",
#      id_vars = oak_id_vars()
#    )

## ----eval=TRUE----------------------------------------------------------------
cm <- cm %>%
  # Map CMINDC as the collected value in MDIND to CM.CMINDC
  assign_no_ct(
    raw_dat = cm_raw,
    raw_var = "MDIND",
    tgt_var = "CMINDC",
    id_vars = oak_id_vars()
  ) %>%
  # Map CMENDTC as the collected value in MDEDR and MDETM to CM.CMENDTC.
  # This function calls create_iso8601
  assign_datetime(
    raw_dat = cm_raw,
    raw_var = c("MDEDR", "MDETM"),
    tgt_var = "CMENDTC",
    raw_fmt = c("d-m-y", "H:M"),
    raw_unk = c("UN", "UNK")
  ) %>%
  # Map qualifier CMENRTPT as If MDONG == 1 then CM.CMENRTPT = 'ONGOING'
  hardcode_ct(
    raw_dat = condition_add(cm_raw, MDONG == "1"),
    raw_var = "MDONG",
    tgt_var = "CMENRTPT",
    tgt_val = "ONGOING",
    ct_spec = study_ct,
    ct_clst = "C66728",
    id_vars = oak_id_vars()
  ) %>%
  # Map qualifier CMENTPT as If MDONG == 1 then CM.CMENTPT = 'DATE OF LAST ASSESSMENT'
  hardcode_no_ct(
    raw_dat = condition_add(cm_raw, MDONG == "1"),
    raw_var = "MDONG",
    tgt_var = "CMENTPT",
    tgt_val = "DATE OF LAST ASSESSMENT",
    id_vars = oak_id_vars()
  ) %>%
  # Map qualifier CMDOS as If collected value in raw_var DOS is numeric then CM.CMDOSE
  assign_no_ct(
    raw_dat = condition_add(cm_raw, is.numeric(DOS)),
    raw_var = "DOS",
    tgt_var = "CMDOS",
    id_vars = oak_id_vars()
  ) %>%
  # Map qualifier CMDOS as If collected value in raw_var DOS is character then CM.CMDOSTXT
  assign_no_ct(
    raw_dat = condition_add(cm_raw, is.character(DOS)),
    raw_var = "DOS",
    tgt_var = "CMDOSTXT",
    id_vars = oak_id_vars()
  ) %>%
  # Map qualifier CMDOSU as the collected value in the cm_raw dataset DOSU variable to CM.CMDOSU
  assign_ct(
    raw_dat = cm_raw,
    raw_var = "DOSU",
    tgt_var = "CMDOSU",
    ct_spec = study_ct,
    ct_clst = "C71620",
    id_vars = oak_id_vars()
  ) %>%
  # Map qualifier CMDOSFRM as the collected value in the cm_raw dataset MDFORM variable to CM.CMDOSFRM
  assign_ct(
    raw_dat = cm_raw,
    raw_var = "MDFORM",
    tgt_var = "CMDOSFRM",
    ct_spec = study_ct,
    ct_clst = "C66726",
    id_vars = oak_id_vars()
  ) %>%
  # Map CMROUTE as the collected value in the cm_raw dataset MDRTE variable to CM.CMROUTE
  assign_ct(
    raw_dat = cm_raw,
    raw_var = "MDRTE",
    tgt_var = "CMROUTE",
    ct_spec = study_ct,
    ct_clst = "C66729",
    id_vars = oak_id_vars()
  ) %>%
  # Map qualifier CMPROPH as If MDPROPH == 1 then CM.CMPROPH = 'Y'
  hardcode_ct(
    raw_dat = condition_add(cm_raw, MDPROPH == "1"),
    raw_var = "MDPROPH",
    tgt_var = "CMPROPH",
    tgt_val = "Y",
    ct_spec = study_ct,
    ct_clst = "C66742",
    id_vars = oak_id_vars()
  ) %>%
  # Map CMDRG as the collected value in the cm_raw dataset CMDRG variable to CM.CMDRG
  assign_no_ct(
    raw_dat = cm_raw,
    raw_var = "CMDRG",
    tgt_var = "CMDRG",
    id_vars = oak_id_vars()
  ) %>%
  # Map CMDRGCD as the collected value in the cm_raw dataset CMDRGCD variable to CM.CMDRGCD
  assign_no_ct(
    raw_dat = cm_raw,
    raw_var = "CMDRGCD",
    tgt_var = "CMDRGCD",
    id_vars = oak_id_vars()
  ) %>%
  # Map CMDECOD as the collected value in the cm_raw dataset CMDECOD variable to CM.CMDECOD
  assign_no_ct(
    raw_dat = cm_raw,
    raw_var = "CMDECOD",
    tgt_var = "CMDECOD",
    id_vars = oak_id_vars()
  ) %>%
  # Map CMPNCD as the collected value in the cm_raw dataset CMPNCD variable to CM.CMPNCD
  assign_no_ct(
    raw_dat = cm_raw,
    raw_var = "CMPNCD",
    tgt_var = "CMPNCD",
    id_vars = oak_id_vars()
  )

## ----eval=TRUE, echo=FALSE----------------------------------------------------
sdtm.oak:::dataset_oak_vignette(
  cm,
  display_vars = exprs(
    oak_id, raw_source, patient_number, CMTRT, CMGRPID, CMDOSU, CMSTDTC,
    CMSTRTPT, CMSTTPT, CMDOSFRQ, CMMODIFY, CMINDC, CMENDTC, CMENRTPT, CMENTPT,
    CMDOS, CMDOSTXT, CMDOSU, CMDOSFRM, CMROUTE, CMPROPH, CMDRG, CMDRGCD,
    CMDECOD, CMPNCD
  )
)

## ----eval=TRUE----------------------------------------------------------------
cm <- cm %>%
  # The below mappings are applicable to all the records in the cm domain,
  # hence can be derived using mutate statement.
  dplyr::mutate(
    STUDYID = "test_study",
    DOMAIN = "CM",
    CMCAT = "GENERAL CONMED",
    USUBJID = paste0("test_study", "-", cm_raw$PATNUM)
  ) %>%
  # derive sequence number
  # derive_seq(tgt_var = "CMSEQ",
  #            rec_vars= c("USUBJID", "CMGRPID")) %>%
  derive_study_day(
    sdtm_in = .,
    dm_domain = dm,
    tgdt = "CMENDTC",
    refdt = "RFXSTDTC",
    study_day_var = "CMENDY"
  ) %>%
  derive_study_day(
    sdtm_in = .,
    dm_domain = dm,
    tgdt = "CMSTDTC",
    refdt = "RFXSTDTC",
    study_day_var = "CMSTDY"
  ) %>%
  # Add code for derive Baseline flag.
  dplyr::select("STUDYID", "DOMAIN", "USUBJID", everything())

## ----eval=TRUE, echo=FALSE----------------------------------------------------
sdtm.oak:::dataset_oak_vignette(
  cm,
  display_vars = exprs(
    oak_id, raw_source, patient_number, STUDYID, DOMAIN, USUBJID, CMGRPID,
    CMTRT, CMDOSU, CMSTDTC, CMSTRTPT, CMSTTPT, CMDOSFRQ, CMMODIFY, CMINDC,
    CMENDTC, CMENRTPT, CMENTPT, CMDOS, CMDOSTXT, CMDOSU, CMDOSFRM, CMROUTE,
    CMPROPH, CMDRG, CMDRGCD, CMDECOD, CMPNCD, CMSTDY, CMENDY
  )
)

