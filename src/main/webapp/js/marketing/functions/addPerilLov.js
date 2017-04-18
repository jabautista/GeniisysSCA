/**
 * Adds a new peril option to :selObject using :perilObject
 * 
 * @param Select
 *            element object
 * @param peril
 *            lov object
 * @return option element
 */
function addPerilLov(selObject, perilObject){
	var newOption = new Element("option");
	newOption.setStyle("");
	newOption.setAttribute("value", perilObject.perilCd);
	newOption.setAttribute("defaulttsi", perilObject.tsiAmount);
	newOption.setAttribute("defaultrate", perilObject.premiumRate);
	newOption.setAttribute("perilname", perilObject.perilName);
	newOption.setAttribute("wcSw", perilObject.wcSw);
	newOption.setAttribute("basicPerilCd", perilObject.basicPerilCd);
	if(perilObject.perilType=="A"){
		newOption.setAttribute("perilType", "A");
		newOption.innerHTML = "" + perilObject.perilCd + " - " + perilObject.perilName + " - Allied Peril";
	}else if(perilObject.perilType=="B"){
		newOption.setAttribute("perilType", "B");
		newOption.innerHTML = "" + perilObject.perilCd + " - " + perilObject.perilName + " - Basic Peril";
	}
	try{ 
		selObject.add(newOption, null);
	}catch(e){ // for IE daw
		selObject.add(newOption);
	}

}