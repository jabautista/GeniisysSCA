// Reinsurance Global Variables
var frpsTableGrid;
var objRiFrps = new Object();
objRiFrps.lineCd = null;
objRiFrps.lineName = null;
objRiFrps.frpsYy = null;
objRiFrps.frpsSeqNo = null;
objRiFrps.riSeqNo = null;
objRiFrps.loadFromGIRIS002 = null;	//Gzelle 10.21.2013
objRiFrps.cancelGIRIS002 = false;	//Gzelle 10.21.2013

var retrievedDtlsGIRIS001 = false;

// == RI Reports global variables shan 01.16.2013 ==
var objRiReports = {};
objRiReports.lineCd = null;
objRiReports.binderYy = null;
objRiReports.binderSeqNo = null;
objRiReports.local_curr = null;
objRiReports.oldFnlBinderId = null;
objRiReports.fnlBinderId = null;
objRiReports.valid = null;
objRiReports.perilDtls_changed = false;

//for GIRIS051 RI Signatory window
objRiReports.riSignatory = {};
objRiReports.riSignatory.name = null;
objRiReports.riSignatory.designation = null;
objRiReports.riSignatory.attest = null;
objRiReports.riSignatory.nbtTag = 0;

/*Switch used to identify what type of report was called to print (GIRIS051)*/
/* 1 for exposure, 2 for weekly/monthly production report, and so on ...   01.30.2013*/
objRiReports.rep_type_sw = null;	

//for GIRIS051 Outstanding tab 01.30.2013
objRiReports.oar = {};
objRiReports.oar.reports = [];

// == shan ==

var riAcceptSearch = "Y";
var selectedFrpsRiRow;
var objGIRIPackWInPolbas = {}; // for ri package par - irwin 5.29.2012