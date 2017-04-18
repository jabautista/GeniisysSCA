/*	Created by	: mark jm 07.28.2011
 * 	Moved from	: peril information page
 */
function showBaseAmt(perilCd){
	try{
		if (("" != document.getElementById("accPerilDetailsDiv").style.display)){ 
			for (var x=0; x<objBeneficiaries.length; x++){
				if ((objBeneficiaries[x].perilCd == perilCd) && (objBeneficiaries[x].packBenCd == $F("packBenCd"))){
					$("perilBaseAmt").value = objBeneficiaries[x].benefit == null ? "" : formatCurrency(objBeneficiaries[x].benefit);
					return false;
				}
			}
		}
	}catch(e){
		showErrorMessage("showBaseAmt", e);
	}		
}