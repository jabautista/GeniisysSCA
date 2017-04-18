/*
 * Created By 	: andrew
 * Date			: October 18, 2010
 * Description	: Checks if there are pending changes in records, 
 * 				  This happens when the user selects a record, modify it but did not click the Update button to apply changes
 */
function checkPendingRecordChanges(){
	var subPages = new Array();
	var btnAdd = new Array();
	var subPage = null;
		
	$$("div#outerDiv").each(function(div){
		subPage = new Object();
		subPage.title = div.down("div").down("label").innerHTML;
		//subPage.tranMode = "Add"; //removed by John Daniel SR-22336 05.19.2016
		
		var changedElements = new Array();
		div.next("div").descendants().each(function(obj){			 
			if(obj.hasAttribute("changed")){
				changedElements.push(obj.id);
			}

			if (obj.type == "button" && obj.value == "Update"){
				subPage.button = obj.id;
				subPage.tranMode = "Update";
			} else if (obj.type == "button" && obj.value == "Apply Changes"){ // andrew - 01.17.2012 - added condition for Apply Changes button
				subPage.button = obj.id;
				subPage.tranMode = "Apply Changes";
			} else if (obj.type == "button" && obj.value == "Add"){ // added by John Daniel SR-22336 05.19.2016 - added to set tranMode only if obj.id is not a button 
				subPage.button = obj.id;
				subPage.tranMode = "Add";
			}
		});
		
		subPage.changedElements = changedElements;
		subPages.push(subPage);
	});
	
	for (i=0; i<subPages.length; i++){
		if(subPages[i].changedElements.length > 0) {
			if (subPages[i].tranMode == "Update"){
				var button = subPages[i].tranMode; 
				var message = "You have changes in " + subPages[i].title + " portion. Press "+ button + " button first to apply changes otherwise unselect the " + subPages[i].title + " record to clear changes.";
				showMessageBox(message);
				return false;
			} else if (subPages[i].tranMode == "Apply Changes") {
				var button = subPages[i].tranMode; 
				var message = "You have changes in " + subPages[i].title + " portion. Press "+ button + " button first to apply changes otherwise unselect the record to clear changes.";
				showMessageBox(message);
				return false;
			} else if(subPages[i].tranMode == "Add"){ // added by mark jm 03.01.2011
				var message = "You have changes in " + subPages[i].title + " portion. Press Add button first to apply changes.";
				showMessageBox(message);
				return false;
			}
		}
	}
	return true;
}