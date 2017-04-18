/*
 * Created by	: Jerome Orio
 * Date			: February 09, 2011
 * Description 	: To enable back space on Date field
 * Parameters	: id - id
 */
function observeBackSpaceOnDate(id, onChangeFunc){
	$(id).observe("keyup", function(e) {
		if (objKeyCode.BACKSPACE == e.keyCode){
			if($(id).next("img",1)  == undefined){ //delete only when updatable
				$(id).clear();
				if (onChangeFunc != null || onChangeFunc != undefined){onChangeFunc();} //added by steven 04.10.2014
			}
		}else if(objKeyCode.DELETE == e.keyCode){  //delete only when updatable
			if($(id).next("img",1)  == undefined){
				$(id).clear();
				if (onChangeFunc != null || onChangeFunc != undefined){onChangeFunc();}
			}
		}	
	});
}