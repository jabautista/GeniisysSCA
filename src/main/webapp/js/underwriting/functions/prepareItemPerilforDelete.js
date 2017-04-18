//mode = 1 if function is called from pressing DELETE button
//mode = 2 if function is called from pressing UPDATE button
function prepareItemPerilforDelete(mode){
	try {
		var itemNo		= $F("itemNo");
		var perilCd		= "";
		if ("1" == mode){
			perilCd = nvl($F("perilCd"), $F("txtPerilCd"));
		} else {
			perilCd = $F("tempPerilCd");
		}
		var lineCd		= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalLineCd"));
		var listingDiv 	= $("itemPerilMainDiv");
		var newDiv 		= new Element("div");
		newDiv.setAttribute("id", "rowPeril"+itemNo+perilCd);
		newDiv.setAttribute("name", "rowPerilDel");
		newDiv.addClassName("tableRow");
		newDiv.setStyle("display : none");
		var deleteContent = '<input type="hidden" name="delPerilItemNos" 	value="'+itemNo+'" />' +
			'<input type="hidden" name="delPerilCds" 		value="'+perilCd+'" />' +
			'<input type="hidden" name="delPerilLineCds"	value="'+lineCd+'" />';
		newDiv.update(deleteContent);
		listingDiv.insert({bottom : newDiv});
	} catch (e){
		showErrorMessage("prepareItemPerilforDelete", e);
	}
}