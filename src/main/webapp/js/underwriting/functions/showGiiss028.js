/**
 * Shows Tax Charge Maintenance Page
 * Module: GIISS028 - Maintain Tax Charges
 * @author Kenneth Mark Labrador
 * */
function showGiiss028(){
	try{ 
		new Ajax.Request(contextPath+"/GIISTaxChargesController", {
			parameters: {
				action : "showGiiss028"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function (response)	{
				hideNotice();
				$("mainContents").update(response.responseText);
			}
		});		
	}catch(e){
		showErrorMessage("showGiiss028",e);
	}	
}