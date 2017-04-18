/**
 * Shows Generate Package Binders page
 * Module: GIRIS053A - Generate Package Binders
 * @author Niknok Orio 
 * @since 01.04.12
 */
function showGeneratePackageBinders(lineCd, issCd){
	try{
		Effect.Fade($("mainContents").down("div", 0), {
			duration: .001,
			afterFinish: function() {
				new Ajax.Updater("mainContents",contextPath+"/GIPIPackPolbasicController",{
					parameters:{
						action: 	"showGeneratePackageBinders",
						lineCd:		nvl(lineCd,""),
						issCd: 		nvl(issCd,""), 
						moduleId:	"GIRIS053A"
					},
					asychronous: false,
					evalScripts: true,
					onCreate: showNotice("Getting Package Binders, please wait..."),
					onComplete: function(){
						if (checkErrorOnResponse(response)){ 
							initializeMenu();
							Effect.Appear($("mainContents").down("div", 0), {duration: .001});  
						}	
					}	
				});
			}
		});
	}catch(e){
		showErrorMessage("showGeneratePackageBinders", e);
	}	

}