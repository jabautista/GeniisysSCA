/**
 * @author Steven Ramirez
 * @date 03.06.2013
 * @param urlContent - contains the controller,action and other parameters
 * 		  findText - this must be equal to the value of the textfield
 * 		  noticeMsg - for showNotice function
 * @return 0 - if no record is found
 * 		   2 - if more than one record is found
 * 		   jsonObj - if one record is found
 */
function validateTextFieldLOV(urlContent,findText,noticeMsg) {
	try {
		var jsonObj = 0;
		new Ajax.Request(contextPath + urlContent, { 
			method: "POST",
			parameters:{findText : findText,
						page : 1
			},
			evalscripts: true,
			asynchronous: false,
			onCreate: function(){
				if (noticeMsg != null && noticeMsg != "") {
					showNotice(noticeMsg);
				}
			},
			onComplete: function (response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					jsonObj = JSON.parse(response.responseText);
					if(jsonObj.total == 0) {
						jsonObj = 0;
					}else if(jsonObj.total > 1){
						jsonObj = 2;
					}
					
					if(urlContent.include("getGIPIS171LOV")){
						if(jsonObj.total == 1){
							jsonObj = 1;
						}
					}
				}
			}
		});
		return jsonObj;
	} catch (e) {
		showErrorMessage("validateTextFieldLOV",e);
	}
}
//function load