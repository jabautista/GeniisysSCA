/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	10.06.2011	mark jm			set values on grouped item coverage form (tablegrid version)
 * 	11.18.2011	mark jm			remove changed attribute by invoking
 *  09.15.2012  irwin           added property bascPerlCd
 */
function setItmperlGroupedFormTG(obj) {
	try {
		$("cPerilCd").value			= obj == null ? "" : obj.perilCd;
		$("cPerilName").value		= obj == null ? "" : unescapeHTML2(nvl(obj.perilName, ""));
		$("cPremRt").value			= obj == null ? "" : formatToNineDecimal(nvl(obj.premRt, "0"));
		$("cTsiAmt").value			= obj == null ? "" : nvl(obj.tsiAmt, false) ? formatCurrency(obj.tsiAmt) : "";
		$("cPremAmt").value			= obj == null ? "" : nvl(obj.premAmt, false) ? formatCurrency(obj.premAmt) : "";
		$("cNoOfDays").value		= obj == null ? "" : obj.noOfDays;
		$("cBaseAmt").value			= obj == null ? "" : nvl(obj.baseAmt, false) ? formatCurrency(obj.baseAmt) : "";
		$("cAggregateSw").checked	= obj == null ? false : (obj.aggregateSw == "Y" ? true : false);
		$("cAnnPremAmt").value		= obj == null ? "" : formatCurrency(nvl(obj.annPremAmt, "0"));
		$("cAnnTsiAmt").value		= obj == null ? "" : formatCurrency(nvl(obj.annTsiAmt, "0"));
		$("cRecFlag").value			= obj == null ? "" : obj.recFlag;
		$("cRiCommRt").value		= obj == null ? "" : /*formatToNineDecimal(nvl(obj.riCommRt, "0"));*/ nvl(obj.riCommRt, false) ? formatToNineDecimal(obj.riCommRt, "0") : "";
		$("cRiCommAmt").value		= obj == null ? "" : /*formatCurrency(nvl(obj.riCommAmt, "0"));*/ nvl(obj.riCommAmt, false) ? formatCurrency(obj.riCommAmt) : "";
		$("cLineCd").value			= obj == null ? "" : obj.lineCd;
		$("cWcSw").value			= obj == null ? "" : obj.wcSw;
		$("cPerilType").value		= obj == null ? "" : obj.perilType;
		$("cBascPerlCd").value		= obj == null ? "" : obj.bascPerlCd;
		$("cAggregateSw").disabled =  obj == null ? true : false;
		
		if(obj == null){
			$("btnAddCoverage").value = "Add";
			disableButton($("btnDeleteCoverage"));
			//disableButton($("btnCopyBenefits"));
			$("hrefCPeril").show();				
		}else{
			$("btnAddCoverage").value = "Update";
			enableButton($("btnDeleteCoverage"));
			//enableButton($("btnCopyBenefits"));			
			$("hrefCPeril").hide();
		}
		
		computeCoverageTotalTsiAndPremAmt();
		($$("div#accCoverageInfo [changed=changed]")).invoke("removeAttribute", "changed");
	} catch(e) {
		showErrorMessage("setItmperlGroupedFormTG", e);
	}
}