/*	Created by	: mark jm 09.16.2010
 * 	Description	: Load observer for new record created in deductible
 * 	Parameter	: newDiv - div where to applied the observers
 */
function loadDeductibleNewRecordObserve(newDiv, dedLevel){
	
	newDiv.observe("mouseover", function ()	{
		newDiv.addClassName("lightblue");
	});

	newDiv.observe("mouseout", function ()	{
		newDiv.removeClassName("lightblue");
	});

	newDiv.observe("click", function ()	{
		newDiv.toggleClassName("selectedRow");
		if (newDiv.hasClassName("selectedRow"))	{
			$$("div[name='ded"+dedLevel+"']").each(function (li)	{
					if (newDiv.getAttribute("id") != li.getAttribute("id"))	{
					li.removeClassName("selectedRow");
				}
			});	
			setDeductibleForm(newDiv, dedLevel);
		} else {
			setDeductibleForm(null, dedLevel);
		}
	});

	Effect.Appear(newDiv, {
		duration: .5, 
		afterFinish: function ()	{
			//checkIfToResizeTable2("wdeductibleListing"+dedLevel, "ded"+dedLevel);
			//checkTableIfEmpty2("ded"+dedLevel, "deductiblesTable"+dedLevel);
			//checkPopupsTable("deductiblesTable" + dedLevel, "wdeductibleListing" + dedLevel, "ded" + dedLevel);	
			//setTotalAmount(dedLevel, newDiv.down("input", 0).value);
		}
	});
}