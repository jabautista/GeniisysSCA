// JSON objects

 /*  0 : new added object
 *  1 : modified object
 * -1 : deleted object
 *  2 : copied object
**/

/*	Modified by		: bjga 09.27.2010
 * 	Modification	: basic PAR item screen objects
 */
var objGIPIWItemPeril 	= null;
var objGIPIWItem		= []; 
var objGIPIWPolWC		= null;
var objGIISPerilClauses = null;
var objGIISPeril = null;
var objGIISPackPlanPeril = null;	//added by Gzelle 09102014
var objDefaultPerilAmts = new Object();	//added by Gzelle 11262014
var objEndtMNItems;
var objPolbasics;
var objDeductibles = null;
var objItems = null;
var objGIPIItemPeril = null;
var objPerilWCs	= null;
var objPolicyWCs = null;
var objCargoCarriers = null;
var objCurrCargoCarrier = null;
var objCurrItemPeril;
var objCurrDeductible;
var objEndtENItems = null;

/*	Modified by		: mark jm 09.27.2010
 * 	Modification	: added the following variables
 */
var objEndtCAItems;
var objEndtCAPersonnels;
var objEndtGroupedItems;
var objCurrEndtItem;
var objFormVariables;
var objFormParameters;
var objFormMiscVariables;
var objItemNoList;
var objParPolbas;
var objMortgagees;
var objCurrItem;
var objGIPIWPerilDiscount;
var objGIPIWItemDiscount;
var objGIPIWPolbasDiscount;
var objGIPIWMcAcc;
var objGIPIWGroupedItems;
var objGIPIWCasualtyPersonnel;
var objGIPIWCargo;
var objBeneficiaries = null; 
var objGIPIWVesAir;
var objGIPIWVesAccumulation;
var objGIPIWCargoCarrier;
var objGIPIParList;
var objGIPIWPackageInvTax;
var objGIPIWCommInvPerils;
var objGIPIWCommInvoices;
var objGIPIWInvoice;
var objGIUWPolDist;
var objGIUWWPerilds;
var objGIUWWPerildsDtl;
var objEndtMHItems;
var formMap;
var objCurrGIPIPolbasic;
var objGIPIWItmperlGrouped;
var objGIPIWGrpItemsBeneficiary;
var objGIPIWItmperlBeneficiary;

var overlayAccidentGroup;
var overlatAccidentRetrieveGroupedItems;
var overlayAccidentPopulateBenefits;
var overlayUploadEnrollees;

//added by BJGA 01.17.2011
var objGIPIWItemWGroupedPeril = null;

// mark jm 07.22.2011 variables used in converting to table grid
var objItemTempStorage = null;
var tbgItemTable = null;
var tbgPolicyDeductible = null;
var tbgItemDeductible = null;
var tbgPerilDeductible = null;
var tbgItemPeril = null;
var tbgMortgagee = null;
var tbgAccessory = null;
var tbgGroupedItems = null;
var tbgCasualtyPersonnel = null;
var tbgCargoCarriers = null;
var tbgBeneficiary = null;
var tbgGrpItemsBeneficiary = null;
var tbgItmperlBeneficiary = null;
var tbgItmperlGrouped = null;
var tbgPopulateBenefits = null;
var tbgUploadEnrollees = null;
var tbgUploadDetails = null;
var tbgErrorLog = null;

var databaseName = "";
var lastAction = null; // mark jm 12.16.2011 storage for last function (navigating to other page while there is a pending changes to save)

var endtPackTableGrid = null;

var updateMinPremFlag = "N";
var minPremFlag = "";
var globalNegate = "N"; //edgar 01/21/2015
var objMapNegate; //edgar 01/21/2015

var overlayAddDeleteItem = null; // andrew - 05.10.2011

var itemPerilExist;
var itemPerilGroupedExist;
var objWItmperlGrouped;
var objWGrpItemBen;
var objWItmPerilBen;
var itemTsi;