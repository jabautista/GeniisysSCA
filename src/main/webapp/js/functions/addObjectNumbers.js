/*	Created by	: mark jm 10.15.2010
 * 	Description	: just add numbers. trying to handle the operation on 99999999999999.99
 * 	Parameters	: preciseObj - object that contains whole numbers
 * 				: scaleObj - object that contains decimal
 */
function addObjectNumbers(preciseObj, scaleObj){
	var addends1 = 0;
	var addends2 = 0;

	for(att in preciseObj){
		addends1 = addends1 + preciseObj[att];
		addends2 = addends2 + scaleObj[att];
		
		if (addends2 == 10){
			addends2 = 100;
		}
	}

	if(addends2 >= 100){
		addends1 = addends1 + parseInt(addends2 / 100);
		addends2 = addends2 % 100;
	}

	return (addends1 + "." + formatNumberDigits(addends2.abs(), 2));
}