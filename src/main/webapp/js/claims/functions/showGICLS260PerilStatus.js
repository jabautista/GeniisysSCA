/**
 * Shows the peril status listing used by GICLS260
 * @author Veronica V. Raymundo
 * @param lineCd
 * @param itemNo
 * 
 */
function showGICLS260PerilStatus(lineCd, itemNo){
	try{
		if(nvl(itemNo, "") == ""){
			showMessageBox("Please select an item first.", "I");
			return false;
		}
		
		overlayPerilStat = Overlay.show(contextPath+"/GICLItemPerilController", {
			urlContent: true,
			urlParameters: {action : "getGICLS260PerilStatus",
							claimId : objCLMGlobal.claimId,
							lineCd: lineCd,
							itemNo: itemNo,
							ajax: 1},
			title: "Peril Status",	
			id: "peril_stat_canvas",
			width: 835,
			height: 290,
			showNotice: true,
		    draggable: false,
		    closable: true
		});
		
	}catch(e){
		showErrorMessage("showGICLS260PerilStatus",e);
	}
}