/*
 * Created by	: Jerome Orio
 * Date			: February 10, 2011
 * Description 	: To observe if changes exist in date field
 * Parameters	: imgDateId - id of image calendar
 * 				: dateId - id of the date field
 * 				: onChangeFunc - optional function to call on changed of date
 */
function observeChangeTagOnDate(imgDateId, dateId, onChangeFunc){
	var preTextDate = "";
	$(dateId).setAttribute("pre-text", $(dateId).value);
	$(imgDateId).observe("click", function () {
		preTextDate = $(dateId).value;
		$(dateId).setAttribute("pre-text", preTextDate);
	});
	
	$(dateId).observe("focus", function(){
		if (checkIfValueChanged(dateId)){
			changeTag = 1;
			if (onChangeFunc != null || onChangeFunc != undefined){onChangeFunc();}
		}
	});
}