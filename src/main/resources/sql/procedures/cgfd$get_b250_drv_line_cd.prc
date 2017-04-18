DROP PROCEDURE CPI.CGFD$GET_B250_DRV_LINE_CD;

CREATE OR REPLACE PROCEDURE CPI.CGFD$GET_B250_DRV_LINE_CD(
   P_DRV_LINE_CD OUT VARCHAR2      /* Item being derived */
  ,P_SUBLINE_CD  IN     VARCHAR2      /* Item value         */
  ,P_RENEW_NO    IN     NUMBER        /* Item value         */
  ,P_POL_SEQ_NO  IN     NUMBER        /* Item value         */
  ,P_LINE_CD     IN     VARCHAR2      /* Item value         */
  ,P_ISS_CD      IN     VARCHAR2      /* Item value         */
  ,P_ISSUE_YY    IN     NUMBER  ) IS  /* Item value         */
/* This derives the value of a base table item based on the */
/* values in other base table items.                        */
BEGIN
P_DRV_LINE_CD :=
  P_LINE_CD || ' - ' || P_SUBLINE_CD || ' - ' ||
  P_ISS_CD || ' - ' || to_char(P_ISSUE_YY, '09')
  || ' - ' || to_char(P_POL_SEQ_NO, '0999999') ||' - ' || to_char(P_RENEW_NO,'09');
END;
/


