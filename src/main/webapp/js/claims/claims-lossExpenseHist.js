var objGICLItemPeril = [];
var objCurrGICLItemPeril = new Object();
var objGICLLossExpPayees = [];
var objCurrGICLLossExpPayees = new Object();
var objGICLClmLossExpense = [];
var objCurrGICLClmLossExpense = new Object();
var objGICLLossExpDtl = [];
var objCurrGICLLossExpDtl = new Object();
var objGICLLossExpDs = []; 
var objCurrGICLLossExpDs = new Object();
var objLossExpDeductibles = [];
var objCurrLossExpDeductibles = new Object();
var objGICLLossExpTax = [];
var objGICLLossExpBill = [];
var objCurrLoa = new Object();
var objCurrCsl = new Object();

var isGiclMortgExist = "N";
var fromClaimMenu = "N";
var payeeInsertSw = "N";
var clmLossExpInsertSw = "N";
var currLoaClmLossId = null;
var currCslClmLossId = null;
var lossExpHistWin;
var lossexpHistWin2;
var dedBaseAmtRequired = "Y"; // bonok :: 10.18.2012
var distSw;