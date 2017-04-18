/**
 * Supply item - peril info
 * 
 * @author Niknok Orio
 * @param obj =
 *            selected giclItemPeril object
 */
function supplyClmItemPeril(obj){
	try{
		$("btnDeletePeril") ? enableButton("btnDeletePeril") :null;
		$("btnAddPeril") ? enableButton("btnAddPeril") :null;
		$("dspPerilNameDate") ? $("dspPerilNameDate").show() :null;

		objCLMItem.selectedPeril = obj == null ? {} :obj;
		objCLMItem.selPerilIndex = obj == null ? null :objCLMItem.selPerilIndex;
		objCLMItem.perilCd  	 = obj == null ? null :unescapeHTML2(String(nvl(obj[perilGrid.getColumnIndex('perilCd')],"")));
		objCLMItem.lossCatCd	 = obj == null ? null :unescapeHTML2(String(nvl(obj[perilGrid.getColumnIndex('lossCatCd')],"")));
		$("txtDspPerilName") 	? $("txtDspPerilName").value  	= obj == null ? null :unescapeHTML2(String(nvl(obj[perilGrid.getColumnIndex('dspPerilName')],""))) :null;
		$("txtDspLossCatDes") 	? $("txtDspLossCatDes").value  	= obj == null ? null :unescapeHTML2(unescapeHTML2(String(nvl(obj[perilGrid.getColumnIndex('dspLossCatDes')],"")))) :null; //robert added unescapeHTML2
		$("txtAnnTsiAmt") 		? $("txtAnnTsiAmt").value  		= obj == null ? null :(nvl(unescapeHTML2(String(nvl(obj[perilGrid.getColumnIndex('annTsiAmt')],""))),"") == "" ? "" :formatCurrency(unescapeHTML2(String(obj[perilGrid.getColumnIndex('annTsiAmt')])))) :null;
		$("btnAddPeril") 		? $("btnAddPeril").value  		= nvl(obj,null) != null && objCLMItem.selPerilIndex != null ? "Update" :"Add" :null;
		
		//belle 01102012
		if(objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == "AC" ){
			$("txtNoOfDays") 	    ? $("txtNoOfDays").value  	    = obj == null ? null :unescapeHTML2(nvl(String(obj[perilGrid.getColumnIndex('noOfDays')]),"")) :null; 
		}
		
		if (nvl(obj,null) != null){	
			//if (nvl(unescapeHTML2(String(obj[perilGrid.getColumnIndex('histIndicator')])),"D") == "U"){  
				$("dspPerilNameDate") ? $("dspPerilNameDate").hide() :null;
			//}
			$("btnDeletePeril") ? enableButton("btnDeletePeril") :null;
		}else{
			$("btnDeletePeril") ? disableButton("btnDeletePeril") :null;
		}
	}catch(e){
		showErrorMessage("supplyClmItemPeril", e);
	}
}