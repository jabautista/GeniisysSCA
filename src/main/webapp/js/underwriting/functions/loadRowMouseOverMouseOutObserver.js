/*	Created by	: mark jm 10.12.2010
 * 	Description	: loads the mouseover and mouseout observer for a certain row
 * 	Parameter	: row - id of the div to observe
 */
function loadRowMouseOverMouseOutObserver(row){
	try{
		row.observe("mouseover", function(){
			row.addClassName("lightblue");
		});
	
		row.observe("mouseout", function(){
			row.removeClassName("lightblue");
		});
	}catch(e){
		showErrorMessage("loadRowMouseOverMouseOutObserver", e);
		//showMessageBox("loadRowMouseOverMouseOutObserver : " + e.message);
	}
}