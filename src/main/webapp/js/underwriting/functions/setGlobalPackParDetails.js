/* Created by: Nica 11.22.2010
 * Description: Set Package PAR details as global parameters for Package PAR Listing
 * Parameter: packParId - package par id of the selected package Par
 */
function setGlobalPackParDetails(packParId){
	for(var i=0; i<objUWParList.jsonArray.length; i++){
		var objPar = objUWParList.jsonArray[i];
		if(objPar.packParId == packParId){
			objUWGlobal.packParId 	= objPar.packParId;
			objUWGlobal.issCd 		= objPar.issCd;
			objUWGlobal.parStatus 	= objPar.parStatus;
			objUWGlobal.parNo 		= objPar.parNo;
			objUWGlobal.assdNo 		= objPar.assdNo;
			objUWGlobal.assdName 	= objPar.assdName;
			objUWGlobal.parType 	= objPar.parType;
			objUWGlobal.parYy 		= objPar.parYy;
			objUWGlobal.remarks 	= objPar.remarks;
			objUWGlobal.underwriter = objPar.underwriter;
			/* temporarily assign values of assdName 
			and parNo to objUWParList object 01.21.2011 - nica */
			objUWParList.assdName	= objPar.assdName;
			objUWParList.parNo		= objPar.parNo;
			
			// for pol bas
			objUWGlobal.lineCd		= objPar.lineCd;
			objUWGlobal.sublineCd	= objPar.sublineCd;
			objUWGlobal.issueYy		= objPar.issueYy;
			objUWGlobal.polSeqNo	= objPar.polSeqNo;
			objUWGlobal.renewNo		= objPar.renewNo;
		}
	}
}