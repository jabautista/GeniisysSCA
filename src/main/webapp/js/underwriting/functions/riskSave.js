//Apollo Cruz 10.21.2014 - Added postFunc parameter to execute functions properly after saving.
function riskSave(postFunc){
	try{ 
		
		//Apollo 10.22.2014
		var obj = JSON.parse(objGIPIS901.riskObjParams.setRows);
		var hasRange = true;
		var newRecord = false;	//Gzelle 03302015
		for(var x = 0; x < obj.length; x++){
			if (obj[x].recordStatus == 1) {	//Gzelle 03302015
				newRecord = true;
			}
			if(obj[x].rangeFrom == undefined){
				hasRange = false;
				break;
			}
		}
		
		if(!hasRange && !newRecord && !objGIPIS901.dupRecord && !objGIPIS901.addFromUpdate){ //Gzelle 03302015
		//if(!hasRange){
			showMessageBox("All Risk Profile must have at least one record in Range of Sum Insured before saving.", "I");
			return;
		}
		
		new Ajax.Request(contextPath+"/GIPIGenerateStatisticalReportsController?action=riskSave",{
			parameters:	{
				parameters: JSON.stringify(objGIPIS901.riskObjParams),
				detailSw:	objGIPIS901.changeTagDetail == 1? 'Y' : 'N',
				userResponse: objGIPIS901.userResponse,
				isAddFromUpdate: objGIPIS901.addFromUpdate == true ? 'Y' : 'N'
			}, 
			onCreate: showNotice("Saving risk profile, please wait..."),
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					objGIPIS901.riskObjParams.setRows = null;
					objGIPIS901.riskObjParams.delRows = null;
					changeTag = 0;
					objGIPIS901.changeTagDetail = 0;
					objGIPIS901.dupRecord = false;	//Gzelle 03302015
					objGIPIS901.addFromUpdate = false;
					showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
						if(postFunc != null)
							postFunc();
					});	
				}
			}
		});
		
	}catch(e){
		showErrorMessage("riskSave", e);
	}
}