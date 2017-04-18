CREATE OR REPLACE PACKAGE CPI.giclr204d_pkg
AS
/*
** Created by   : Paolo J. Santos
** Date Created : 08.01.2013
** Reference By : giclr204d
** Description  : Lost Ratio By Intermediary */
   TYPE giclr204d_record_type IS RECORD (
      intm_no                 NUMBER (12),
      loss_ratio_date         DATE,
      curr_prem_amt           NUMBER (16, 2),
      prem_res_cy             NUMBER (16, 2),
      prem_res_py             NUMBER (16, 2),
      loss_paid_amt           NUMBER (16, 2),
      curr_loss_res           NUMBER (16, 2),
      prev_loss_res           NUMBER (16, 2),
      premiums_earned         NUMBER (16, 2),
      losses_incurred         NUMBER (16, 2),
      ref_intm_cd             VARCHAR2 (10 BYTE),
      intm_name               VARCHAR2 (240 BYTE),
      p_assd_no               NUMBER (20),
      p_intm_no               NUMBER (12),
      p_iss_cd                VARCHAR2 (2),
      p_line_cd               VARCHAR2 (2),
      p_session_id            NUMBER (38),
      p_subline_cd            VARCHAR2 (7),
      pjs                     VARCHAR2 (1),
      cf_assd_name            VARCHAR2 (520),
      cf_1                    VARCHAR2 (50),
      cf_company_name         VARCHAR2 (200),
      cf_company_address      VARCHAR2 (500),
      cf_line_name            VARCHAR2 (30),
      cf_subline_name         VARCHAR2 (30),
      cf_iss_name             VARCHAR2 (30),
      cf_intm_name            VARCHAR2 (240),
      cf_overall_loss_ratio   NUMBER (16, 2),
      p_date                  DATE,
      cf_ref_no               VARCHAR2 (30),
      cf_loss_ratio           NUMBER (16, 2)
     
   );

   TYPE giclr204d_record_tab IS TABLE OF giclr204d_record_type;
   
   FUNCTION cf_overall_loss_ratio(
      p_losses_incurred       NUMBER,
      p_premiums_earned       NUMBER
   ) RETURN NUMBER;

   FUNCTION get_giclr204d_record (
      p_session_id   NUMBER,
      p_date         VARCHAR2,
      p_assd_no      NUMBER,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_intm_no      NUMBER
   )
      RETURN giclr204d_record_tab PIPELINED;
END;
/


