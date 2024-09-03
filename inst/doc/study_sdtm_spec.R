## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
options(rmarkdown.html_vignette.check_title = FALSE)

## ----echo = FALSE, results = "asis"-------------------------------------------
library(knitr)
definition <- data.frame(
  Variable_Name = c(
    "study_number",
    "raw_source_model",
    "raw_dataset",
    "raw_dataset_ordinal",
    "raw_dataset_label",
    "raw_variable",
    "raw_variable_label",
    "raw_variable_ordinal",
    "raw_variable_type",
    "raw_data_format",
    "study_specific",
    "annotation_ordinal",
    "mapping_is_dataset",
    "annotation_text",
    "target_domain",
    "target_sdtm_variable",
    "target_sdtm_variable_role",
    "target_sdtm_variable_codelist_code",
    paste(
      "target_sdtm_variable_",
      "controlled_terms_or_format"
    ),
    "target_sdtm_variable_ordinal",
    "origin",
    "mapping_algorithm",
    "sub_algorithm",
    "target_hardcoded_value",
    "target_term_value",
    "condition_add_raw_dat",
    "condition_add_tgt_dat",
    "merge_type",
    "merge_left",
    "merge_right",
    "merge_condition",
    "unduplicate_keys",
    "groupby_keys"
  ),
  `Description_of_the_variable` = c(
    "Study Number",
    "Data Collection model",
    "Name of the raw or source dataset",
    "Ordinal of the raw dataset as defined in EDC or eDT specification",
    "Label of the raw or source dataset",
    "Name of the raw variable",
    "Label of the raw variable",
    paste(
      "Ordinal of the variable as defined in the eCRF or",
      "eDT specification"
    ),
    "Type of the Raw Variable",
    "Data format of the raw variable",
    paste(
      "`TRUE` indicates that the source is study specific. ",
      "`FALSE` indicates that the raw variable is part of data standards"
    ),
    "Ordinal of the SDTM mappings for the particular raw source",
    paste(
      "Indicates if the SDTM mapping is at the dataset level. ",
      "`TRUE` indicates that it is dataset level mapping."
    ),
    "SDTM mapping text or annotation text",
    "Name of the target domain.",
    "Name of the target SDTM variable",
    "CDISC Role for the SDTM target variable defined in the annotation.",
    paste(
      "NCI or sponsor code of the codelist assigned to the ",
      "SDTM target variable defined in the annotation."
    ),
    paste(
      "Controlled terms or format for the target variable ",
      "defined in the annotation (as defined per CDISC).",
      "`target_sdtm_variable_controlled_terms_or_format` is required ",
      "for SDTM Define.xml"
    ),
    "Ordinal of the target SDTM variable",
    "Origin of metadata source, values are subject to controlled terminology",
    "Mapping Algorithm",
    "The sub-algorithm (scenario) of the source-to-target mapping",
    "Text (Hardcoded value) that applies to the target.",
    paste(
      "CDISC Submission value or sponsor value which represents a",
      "hardcoded text"
    ),
    paste(
      "Condition that has to be applied at a raw dataset ",
      " before applying a mapping. Can be a valid R filter statement."
    ),
    paste(
      "Condition that has to be applied at a target dataset ",
      " before applying a mapping. Can be a valid R filter statement."
    ),
    "Specifies the type of join",
    "Specifies the left component of the merge",
    "Specifies the right component of the merge",
    paste(
      "Specify the condition of the join (e.g. a specific ",
      "variable that should match in the components of the merge)"
    ),
    paste(
      "Raw variables that should be used to determine whether ",
      "an observation in the source data is a duplicate record and ",
      "subject to being removed"
    ),
    paste(
      "Raw Variables or aggregation functions (i.e. earliest, ",
      "latest) to group source data records before mapping to SDTM"
    )
  ),
  Example_Values = c(
    "test_study",
    "e-CRF or eDT",
    "VTLS1, DEM",
    "1, 2, 3, etc",
    "Vital Signs,<br> Demographics",
    "SEX_001, <br> BRTHDD",
    "Systolic Blood Pressure,<br>Birth Day",
    "1, 2, 3, etc",
    "Text Box,<br> Date control",
    "$200,<br> dd MON YYYY",
    "TRUE, FALSE",
    "1, 2, 3, etc",
    "TRUE, FALSE",
    "VS.VSORRES when VSTESTCD = 'SYSBP'",
    "VS, MH",
    "VSORRES, MHSTDTC",
    "Topic Variable,<br>Grouping Qualifier,<br>Identifier Variable",
    "C66742<br>C66790",
    "(AGEU)<br>ISO 8601<br>(SEX)",
    "1, 2, 3",
    "Derived, <br>Assigned, <br>Collected, <br>Predecessor",
    "condition_add<br>assign_ct<br>ae_aerel<br>hardcode_ct",
    "assign_no_ct<br>hardcode_ct",
    "ALZHEIMER'S DISEASE HISTORY",
    "Y, <br>beats/min, <br>INFORMED CONSENT OBTAINED",
    paste(
      "Map qualifier CMSTRTPT  Annotation text is If MDPRIOR == 1  ",
      "then CM.CMSTRTPT = 'BEFORE'",
      "raw_dat parameter as condition_add(cm_raw, MDPRIOR == 1)"
    ),
    paste(
      "Map qualifier CMDOSFRQ  Annotation text is If CMTRT is not null",
      " then map  the collected value in raw dataset cm_raw and",
      "raw variable MDFRQ to CMDOSFRQ",
      "tgt_dat parameter as  condition_add(., !is.na(CMTRT))"
    ),
    "left_join<br>right_join<br>full_join<br>visit_join<br>subject_join",
    "VTLS1",
    "VACREC",
    "VTLS1.SUBJECT = VACREC.SUBJECT,<br>MD1.MDNUM = VACREC.MDNUM",
    "VTLS1.SUBJECT,<br>VTLS1.DATAPAGEID",
    "TXINF1.DATAPGID, <br>Earliest"
  ),
  Association_with_mapping_Algorithms = c(
    "Generic Use",
    "Generic Use",
    "Required for all mapping algorithms",
    "Generic Use",
    "Generic Use",
    "Generic Use",
    "Generic Use",
    "Generic Use",
    "Required for all mapping algorithms",
    "Required for all mapping algorithms",
    "Generic Use",
    "Required for all mapping algorithms",
    "Required for all mapping algorithms",
    "Generic Use",
    "Required for all mapping algorithms",
    "Required for all mapping algorithms",
    "Required for all mapping algorithms",
    "Required for all mapping algorithms",
    "Generic Use",
    "Required for all mapping algorithms",
    "Used for define.xml",
    "Required for all mapping algorithms",
    "Only when Mapping Algorithm is <br>condition_add<br>dataset_level",
    "assign_no_ct<br>hardcode_no_ct",
    "harcode_ct",
    "condition_add",
    "condition_add",
    "MERGE",
    "MERGE",
    "MERGE",
    "MERGE",
    "REMOVE_DUP",
    "GROUP_BY"
  ),
  stringsAsFactors = TRUE
)
knitr::kable(definition)

