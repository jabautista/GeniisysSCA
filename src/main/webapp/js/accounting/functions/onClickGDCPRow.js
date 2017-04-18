function onClickGDCPRow() {
	try {
		dcpRow.toggleClassName("selectedRow");
		if(dcpRow.hasClassName("selectedRow")){
			$$("div[name='dcpRow']").each(function(anotherRow){
				if(dcpRow.id != anotherRow.id){
					anotherRow.removeClassName("selectedRow");
				}else{
					var postFix = dcpRow.id.substr(6);
					var found = false;
					var obj = null;
					for(var i = 0 ; i < dcpJsonObjectList.length; i++){
						if(dcpJsonObjectList[i].id == postFix){
							found = true;
							obj = dcpJsonObjectList[i];
							$break;
						}
					}
					if(found){
						populateGDCPForm(obj);
					}
				}
			});
		}else{
			populateGDCPForm(null);
		}
	} catch(e) {
		showErrorMessage("onClickDCPRow", e);
	}
}