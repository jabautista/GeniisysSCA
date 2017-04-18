/**
 * Compute Net Premium Amount in Policy Discount in GIPIS143
 * @author Jerome Orio 01.31.2011
 * @version 1.0
 * @param 
 * @return formatted net premium amount
 */
function computeNetPremPolDisc(){
	var vDiscTotal = 0;
	var vSurcTotal = 0;
	$$("div[name='rowItem']").each(function (row) {
		vDiscTotal = parseFloat(nvl(vDiscTotal,0)) + parseFloat(nvl(row.down("input", 4).value.replace(/,/g, ""),0));
		vSurcTotal = parseFloat(nvl(vSurcTotal,0)) + parseFloat(nvl(row.down("input", 6).value.replace(/,/g, ""),0));
    });
	$$("div[name='rowPeril']").each(function (row) {
		vDiscTotal = parseFloat(nvl(vDiscTotal,0)) + parseFloat(nvl(row.down("input", 5).value.replace(/,/g, ""),0));
		vSurcTotal = parseFloat(nvl(vSurcTotal,0)) + parseFloat(nvl(row.down("input", 7).value.replace(/,/g, ""),0));
    });
	$$("div[name='rowBasic']").each(function (row) {
		if (!row.hasClassName("selectedRow")){	// added to skip selected record : shan 08.05.2014
			vDiscTotal = parseFloat(nvl(vDiscTotal,0)) + parseFloat(nvl(row.down("input", 2).value.replace(/,/g, ""),0));
			vSurcTotal = parseFloat(nvl(vSurcTotal,0)) + parseFloat(nvl(row.down("input", 4).value.replace(/,/g, ""),0));			
		}
    });

	var premAmt = 0;
	if (vDiscTotal > 0){
		premAmt = nvl(unformatCurrency("paramOrigPremAmt"),0) - vDiscTotal;
	} else {
		premAmt = nvl(unformatCurrency("paramOrigPremAmt"),0);
	}
	
	return parseFloat(premAmt + vSurcTotal);
}