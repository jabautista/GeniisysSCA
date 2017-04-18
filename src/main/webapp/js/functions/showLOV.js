/*	Created by	: jerome orio 10.21.2010
 * 	Description	: show and enable the lov
 * 	Parameter	: lovName -  the name of LOV
 */
function showLOV(lovName){
	$(lovName).selectedIndex = 0;
	$(lovName).show();
	$(lovName).enable();
}