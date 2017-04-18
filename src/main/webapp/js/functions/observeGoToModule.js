/*
 * Created by	: Jerome Orio
 * Date			: March 08, 2011
 * Description 	: 
 * Parameters	: id - id field/module
 * 				: func - function to call after change tag function
 */
function observeGoToModule(id, func){
	//Ajax.Responders.unregister(quotationMainResponder);// The ajax responders in causing errors when you load the quotation information in marketing and if you proceed to a different modules. The registered responsders is not removed thus causing a null error. Irwin Nov. 9, 11
	$(id).stopObserving("click");
	$(id).observe("click", function () {
		if(changeTag == 1) {
			if (changeTagFunc == null || changeTagFunc == undefined || changeTagFunc == ""){
				changeTag = 0;
				changeTagFunc = "";
				func(); 
			}else{
				showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
						function(){
							changeTagFunc(); 
							lastAction = func; // mark jm 12.16.2011 holds the last function
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
	});		
}