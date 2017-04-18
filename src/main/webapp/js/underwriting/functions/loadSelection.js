/*	Created by	: mark jm 10.19.2010
 * 	Description	: choose which selection will be used
 * 	Parameter	: rowName - name of row used in table record listing
 * 				: row - div that holds the record
 */
function loadSelection(rowName, row){	
	switch(rowName){
		case "rowGroupedItem"		: loadSelectedGroupedItem(row); break;
		case "rowCasualtyPersonnel"	: loadSelectedCasualtyPersonnel(row); break;
		case "rowCargoCarrier"		: loadSelectedCarrier(row); break;
		case "rowMortg"				: loadSelectedMortgagee(row); break;
		case "rowAcc"				: loadSelectedAccessory(row); break;
	}
}