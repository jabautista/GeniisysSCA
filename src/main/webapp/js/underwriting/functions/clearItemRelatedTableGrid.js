/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	08.11.2011	mark jm			clear all table grid in item module
 * 	09.02.2011	mark jm			added condition for motorcar
 */
function clearItemRelatedTableGrid(){
	try{
		var lineCd = getLineCd(null);		
		
		deleteParItemTG(tbgItemDeductible);
		deleteParItemTG(tbgItemPeril);
		
		if(lineCd == "FI"){
			deleteParItemTG(tbgMortgagee);
		}else if(lineCd == "MC"){
			deleteParItemTG(tbgMortgagee);
			deleteParItemTG(tbgAccessory);
		}else if(lineCd == "CA"){
			deleteParItemTG(tbgGroupedItems);
			deleteParItemTG(tbgCasualtyPersonnel);
		}else if(lineCd == "MN"){			
			deleteParItemTG(tbgCargoCarriers);
		}else if(lineCd == "AC"){
			deleteParItemTG(tbgBeneficiary);
		}
		
		if(tbgPerilDeductible != null || tbgPerilDeductible != undefined){
			//tbgPerilDeductible.empty();
			deleteParItemTG(tbgPerilDeductible);
		}
	}catch(e){
		showErrorMessage("clearItemRelatedTableGrid", e);
	}
}