DROP PROCEDURE CPI.POPULATE_GEN_DASHBOARD_TABS;

CREATE OR REPLACE PROCEDURE CPI.Populate_Gen_Dashboard_Tabs IS

BEGIN

--to populate table of Production
Ext_Production;
Ext_Production_Loss;
Ext_Production_Acctng;
Ext_Disbursement;

--to populate tables of Distribution and Reinsurance
Ext_Distribution;
Ext_Reinsurance;

--to populate table of Renewals
Ext_Renewals;

--to populate tables of Losses
Ext_Losses;
Ext_Loss_Ratio;

COMMIT;

END;
/

DROP PROCEDURE CPI.POPULATE_GEN_DASHBOARD_TABS;
