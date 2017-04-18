/**
 *  Created By: Irwin Tabisora
 *  march 11,2011
 *  @param json object, property of object
 *  @return array list of unique property
 *  ex: objTest, lineCd
 *  The function will return the unique list of line code.
 * */

function getUniqueProperty(obj, property){
	var tempVar = new Array();
	var uniqueList = new Array();
	
	for(var i = 0; i<obj.length; i++ ){
		tempVar[i] = obj[i][property];
	}

	var j =0;
	for(var i=0;i<tempVar.length;i++){
		uniqueList[j]=tempVar[i];
		j++;
		if((i>0)&&(tempVar[i]==tempVar[i-1])){
			uniqueList.pop();
			j--;
		}
	}
	return uniqueList;
}