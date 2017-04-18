function getLineCdMarketing(){
	var lineCd = "";
	
	if(objGIPIQuote.lineCd == objLineCds.AC || objGIPIQuote.menuLineCd == objLineCds.AC) { 
		lineCd = "AC";
	}else if(objGIPIQuote.lineCd == objLineCds.AV || objGIPIQuote.menuLineCd == objLineCds.AV) {
		lineCd = "AV";
	}else if(objGIPIQuote.lineCd == objLineCds.CA || objGIPIQuote.menuLineCd == objLineCds.CA){
		lineCd = "CA";
	}else if(objGIPIQuote.lineCd == objLineCds.EN || objGIPIQuote.menuLineCd == objLineCds.EN){
		lineCd = "EN";
	}else if(objGIPIQuote.lineCd == objLineCds.FI || objGIPIQuote.menuLineCd == objLineCds.FI){
		lineCd = "FI";
	}else if(objGIPIQuote.lineCd == objLineCds.MC	|| objGIPIQuote.menuLineCd == objLineCds.MC){
		lineCd = "MC";
	}else if(objGIPIQuote.lineCd == objLineCds.MH || objGIPIQuote.menuLineCd == objLineCds.MH) {
		lineCd = "MH";
	}else if(objGIPIQuote.lineCd == objLineCds.MN || objGIPIQuote.menuLineCd == objLineCds.MN){
		lineCd = "MN";		
	}else if(objGIPIQuote.lineCd == objLineCds.SU || objGIPIQuote.menuLineCd == objLineCds.SU){   //switched SU and PA position in else
		lineCd = "SU";																			  //causes error in SU item info 
	}else if(objGIPIQuote.lineCd == objLineCds.PA || objGIPIQuote.menuLineCd == objLineCds.PA) {  //objLineCds.PA is undefined  - jeffdojello 11.26.2013 SR-706
		lineCd = "PA";
	}
	return lineCd;
}