/*	Created by	: mark jm 11.25.2010
 * 	Description	: set row's attribute and behavior
 * 	Parameters	: row - div that will be displayed
 * 				: id - row id
 * 				: rowName - row name
 * 				: obj - object that holds the data
 * 				: content - display on row
 * 				: tableName - table name where the row will be added
 */
function addEndtItemPeril(row, id, rowName, obj, content, tableName){
	row.setAttribute("id", id);
	row.setAttribute("name", rowName);
	row.setAttribute("item", obj.itemNo);
	row.setAttribute("perilCd", obj.perilCd);
	row.addClassName("tableRow");
	row.setStyle("display : none");
	
	row.update(content);
	$(tableName).insert({bottom : row});
	
	loadRowMouseOverMouseOutObserver(row);
	
	row.observe("click", function(){
		row.toggleClassName("selectedRow");
		if(row.hasClassName("selectedRow")){
			$$("div[name='" + rowName + "']").each(function(li){
				if(row.getAttribute("id") != li.getAttribute("id")){
					li.removeClassName("selectedRow");
				}
			});
			
			//marco - 04.14.2014 - assign value to objCurrItemPeril
			for(var i=0; i<objGIPIWItemPeril.length; i++) {
				if (objGIPIWItemPeril[i].itemNo == parseInt(row.getAttribute("item")) 
						&& objGIPIWItemPeril[i].perilCd == parseInt(row.getAttribute("perilcd"))
						&& objGIPIWItemPeril[i].recordStatus != -1) {
					objCurrItemPeril = objGIPIWItemPeril[i];
					break;
				}	
			}
			
			setEndtPerilForm(objCurrItemPeril); //marco - 04.14.2014 - setEndtPerilForm(row)
			setEndtPerilFields(objCurrItemPeril); //marco - 04.14.2014 - setEndtPerilFields(row)
		}else{
			setEndtPerilForm(null);
			setEndtPerilFields(null);
		}
	});
	/*
	Effect.Appear(row, {
		duration : .5,
		afterFinish : function(){
			checkIfToResizeTable2("perilTableContainerDiv", rowName);
			checkTableIfEmpty2(rowName, "endtPerilTable");
		}
	});
	*/
}