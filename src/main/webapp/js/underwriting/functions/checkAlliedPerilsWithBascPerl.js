// jhing 12.11.2014 added an additional layer of validation in separating attached allied peril from its basic peril 
function checkAlliedPerilsWithBascPerl(tableGrid){
	var checkedPeril = tableGrid.getModifiedRows();
	var objArray 	 = tableGrid.geniisysRows;		
	var attachedAlliedGrp =  checkedPeril.filter(function (obj){ return ((obj.bascPerlCd != null || obj.bascPerlCd == "") && (obj.perilType == "A") && (obj.groupTag == true)) ; } ) ;
	var errBascPerlName;
	var alliedPerlName; 
	var saveChanges  = true;
	for (var x = 0 ; x < attachedAlliedGrp.length ; x++) {
		var bascPerlCd	 = attachedAlliedGrp[x].bascPerlCd;
		var bascPerlArr = checkedPeril.filter(function (obj){ return obj.perilCd == bascPerlCd && obj.groupTag == true;});
		
		if (bascPerlArr.length < 1 ){
			alliedPerlName = attachedAlliedGrp[x].perilName; 
			for ( var y = 0 ; y < objArray.length ; y++ ) {
				if ( objArray[y].perilCd == bascPerlCd ){
					errBascPerlName =  objArray[y].perilName; 
					showMessageBox(alliedPerlName + " is an attached allied peril and must not be separated from its basic peril " +errBascPerlName + " ." , imgMessage.INFO);
					saveChanges = false;
					return saveChanges ; 
					break;
				}				
			}			
			break;
		}
	}		
	return saveChanges ; 
 }