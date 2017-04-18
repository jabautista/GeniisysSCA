/*	Created by	: rjvirrey 02.17.2015 
 * 	Description	: for adding of numbers with fixed two decimals
 * 	Parameters	: preciseObj - object that contains whole numbers
 * 				: scaleObj - object that contains decimal
 */
function addObjectNumbers2(preciseObj, scaleObj){
	var addends1 = 0;
	var addends2 = 0;

	for(att in preciseObj){
		addends1 = addends1 + preciseObj[att];
		addends2 = addends2 + scaleObj[att];
	}

	if(addends2 >= 100){
		addends1 = addends1 + parseInt(addends2 / 100);
		addends2 = addends2 % 100;
	}

	return (addends1 + "." + formatNumberDigits(addends2.abs(), 2));
}