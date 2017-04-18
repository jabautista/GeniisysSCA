/**
 * Sets list of values for Intermediary
 */

function setPackQuoteIntermediaryLov(){
	var selIntermediary = $("selIntermediary");	
	selIntermediary.update("<option></option>");
	for(var i=0; i<intermediaryLov.length; i++){
		var intermedOpt = new Element("option");
		intm = intermediaryLov[i];
		intermedOpt.setAttribute("value", intm.intmNo);
		intermedOpt.innerHTML = "" + intm.intmNo.toPaddedString(3) + " - " + intm.intmName;
		selIntermediary.insert(intermedOpt);
	}
}