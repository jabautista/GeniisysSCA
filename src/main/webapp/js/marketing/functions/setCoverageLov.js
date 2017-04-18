/**
 * Sets list of values for Coverage
 */

function setCoverageLov(){
	var selCoverage = $("selCoverage");
	selCoverage.update("<option></option>");
	var coverageObj = null;
	for(var i=0; i<objItemCoverageLov.length; i++){
		coverageObj = objItemCoverageLov[i];
		var coverageOption = new Element("option");
		coverageOption.innerHTML = coverageObj.desc;
		coverageOption.setAttribute("coverageCd", coverageObj.code);
		coverageOption.setAttribute("coverageDesc", coverageObj.desc);
		coverageOption.setAttribute("value", coverageObj.code);
		selCoverage.add(coverageOption,null);
	}
}