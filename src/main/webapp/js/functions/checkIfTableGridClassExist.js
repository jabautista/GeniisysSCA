/*
 * Created by	: Jerome Orio
 * Date			: December 7, 2010
 * Description 	: Check if class exist in table grid column
 * Parameters	: classList - list of class, space-separated string
 * 				: className - name of class to be search
 */
function checkIfTableGridClassExist(classList, className){
	var exist = false;
	var list = $w(classList);
	for (var i=0; i<list.length; i++){
		if (list[i] == className){
			exist = true;
			$break;
		}	
	}	
	return exist;
}