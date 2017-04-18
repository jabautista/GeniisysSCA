/*
 * Created by	: Andrew
 * Date			: September 27, 2010
 * Description	: Checks if the user have access to the menu and observes the function to open that module. Disables the element if the user have no access to the module
 * Parameters	: accessType - Type of access to the module: accessType.MENU, acessType.BUTTON, accessType.SUBPAGE, accessType.ROW, accessType.TOOLBUTTON, accessType.TAB
 * 				  moduleId 	 - Id of module to be checked
 * 				  elementId  - Id of element to be observed
 * 				  func 		 - Function to open the module
 */
function observeAccessibleModule(type, moduleId, elementId, func){
	try{
		//Ajax.Responders.unregister(quotationMainResponder);// The ajax responders in causing errors when you load the quotation information in marketing and if you proceed to a different modules. The registered responsders is not removed thus causing a null error. Irwin Nov. 9, 11
		if(checkUserModule(moduleId)){
			if (func != "" && func != null){
				if (accessType.ROW == type) {
					$(elementId).observe("dblclick", func);
				} else {
					if (accessType.SUBPAGE == type) {
						func();
						return;
					}	
					observeGoToModule(elementId, func);
					/*$(elementId).observe("click", function(){
						//func();
						//edited by Nok 02.08.2011
						if(changeTag == 1) {
							if (changeTagFunc == null || changeTagFunc == undefined || changeTagFunc == ""){
								changeTag = 0;
								changeTagFunc = "";
								func();
							}else{
								showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
									function(){
										changeTagFunc(); 
										if (changeTag == 0){
											changeTagFunc = "";
											func();
										}
									}, 
									function(){
										changeTag = 0;
										changeTagFunc = "";
										func();
									}, 
								"");
							}	
						}else{
							changeTag = 0;
							changeTagFunc = "";
							func();
						}
						//end Nok
					});*/
				}
			}
		} else {	
			switch(type) {
				case accessType.MENU: 
					disableMenu(elementId);
					break;
				case accessType.BUTTON:
					disableButton(elementId);
					break;
				case accessType.SUBPAGE:
					disableSubpage(elementId);
					break;
				case accessType.TOOLBUTTON:
					disableToolButton(elementId);
					break;
				case accessType.TAB:
					disableTab(elementId);
					$(elementId+"Disabled").title = objCommonMessage.NO_MODULE_ACCESS;
					break;
				case accessType.WIDGET:
					var widgetClassName = $(elementId).getAttribute("class");  
					$(elementId).setAttribute("class", widgetClassName + "_2");
					break;
			}
		}
	} catch (e) {
		showErrorMessage("observeAccessibleModule", e);
	}
}