/**
 * Shows Process Expiring Policies
 * Module: GIEXS004- Tag Expired Policies for Renewal
 * @author Robert Virrey
 */
function showProcessExpiringPoliciesPage(){
		if (objGIEXExpiry.exitSw == "Y"){ //Added by Jerome Bautista 04.25.2016 SR 21993
			new Ajax.Updater("mainContents",contextPath+"/GIEXExpiriesVController",{
				parameters:{
					action: "showProcessExpiringPoliciesPage",
					intmNo: objGIEXExpiry.intmNo,
					intmName: objGIEXExpiry.intmName,
					claimSw: objGIEXExpiry.claimSw,
					balanceSw: objGIEXExpiry.balanceSw,
					rangeType: objGIEXExpiry.rangeType,
					range: objGIEXExpiry.range,
					fmDate: objGIEXExpiry.fmDate,
					toDate: objGIEXExpiry.toDate,
					fmMon: objGIEXExpiry.fmMon,
					fmYear: objGIEXExpiry.fmYear,
					toMon: objGIEXExpiry.toMon,
					toYear: objGIEXExpiry.toYear,
					lineCd: objGIEXExpiry.lineCd,
					sublineCd: encodeURIComponent(objGIEXExpiry.sublineCd),
					issCd: objGIEXExpiry.issCd,
					issueYy: objGIEXExpiry.issueYy,
					polSeqNo: objGIEXExpiry.polSeqNo,
					renewNo: objGIEXExpiry.renewNo,
					exitSw: objGIEXExpiry.exitSw
				},
				asynchronous: false,
				evalScripts: true,
				method: "GET",
				onComplete:function(response){
					expPolGrid._refreshList();
				}	
			});
		} else {
	new Ajax.Updater("mainContents", contextPath+"/GIEXExpiriesVController?action=showProcessExpiringPoliciesPage",{
		method:"GET",
		evalScripts:true,
		asynchronous: true,
		onCreate: showNotice("Loading Process Expiring Policies page, please wait..."),
		onComplete: function () {
			Effect.Appear($("mainContents").down("div", 0), {duration: .001}); 
			hideNotice("");
			setDocumentTitle("Tag Expired Policies for Renewal");
		}
	});
		}
}