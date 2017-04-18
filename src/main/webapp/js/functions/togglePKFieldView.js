/*
 * Created by	: Bryan
 * Date			: October 8, 2010
 * Description	: Toggles visibility of select and text fields for primary key display elements
 * Parameter	: selectElementId - id of the select element for the primary key
 * 				  textElementId - id of the hidden text element that appears only when a row is selected
 * 				  val - value to be shown on the text field; "" when clearing field 
 * 				  selectedRowExists (BOOLEAN) - TRUE if called from changing from a selectedRow to another; FALSE if no selected row prior to clicking
 */
function togglePKFieldView(selectElementId, textElementId, val, selectedRowExists){
	if ("none" == document.getElementById(textElementId).style.display){
		$(selectElementId).hide();
		$(textElementId).show();
	} else {
		if (selectedRowExists == false){
			$(selectElementId).show();
			$(textElementId).hide();
		}
	}
	$(textElementId).value = val;
}