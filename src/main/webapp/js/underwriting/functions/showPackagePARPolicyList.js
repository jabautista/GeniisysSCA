/*	Created by	: mark jm 03.17.2011
 * 	Description	: create the listing in package policy items
 * 	Parameters	: objArray - record list
 */
function showPackagePARPolicyList(objArray){
	try{
		var table = $("packageParPolicyTableContainer");
		
		for(var i=0, length=objArray.length; i < length; i++){
			var content = preparePackageParPolicy(objArray[i]);
			var newDiv = new Element("div");
			
			newDiv.setAttribute("id", "rowPackPar"+objArray[i].parId);
			newDiv.setAttribute("name", "rowPackPar");
			newDiv.setAttribute("parId", objArray[i].parId);
			newDiv.setAttribute("lineCd", objArray[i].lineCd);
			newDiv.setAttribute("sublineCd", objArray[i].sublineCd);
			newDiv.setAttribute("issCd", objArray[i].issCd);
			newDiv.setAttribute("polFlag", objArray[i].polFlag);
			newDiv.setAttribute("packPolFlag", objArray[i].packPolFlag);
			newDiv.setAttribute("regionCd", objArray[i].regionCd);
			newDiv.addClassName("tableRow");
			
			newDiv.update(content);
			table.insert({bottom : newDiv});			
		}
		
		checkIfToResizeTable("packageParPolicyTableContainer", "rowPackPar");
		checkTableIfEmpty("rowPackPar", "packageParPolicyTable");		
	}catch(e){
		showErrorMessage("showPackagePARPolicyList", e);
	}
}