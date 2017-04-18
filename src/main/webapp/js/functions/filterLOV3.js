/*
 * Created by	: andrew robes
 * Date			: November 3, 2010
 * Description	: Hides options which is already on the table list. Uses another record (div) attribute in condition
 * Parameters   : selectId - id of select box to filter
 * 				: rowName - name of row in table
 * 				: cdAttr - code attribute which will be used to compare with the select options
 * 				: pkAttr - attribute name to campare against the pkValue
 * 				: pkValue - value to filter the rows
 */
function filterLOV3(selectId,rowName,cdAttr,pkAttr,pkValue){
	showListing($(selectId));
	$$("div[name='"+rowName+"']").each(function(row){
		if (row.getAttribute(pkAttr) == pkValue){
			var cd = row.getAttribute(cdAttr);
			for(var i = 1; i < $(selectId).options.length; i++){ 
				if (cd == $(selectId).options[i].value){
					$(selectId).options[i].hide();
					$(selectId).options[i].disabled = true;
				}
			}
		}
	});
}