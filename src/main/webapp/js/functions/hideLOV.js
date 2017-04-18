/*	Created by	: jerome orio 10.21.2010
 * 	Description	: hide and disable the lov
 * 	Parameter	: lovName -  the name of LOV
 */
function hideLOV(lovName){
	$(lovName).selectedIndex = 0;
	$(lovName).hide();
	$(lovName).disable();
}