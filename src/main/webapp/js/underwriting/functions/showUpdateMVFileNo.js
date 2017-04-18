/** Check if user has access to GIUTS032
 * Module: GIUTS032 - Update MV File Number
 * @author john dolon 09.26.2013
 */
function showUpdateMVFileNo(){
	try{
		new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
			parameters: {
				action : "showUpdateMVFileNo",
				moduleId : "GIUTS032"
			},
			evalScripts: true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showUpdateMVFileNo", e);
	}
}