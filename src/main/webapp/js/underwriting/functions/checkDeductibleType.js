/*
 * Created by	: andrew robes
 * Date			: November 11, 2010
 * Description	: Checks if the deductible type of the specified level exist in the array of deductible objects.
 * Parameters	: objArray - array of deductible objects (objDeductibles);
 * 				  dedLevel - deductible level {1=policy level, 2=item level, 3=peril level}
 * 				  dedType - deductible type to search for 
 */
function checkDeductibleType(objArray, dedLevel, dedType){
	for(var i=0; i<objArray.length; i++){
		if(objArray[i].deductibleType == dedType) {
			if (dedLevel == 1) {
				if((objArray[i].itemNo == 0 || objArray[i].itemNo == null)
						&& objArray[i].recordStatus != -1){//added recordStatus condition to avoid detecting deleted objects BJGA.12.14.2010
					return true;
				}
			} else if (dedLevel == 2){
				if(objArray[i].itemNo > 0 && nvl(objArray[i].perilCd, 0) == 0
						&& objArray[i].recordStatus != -1){//added recordStatus condition to avoid detecting deleted objects BJGA.12.14.2010
					return true;
				}
			} else if (dedLevel == 3) {
				if(objArray[i].itemNo > 0 && nvl(objArray[i].perilCd, 0) > 0
						&& objArray[i].recordStatus != -1){//added recordStatus condition to avoid detecting deleted objects BJGA.12.14.2010
					return true;
				}
			}
		}
	}
	return false;
}