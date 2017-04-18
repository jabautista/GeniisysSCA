/*	Created by		: mark jm
*	Date Created	: 08.19.2010
*	Description		: show all select's content due to filtering/updating
*/
function reloadLOV(lovName){	
	for(var index=0, length = $(lovName).options.length; index < length; index++){
		$(lovName).options[index].show();
		$(lovName).options[index].disabled = false;
	}
}