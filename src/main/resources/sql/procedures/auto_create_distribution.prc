DROP PROCEDURE CPI.AUTO_CREATE_DISTRIBUTION;

CREATE OR REPLACE PROCEDURE CPI.AUTO_CREATE_DISTRIBUTION
(P_DIST_NO             GIUW_POL_DIST.dist_no%type,
 P_LINE_CD             GIPI_POLBASIC.line_cd%type,
 P_POLICY_ID           GIPI_POLBASIC.policy_Id%type,
 P_ITEM_GRP            GIPI_ITEM.item_grp%type )
IS

V_DIST_SEQ_NO          GIUW_POLICYDS.dist_seq_no%type:= P_ITEM_GRP;
V_SHARE_CD             GIIS_PARAMETERS.param_value_n%type;
V_DIST_SPCT            GIUW_POLICYDS_DTL.dist_spct%type:=100;
GIUW_PARENT_INSERT     VARCHAR2(1):= 'N';  -- USED FOR MONITOR INSERTIONS IN GIUW_PERILDS/ITEMDS/ITEMPERILDS

CURSOR SHR_CD IS
   SELECT PARAM_VALUE_N
   FROM GIIS_PARAMETERS
   WHERE PARAM_NAME LIKE 'NET_RETENTION';

CURSOR PERILDS IS
   SELECT B.POLICY_ID, B.LINE_CD, B.PERIL_CD, SUM(B.TSI_AMT) TSI_AMT, SUM(B.PREM_AMT) PREM_AMT
   FROM GIPI_ITEM  A,  GIPI_ITMPERIL  B
   WHERE 1=1
   AND   B.POLICY_ID = P_POLICY_ID
   AND   B.LINE_CD = P_LINE_CD
   AND   A.ITEM_GRP = P_ITEM_GRP
   AND   A.ITEM_NO = B.ITEM_NO
   AND   A.POLICY_ID = B.POLICY_ID
   GROUP BY B.POLICY_ID, B.LINE_CD, B.PERIL_CD  ;

CURSOR POLICYDS IS
   SELECT A.ITEM_GRP, SUM(A.TSI_AMT) TSI_AMT, SUM(A.PREM_AMT) PREM_AMT
   FROM GIPI_ITEM  A
   WHERE 1=1
   AND   A.POLICY_ID = P_POLICY_ID
   AND   A.ITEM_GRP = P_ITEM_GRP
   GROUP BY A.ITEM_GRP ;

CURSOR ITEMDS IS
   SELECT A.ITEM_NO, SUM(A.TSI_AMT) TSI_AMT, SUM(A.PREM_AMT) PREM_AMT
   FROM GIPI_ITEM  A
   WHERE 1=1
   AND   A.POLICY_ID = P_POLICY_ID
   AND   A.ITEM_GRP = P_ITEM_GRP
   GROUP BY A.ITEM_NO ;

CURSOR ITEMPERILDS IS
   SELECT B.POLICY_ID, B.ITEM_NO, B.LINE_CD, B.PERIL_CD, SUM(B.TSI_AMT) TSI_AMT, SUM(B.PREM_AMT) PREM_AMT
   FROM GIPI_ITEM  A,  GIPI_ITMPERIL  B
   WHERE 1=1
   AND   B.POLICY_ID = P_POLICY_ID
   AND   B.LINE_CD = P_LINE_CD
   AND   B.ITEM_NO = A.ITEM_NO
   AND   A.ITEM_GRP = P_ITEM_GRP
   AND   B.POLICY_ID = A.POLICY_ID
   GROUP BY B.POLICY_ID, B.ITEM_NO, B.LINE_CD, B.PERIL_CD ;

