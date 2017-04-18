/**
 * Observe Overlay for LOV Button
 * @author Jerome Orio
 */
function observeOverlayLovButton(id, onOkFunc){
	try{
		$("btnCancel"+id).observe("click", function(){
			hideOverlay();
		});	
		
		$("btnOk"+id).observe("click", function(){
			onOkFunc();
		});
	}catch(e){
		showErrorMessage("observeOverlayLovButton", e);
	}
}	