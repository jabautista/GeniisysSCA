/*	Created by		: mark jm
*	Date Created	: 08.19.2010
*	Description		: update select's content based on given parameters
*/
function updateLOV(lovNameToUpdate, attributeName, valueToCompare){
	if($F(valueToCompare) == ""){
		reloadLOV(lovNameToUpdate);
	}else{
		showListing($(lovNameToUpdate)); //added by Jerome Orio 09.23.2010 to show all options first.
		for(var index=0, length = $(lovNameToUpdate).options.length; index < length; index++){
			var attributeValue = $(lovNameToUpdate).options[index].getAttribute(attributeName); 
			if(attributeValue != $F(valueToCompare)) {
				$(lovNameToUpdate).options[index].hide();
				$(lovNameToUpdate).options[index].disabled = true;
			}
		}
	}		
}