BEGIN
  FOR JA1 IN SHR_CD LOOP
    V_SHARE_CD  :=  JA1.PARAM_VALUE_N;
  END LOOP;
  
  --mikel 06.13.2016; GENQA 5544
  BEGIN
    DELETE FROM giuw_policyds
          WHERE dist_no = p_dist_no;
    
    DELETE FROM giuw_policyds_dtl
          WHERE dist_no = p_dist_no;
    
    DELETE FROM giuw_perilds
          WHERE dist_no = p_dist_no;
    
    DELETE FROM giuw_perilds_dtl
          WHERE dist_no = p_dist_no;
          
    DELETE FROM giuw_itemds
          WHERE dist_no = p_dist_no;
    
    DELETE FROM giuw_itemds_dtl
          WHERE dist_no = p_dist_no;
          
    DELETE FROM giuw_itemperilds
          WHERE dist_no = p_dist_no;
    
    DELETE FROM giuw_itemperilds_dtl
          WHERE dist_no = p_dist_no;
    
    COMMIT;                                    
  END;
  --end mikel 06.13.2016

  FOR JA1 IN POLICYDS LOOP
    /* the tsi amt per peril is the whole tsi_amt in gipi_polbasic (basic perils only)*/
    insert into giuw_policyds
    (DIST_NO           ,DIST_SEQ_NO       ,TSI_AMT              ,PREM_AMT       ,ITEM_GRP,
     ANN_TSI_AMT       ,CPI_REC_NO        ,CPI_BRANCH_CD        )
    values
    (P_DIST_NO         ,V_DIST_SEQ_NO     ,JA1.TSI_AMT          ,JA1.PREM_AMT   ,P_ITEM_GRP,
     JA1.TSI_AMT       ,NULL       	     ,NULL                 );
    insert into giuw_policyds_dtl
    (DIST_NO           ,DIST_SEQ_NO       ,LINE_CD              ,SHARE_CD       ,DIST_TSI,
     DIST_PREM         ,DIST_SPCT         ,DIST_SPCT1           ,ANN_DIST_SPCT  ,ANN_DIST_TSI,
     DIST_GRP          ,CPI_REC_NO        ,CPI_BRANCH_CD        )
    values
    (P_DIST_NO         ,V_DIST_SEQ_NO     ,P_LINE_CD            ,V_SHARE_CD     ,JA1.TSI_AMT,
     JA1.PREM_AMT      ,V_DIST_SPCT       ,NULL                 ,V_DIST_SPCT    ,JA1.TSI_AMT,
     P_ITEM_GRP        ,NULL              ,NULL                 );
  END LOOP JA1;
  /* the TSI_AMT per peril is the total tsi_amt in gipi_itmperil                           */
  /* the PREMIUM_AMT is the sum of gipi_itmperil per peril per group                       */
  FOR JA1 IN PERILDS LOOP
    /* insertion for both giuw_perilds and giuw_perilds_dtl are done simultaneously because there */
    /* is only one distribution for this procedure ( all are distributed full NET RET             */
    insert into giuw_perilds
    (DIST_NO           ,DIST_SEQ_NO       ,PERIL_CD             ,LINE_CD        ,TSI_AMT,
     PREM_AMT          ,ANN_TSI_AMT       )
    values
    (P_DIST_NO         ,V_DIST_SEQ_NO     ,JA1.PERIL_CD         ,P_LINE_CD      ,JA1.TSI_AMT,
     JA1.PREM_AMT      ,JA1.TSI_AMT       );
    insert into giuw_perilds_dtl
    (DIST_NO           ,DIST_SEQ_NO 	    ,PERIL_CD       	     ,LINE_CD         ,SHARE_CD,
     DIST_TSI          ,DIST_PREM    	    ,DIST_COMM_AMT          ,DIST_SPCT      ,DIST_SPCT1,
     ANN_DIST_SPCT     ,ANN_DIST_TSI      ,DIST_GRP              )
    values
    (P_DIST_NO         ,V_DIST_SEQ_NO     ,JA1.PERIL_CD          ,P_LINE_CD       ,V_SHARE_CD,
     JA1.TSI_AMT       ,JA1.PREM_AMT      ,NULL                  ,V_DIST_SPCT     ,NULL,
     V_DIST_SPCT       ,JA1.TSI_AMT       ,P_ITEM_GRP             );
  END LOOP JA1;

  FOR JA1 IN ITEMDS LOOP
    /* TSI_AMTs are composed of basic peril types only for both giuw_itemds and giuw_itemds_dtl */
    /* TSI_AMTs for gipi_item is composed of basic peril types only while in gipi_itmperil,     */
    /* both peril and basic types are included                                                  */
    insert into giuw_itemds
    (DIST_NO           ,DIST_SEQ_NO       ,ITEM_NO              ,TSI_AMT        ,PREM_AMT,
     DISPLAY_SW        ,ANN_TSI_AMT       ,CPI_REC_NO           ,CPI_BRANCH_CD  )
    values
    (P_DIST_NO         ,V_DIST_SEQ_NO     ,JA1.ITEM_NO          ,JA1.TSI_AMT    ,JA1.PREM_AMT,
     NULL              ,JA1.TSI_AMT       ,NULL                 ,NULL  );
    insert into giuw_itemds_dtl
    (DIST_NO            ,DIST_SEQ_NO      ,ITEM_NO              ,LINE_CD        ,SHARE_CD,
     DIST_SPCT          ,DIST_SPCT1       ,DIST_TSI             ,DIST_PREM      ,ANN_DIST_SPCT,
     ANN_DIST_TSI       ,DIST_GRP         ,CPI_REC_NO           ,CPI_BRANCH_CD  )
    values
    (P_DIST_NO          ,V_DIST_SEQ_NO    ,JA1.ITEM_NO          ,P_LINE_CD      ,V_SHARE_CD,
     V_DIST_SPCT        ,NULL             ,JA1.TSI_AMT          ,JA1.PREM_AMT   ,V_DIST_SPCT,
     JA1.TSI_AMT        ,P_ITEM_GRP       ,NULL                 ,NULL           );
  END LOOP JA1;
  FOR JA1 IN ITEMPERILDS LOOP
    /* TSI AMTs are composed of basic and allied peril types for both itemperilds/itemperilds_dtl */
    insert into giuw_itemperilds
    (DIST_NO        	,DIST_SEQ_NO      ,ITEM_NO                 ,PERIL_CD       ,LINE_CD,
     TSI_AMT           ,PREM_AMT         ,ANN_TSI_AMT             ,CPI_REC_NO     ,CPI_BRANCH_CD)
    values
    (P_DIST_NO         ,V_DIST_SEQ_NO    ,JA1.ITEM_NO            ,JA1.PERIL_CD   ,P_LINE_CD,
     JA1.TSI_AMT       ,JA1.PREM_AMT     ,JA1.TSI_AMT            ,NULL           ,NULL );
    insert into giuw_itemperilds_dtl
    (DIST_NO            ,DIST_SEQ_NO      ,ITEM_NO              ,PERIL_CD       ,LINE_CD,
     SHARE_CD           ,DIST_TSI         ,DIST_PREM            ,DIST_COMM_AMT  ,DIST_SPCT,
     DIST_SPCT1         ,ANN_DIST_SPCT    ,ANN_DIST_TSI         ,DIST_GRP       ,CPI_REC_NO,
     CPI_BRANCH_CD      )
    values
    (P_DIST_NO          ,V_DIST_SEQ_NO    ,JA1.ITEM_NO          ,JA1.PERIL_CD   ,P_LINE_CD,
     V_SHARE_CD         ,JA1.TSI_AMT      ,JA1.PREM_AMT         ,NULL           ,V_DIST_SPCT,
     NULL               ,V_DIST_SPCT      ,JA1.TSI_AMT          ,P_ITEM_GRP     ,NULL,
     NULL               );
  END LOOP JA1;
  UPDATE GIUW_POL_DIST
  SET DIST_FLAG = '1' --mikel 06.13.2016; GENQA 5544
  WHERE DIST_NO = P_DIST_NO
  AND POLICY_iD = P_POLICY_iD;
END;
/


