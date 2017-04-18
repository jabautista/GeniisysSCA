//belle 08162011 validation of basic and allied peril before changing the group.
function checkAttachedPeril(tableGrid){
	var checkedPeril = tableGrid.getModifiedRows();
	var objArray 	 = tableGrid.geniisysRows;
	var saveChanges  = checkPerilsWithBascPerl(tableGrid);
	var checkedPerilName;
	var alliedPerils;
	checkedBascPerils = checkedPeril.filter(function(obj){return obj.perilType == 'B' && obj.groupTag == true;});
	if (checkedBascPerils.length > 0){
		checkPerilsWithBascPerl(tableGrid);
		if (saveChanges == true) {
			var saveChanges2 = checkAlliedPerilsWithBascPerl (tableGrid) ;
			if (saveChanges2 == true) {
				if ("N" == $F("btnSwitch")){
					includeToNewGrpDistr2(giuwwPerildsTableGrid);
				}else {
					joinGroupDist(giuwwPerildsTableGrid);
					joinGroupTag = 1 ; // added by jhing 12.05.2014
				}				
			}
		}
	}else{
		for(var i=0; i<checkedPeril.length; i++){
			if(checkedPeril[i].groupTag == true ){
				if (checkedPeril[i].perilType == 'A' && checkedPeril[i].bascPerlCd != null){
					checkedPerilName  =  checkedPeril[i].perilName;
					bascPerlName 	  =  objArray.filter(function(obj){ return obj.perilCd == checkedPeril[i].bascPerlCd; })[0].perilName
					showMessageBox(checkedPerilName + " is an attached allied peril and must not be separated from its basic peril " +bascPerlName, imgMessage.INFO);
					saveChanges = false;
				}else{
					if (saveChanges == true) {
						if ("N" == $F("btnSwitch")){
							includeToNewGrpDistr2(giuwwPerildsTableGrid);
							newGroupTag = 1 ; // added by jhing 12.05.2014 
						}else {
							joinGroupDist(giuwwPerildsTableGrid);
							joinGroupTag = 1 ; // added by jhing 12.05.2014 
						}
					}
				}
			}
		}
	}
}