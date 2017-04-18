//by bonok :: GIUTS008A :: 06.13.2012
// modified :: 02.21.2013
function checkUserAccessGiuts(moduleId){
	new Ajax.Request(contextPath+"/GIISUserController",{
		parameters: {
			action : "checkUserAccessGiuts",
			moduleId : moduleId
		},
		evalScripts: true,
		asynchronous: true,
		onComplete: function(response) {
			if(response.responseText == 1){
				if(moduleId == "GIUTS008A"){
					showCopyPackagePolicy();
				}else if(moduleId == "GIUTS003"){
					showSpoilPostedPolicy();
				}else if(moduleId == "GIUTS003A"){	//added by shan 02.22.2013
					showSpoilPostedPackagePolicy();
				}else if(moduleId == "GIUTS028"){   //added by jomsdiago 07.25.2013
					showGIUTS028();
				}else if(moduleId == "GIUTS028A"){  //added by jomsdiago 07.29.2013
					showGIUTS028A();
				}else if(moduleId == "GIUTS012"){   //added by jomsdiago 08.13.2013
					showGIUTS012();
				}
			}else{
				showMessageBox("You are not allowed to access this module.", "E");
			}
		}
	});
}