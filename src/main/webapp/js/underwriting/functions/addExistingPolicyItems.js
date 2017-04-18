function addExistingPolicyItems(jsonObj){
	var exist = false;
	var row;

	$$("div#packageParPolicyTable div[name='rowPackPar']").each(function(r){
		if(r.getAttribute("parId")==jsonObj.parId){
			exist = true;
			r.show();
			row = r;
		}			
	});
	
	if(!exist){
		var obj = null;
		
		for(var i=0; i<objGIPIParList.length; i++){
			if(objGIPIParList[i].parId == jsonObj.parId){
				obj = objGIPIParList[i]; 
			}
		}
		
		if(obj != null){
			var content = preparePackageParPolicy(obj);
			var newDiv = new Element("div");
			
			newDiv.setAttribute("id", "rowPackPar"+obj.parId);
			newDiv.setAttribute("name", "rowPackPar");
			newDiv.setAttribute("parId", obj.parId);
			newDiv.setAttribute("lineCd", obj.lineCd);
			newDiv.setAttribute("sublineCd", obj.sublineCd);
			newDiv.setAttribute("issCd", obj.issCd);
			newDiv.setAttribute("polFlag", obj.polFlag);
			newDiv.setAttribute("packPolFlag", obj.packPolFlag);
			newDiv.addClassName("tableRow");
			
			newDiv.update(content);
			$("packageParPolicyTableContainer").insert({bottom : newDiv});
			checkIfToResizeTable("packageParPolicyTableContainer", "rowPackPar");
			checkTableIfEmpty("rowPackPar", "packageParPolicyTable");
			setEndtPackPolicyRowObserver(newDiv);
			row = newDiv;
		}
	}
	
	if(!row.hasClassName("selectedRow")){
		fireEvent($(row.id), "click");
		$(row.id).scrollIntoView();
	}
	setMainItemForm(jsonObject);
	enableButton($("btnAddItem"));
	enableEndtPackPolicyItemForm(true);
}