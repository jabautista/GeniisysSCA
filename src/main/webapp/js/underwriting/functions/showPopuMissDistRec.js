/**
 * Show Populate Missing Distribution Records (GIUTS999) 
 * @author niknok orio
 * @since 08.10.2011
 */
function showPopuMissDistRec(){
	new Ajax.Updater("mainContents", contextPath+"/GIPIPolbasicPolDistV1Controller?action=showPopuMissDistRec", {
		asynchronous: false,
		evalScripts: true,
		onCreate: function(){
			showNotice("Getting Populate Missing Distribution Records...");
		},
		onComplete: function(response){
			if (checkErrorOnResponse(response)){	
				hideNotice();
			}	
		}	
	});
}