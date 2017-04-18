/*
 * Created by	: andrew
 * Date			: October 18, 2010
 * Description	: Writes 'changed' attribute to elements which value is changed, this will be used in 'checkPendingRecordChanges' function 
 */
function initializeChangeAttribute(div){
	if(div == null){
		$$("div#outerDiv").each(function (a) {
			if(a.next("div") != undefined || a.next("div") != null){
				a.next("div").descendants().each(function (obj) {
					if (obj.nodeName == "SELECT" || obj.nodeName == "INPUT" || obj.nodeName == "TEXTAREA") {
						obj.observe("change", function () {					
							obj.writeAttribute("changed", true);
						});
					}
				});
			}		
		});
	} else {
		if($(div) != undefined || $(div) != null){
			$(div).descendants().each(function (obj) {
				if ((obj.nodeName == "SELECT" || obj.nodeName == "INPUT" || obj.nodeName == "TEXTAREA") && obj.id.substr(0, 3) != "mtg") {	// added condition to skip tablegrid fields : shan 05.16.2014
					obj.observe("change", function () {					
						obj.writeAttribute("changed", true);
					});
				}
			});
		}	
	}	
}