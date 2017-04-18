/**
 * Show Generate Reinsurance Reports Main page
 * Module: GIRIS051 - Generate Reinsurance Reports
 * @author Shan Bati
 * @date  01.15.2013
 * 
 */
function showGenerateRIReportsPage(){
	new Ajax.Updater("mainContents", contextPath+"/GIRIGenerateRIReportsController?action=showGenerateRIReportsPage",{
		method: "GET",
		parameters: {
			tabAction: "binderTab"
		},
		evalScripts: true,
		asynchronous: true,
		onCreate:  showNotice("Loading, please wait..."),
		onComplete: function(response){
			hideNotice("");
			if(checkErrorOnResponse(response)){
				objRiReports.local_curr = $F("defaultCurrencyGIRIS051");			
				$("chkNbtGrp").disable();
				$("chkReversed").disable();
				$("chkReplaced").disable();
				$("chkNegated").disable();
				$("chkLocalCurrency").disable();
				$("chkPrNtcTD").hide();
				$("selPrintOption").hide();
				objRiReports.giriBinder = null;
				objRiReports.giriGroupBinder = null;
				
				if($("allowSetPerilAmtForPrnt").value == "Y"){
					$("perilDtlsTbl").show();					
				}else {
					$("chkPrntPerilDet").value = "N";
					$("perilDtlsTbl").hide();
				}
				
				objRiReports.riSignatory.name = null;
				objRiReports.riSignatory.designation = null;
				objRiReports.riSignatory.attest = null;
				objRiReports.riSignatory.nbtTag = 0;
			}
		}
	});
}