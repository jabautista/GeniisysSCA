DROP PROCEDURE CPI.WHEN_CRE_REC_B_B540_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.When_Cre_Rec_B_B540_Gipis002
   (b240_line_cd IN VARCHAR2,
    b540_pack_pol_flag OUT VARCHAR2,
    b240_assd_no IN NUMBER,
    b540_nbt_ind_desc OUT VARCHAR2,
    b540_industry_cd OUT NUMBER,
    b240_iss_cd IN VARCHAR2,
    b540_nbt_region_desc OUT VARCHAR2,
    b540_region_cd OUT NUMBER,
    var_display_def_cred_branch OUT VARCHAR2,
    variables_def_cred_branch IN VARCHAR2,
    b540_dsp_cred_branch OUT VARCHAR2,
 b540_cred_branch OUT VARCHAR2,
    b540_takeup_term OUT VARCHAR2,
    variables_dflt_takeup_term IN VARCHAR2,
    b540_dsp_takeup_term_desc OUT VARCHAR2,
    var_dflt_takeup_term_desc IN VARCHAR2) IS 
BEGIN
  FOR A IN (SELECT   pack_pol_flag 
              FROM   GIIS_LINE
             WHERE   line_cd  =  b240_line_cd) 
  LOOP
    b540_pack_pol_flag :=  A.pack_pol_flag;
    EXIT;
  END LOOP;

/* default values for industry and region --jpc 08/02/2001*/
  FOR j IN (SELECT industry_nm, industry_cd
      FROM GIIS_INDUSTRY
     WHERE industry_cd = (SELECT industry_cd 
         FROM GIIS_ASSURED 
            WHERE assd_no = b240_assd_no))
  LOOP
 b540_nbt_ind_desc := j.industry_nm;
 b540_industry_cd := j.industry_cd;
 EXIT;
  END LOOP;

  FOR X IN (SELECT region_desc, region_cd
     FROM GIIS_REGION
    WHERE region_cd = (SELECT region_cd 
          FROM GIIS_ISSOURCE
          WHERE iss_cd = b240_iss_cd))
  LOOP
 b540_nbt_region_desc := X.region_desc;
 b540_region_cd := X.region_cd;
   EXIT;
  END LOOP;
--grace 01-27-2003
--to populate crediting branch
--if parameter is based on AGENT, 
--crediting branch will be populated after entering the intermediary 

--grace 02.09.2005
--added check if a default crediting branch will be supplied
  FOR X IN (SELECT c.param_value_v cp
              FROM GIIS_PARAMETERS c
             WHERE c.param_name = 'DISPLAY_DEF_CRED_BRANCH')
  LOOP
    var_display_def_cred_branch := X.cp;
    EXIT;
  END LOOP;
  IF variables_def_cred_branch = 'ISS_CD' AND var_display_def_cred_branch = 'Y' THEN
    FOR var IN (SELECT iss_name
               FROM GIIS_ISSOURCE
              WHERE iss_cd = b240_iss_cd)
 LOOP
   b540_dsp_cred_branch := var.iss_name;
   b540_cred_branch := b240_iss_cd;
   EXIT;
 END LOOP;
  END IF;
 --Vincent 11162007: populate takeup_term with default value
  b540_takeup_term := variables_dflt_takeup_term;
  b540_dsp_takeup_term_desc := var_dflt_takeup_term_desc;
END;
/


