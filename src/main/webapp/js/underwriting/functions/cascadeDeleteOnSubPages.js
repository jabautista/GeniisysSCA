/*	Created by	: mark jm 10.05.2010
 * 	Description	: delete rows on subpages
 */

function cascadeDeleteOnSubPages(itemNo){
	// item deductibles
	$$("div#deductiblesTable2 div[name='ded2']").each(function(row){
		row.removeClassName("selectedRow"); // andrew - 11.8.2010 - added this line to remove the selectedRow class name
		if(row.getAttribute("item") == itemNo){			
			Effect.Fade(row, {
				duration : .001,
				afterFinish : function(){
					row.remove();
					checkIfToResizeTable2("wdeductibleListing2", "ded2");
					checkTableIfEmpty2("ded2", "deductiblesTable2");
					setDeductibleForm(null, 2);
				}
			});
		}
	});
}