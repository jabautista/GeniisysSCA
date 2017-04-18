//belle 08182011 
function checkPerilsWithBascPerl(tableGrid){
	var checkedPeril = tableGrid.getModifiedRows();
	var objArray 	 = tableGrid.geniisysRows;
	var saveChanges  = true;
	var checkedPerilName;
	var alliedPerils;

	for(var i=0; i<checkedPeril.length; i++){
		if(checkedPeril[i].groupTag == true ){
			if (checkedPeril[i].perilType == 'B'){
				alliedPerils = objArray.filter(function (obj){ return obj.bascPerlCd == checkedPeril[i].perilCd; });
				basicPerils  = objArray.filter(function (obj){ return obj.distSeqNo == checkedPeril[i].distSeqNo && obj.perilType == 'B'; });
			    checkedAlliedPerils = checkedPeril.filter(function (obj){ return obj.bascPerlCd == checkedPeril[i].perilCd && obj.groupTag == true;});
				checkedPerilName = checkedPeril[i].perilName;
				if (alliedPerils.length == checkedAlliedPerils.length){
					saveChanges = true;
					return saveChanges;
				}else{
					var alliedPerilName = null;
					var alliedCtr = 0;
								
					for (var x=0; x<alliedPerils.length; x++){			
						alliedCtr = 0;
						for (var y=0; y<checkedAlliedPerils.length; y++){
							if (alliedPerils[x].perilCd == checkedAlliedPerils[y].perilCd){
								alliedCtr++;
							}															
						}
						if(alliedCtr == 0){
							alliedPerilName = alliedPerils[x].perilName;
							showMessageBox(checkedPerilName + " is a basic peril that has an attached allied peril " +alliedPerilName+ " that must not be separated from it.", imgMessage.INFO);
							saveChanges = false;
							return saveChanges;
							break;
						}
					}
				}
		    }
			return saveChanges;
	    }			
	}
}