/*
 * Created By	: andrew robes
 * Date			: November 23, 2010
 * Description	: Updates the values in html row of the negated endt peril
 * Parameter	: obj - the negated endt peril object
 */
function updateNegatedPerilRow(obj){
	try {
		var rowEndtPerilId = "rowEndtPeril"+obj.itemNo+obj.perilCd;
		
		$(rowEndtPerilId).down("div", 0).down("label", 2).innerHTML = formatToNineDecimal(obj.premRt);
		$(rowEndtPerilId).down("div", 0).down("label", 3).innerHTML = formatCurrency(obj.tsiAmt);
		$(rowEndtPerilId).down("div", 0).down("label", 4).innerHTML = formatCurrency(obj.annTsiAmt);
		$(rowEndtPerilId).down("div", 0).down("label", 5).innerHTML = formatCurrency(obj.premAmt);
		$(rowEndtPerilId).down("div", 0).down("label", 6).innerHTML = formatCurrency(obj.annPremAmt);
	} catch (e) {
		showErrorMessage("updateNegatedPerilRow", e);
	}
}