/**
 * Adds a new table row in a specified table container
 * @author eman
 * @param rowNum The row number
 * @param rowName The row name
 * @param tableContainer The table container
 * @param content The div content of the row
 * @param onClickFunc The function when row is clicked
 * @return
 */
function addTableRow(rowId, rowName, tableContainer, content, onClickFunc) {
	var itemTable = $(tableContainer);
	var newDiv = new Element("div");
	newDiv.setAttribute("id", rowId);
	newDiv.setAttribute("name", rowName);
	newDiv.addClassName("tableRow");
	newDiv.update(content);
	itemTable.insert({bottom : newDiv});
	newDiv.observe("mouseover",
		function(){
			newDiv.addClassName("lightblue");
	});

	newDiv.observe("mouseout",
		function(){
			newDiv.removeClassName("lightblue");
	});

	newDiv.observe("click",
		function(){
			onClickFunc(newDiv);
	});

	Effect.Appear(newDiv, {
		duration: .2
	});
}