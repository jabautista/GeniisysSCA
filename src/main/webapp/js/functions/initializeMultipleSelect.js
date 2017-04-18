//used to initialize basic behavior of a table, like mouseover and mouse out and clickable rows
//with multiple select of rows
//parameters:
//tableClass: className of the table/div containing the rows
//rowName: name of the rows
function initializeMultipleSelect(tableClass, rowName) {
	$$("div."+tableClass+" div[name='"+rowName+"']").each(
		function (row)	{
			row.observe("mouseover", function ()	{
				row.addClassName("lightblue");
			});
			
			row.observe("mouseout", function ()	{
				row.removeClassName("lightblue");
			});
			
			row.observe("click", function ()	{
				row.toggleClassName("selectedRow");
			});
		}
	);
}