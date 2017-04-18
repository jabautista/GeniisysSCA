/* Created by: Nica 02.03.2011
 * Description: Set global parameters for Package PAR
 * Parameter: objPar - object that contains Package PAR information
 */
function setGlobalParametersForPackPar(objPar){
	objUWGlobal.parId 		= objPar.parId;
	objUWGlobal.packParId 	= objPar.packParId;
	objUWGlobal.lineName 	= objPar.lineName;
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
	objUWParList.parType 	= objPar.parType;	
	// for pol bas
	objUWGlobal.lineCd		= objPar.lineCd;
	objUWGlobal.sublineCd	= objPar.sublineCd;
	objUWGlobal.issueYy		= objPar.issueYy;
	objUWGlobal.polSeqNo	= objPar.polSeqNo;
	objUWGlobal.renewNo		= objPar.renewNo;
}