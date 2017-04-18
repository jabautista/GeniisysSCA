// used to initialize basic behavior of a table, like mouseover and mouse out and clickable rows
// parameters:
// tableClass: className of the table/div containing the rows
// rowName: name of the rows
// field to populate with value, usually the primary of the record
function initializeTable(tableClass, rowName, pkHiddenFieldId, clickFunc) {
	$$("div."+tableClass+" div[name='"+rowName+"']").each(
		function (row){
			row.observe("mouseover", function ()	{
				row.addClassName("lightblue");
			});
			
			row.observe("mouseout", function ()	{
				row.removeClassName("lightblue");
			});
			
			row.observe("click", function ()	{
				row.toggleClassName("selectedRow");
				if (row.hasClassName("selectedRow"))	{
					if (!pkHiddenFieldId.blank()) {
						if (pkHiddenFieldId.split(",").size() > 1) {
							var pk = pkHiddenFieldId.split(",");
							$(pk[0]).value = row.readAttribute("id").substring(rowName.length);
							$(pk[1]).value = row.down("input", 0).value;
							$(pk[2]).value = row.down("input", 1).value;
							$(pk[3]).value = row.down("input", 2).value;
							$(pk[4]).value = row.down("input", 3).value;
							$(pk[5]).value = row.down("input", 4).value;
							$(pk[6]).value = row.down("input", 5).value;
							$(pk[7]).value = row.down("input", 6).value;
						} else {
							$(pkHiddenFieldId).value = row.readAttribute("id").substring(rowName.length);
						}
					}
					$$("div."+tableClass+" div[name='"+rowName+"']").each(function (r)	{
						if (r.getStyle("display")!= "none")	{
							if (row.readAttribute("id") != r.readAttribute("id")) {
								r.removeClassName("selectedRow");
							}
						}
					});
					
					if (clickFunc != "" && clickFunc != null) {
						clickFunc();
					}
				} else {
					if (!pkHiddenFieldId.blank()) {
						if (pkHiddenFieldId.split(",").size() > 1) {
							var pk = pkHiddenFieldId.split(",");
							$(pk[0]).value = "";
							$(pk[1]).value = "";
							$(pk[2]).value = "";
							$(pk[3]).value = "";
							$(pk[4]).value = "";
							$(pk[5]).value = "";
							$(pk[6]).value = "";
							$(pk[7]).value = "";
						} else {
							$(pkHiddenFieldId).value = "";
						}
					}
					
					if (clickFunc != "" && clickFunc != null) {
						clickFunc();
					}
				}
			});
		}
	);
}