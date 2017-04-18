/**
 * Shows Create RI Placement
 * Module: GIRIS001 - Create RI Placement 
 * @author Jerome Orio
 */
function showCreateRiPlacementPage(){
	try{
		if (nvl(objRiFrps.lineCd,null) == null 
				&& nvl(objRiFrps.frpsYy,null) == null 
				&& nvl(objRiFrps.frpsSeqNo,null) == null){
			if ($("lblModuleId").getAttribute("moduleid") != "GIRIS006"){
				//comment by Nok dahil meron ng Search button sa page..k.dot
				//showMessageBox("FRPS No. is null, please goto FRPS listing first.", "I");
			}else{
				//Comment out by Rod. 05/04/2012
				//showMessageBox("Please select any record first.", "I");
				
				//Added by Rod. 05/04/2012
				showMessageBox("Please select FRPS first.", "I");
				return false;
			}	
		}	
		Effect.Fade($("mainContents").down("div", 0), {
			duration: .001,
			afterFinish: function() {
				new Ajax.Updater("mainContents",contextPath+"/GIRIWFrpsRiController",{
					parameters:{
						action: 	"showCreateRiPlacementPage",
						lineCd:		objRiFrps.lineCd,
						frpsYy: 	objRiFrps.frpsYy,
						frpsSeqNo: 	objRiFrps.frpsSeqNo,
						module:	 	"GIRIS001"
					},
					asychronous: false,
					evalScripts: true,
					onCreate: retrievedDtlsGIRIS001 ? "" : showNotice("Getting Create RI Placement, please wait..."),
					onComplete: function(){
						hideNotice();
						if (checkErrorOnResponse(response)){
							initializeMenu();
							Effect.Appear($("mainContents").down("div", 0), {duration: .001}); //"mainContents"
						}	
					}	
				});
			}
		});
	}catch(e){
		showErrorMessage("showCreateRiPlacementPage", e);
	}	
}