/**
 * function that will add record effects for the tax collections info rows
 * 
 * @author Alfie Niño Bioc 11.26.2010
 * @version 1.0
 * @param
 * @return
 */
function addRecordEffects (rowName, selectedFn, deSelectedFn, onEvent, newDivRowId) {
	
	if (onEvent == "onPageLoad") {
		$$("div[name='"+rowName+"']").each(function (div)	{
			if (onEvent == "onPageLoad")
				div.observe("mouseover", function ()	{
				div.addClassName("lightblue");
			});
			
			div.observe("mouseout", function ()	{
				div.removeClassName("lightblue");
			});
			div.observe("click", function ()	{
				selectedRowId = div.getAttribute("id");
				div.toggleClassName("selectedRow");
				if (div.hasClassName("selectedRow"))	{
					$$("div[name='"+rowName+"']").each(function (r)	{
						if (selectedRowId != r.getAttribute("id"))	{
							r.removeClassName("selectedRow");
						}
				     });
					if (selectedFn!=null) {
						selectedFn(div);
					}
				} else {
					if (deSelectedFn!=null) {
						deSelectedFn();
					}
				}
			});
		});
	} else if (onEvent == "newRecord") {
		$$("div[name='"+rowName+"']").each(function (div)	{
			if (div.getAttribute("id")==newDivRowId) {
				div.observe("mouseover", function ()	{
					div.addClassName("lightblue");
				});
				div.observe("mouseout", function ()	{
					div.removeClassName("lightblue");
				});
				div.observe("click", function ()	{
					selectedRowId = div.getAttribute("id");
					div.toggleClassName("selectedRow");
					if (div.hasClassName("selectedRow"))	{
						$$("div[name='"+rowName+"']").each(function (r)	{
							if (selectedRowId != r.getAttribute("id"))	{
								r.removeClassName("selectedRow");
							}
					     });
						if (selectedFn!=null) {
							selectedFn(div);
						}
					} else {
						if (deSelectedFn!=null) {
							deSelectedFn();
						}
					}
				});
			}
		});
	}
}