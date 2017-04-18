/*	Created by	: mark jm 01.28.2011
 * 	Description	: returns the current lineCd
 */
function getLineCd(paramLineCd){
	var lineCd = "";
	if((nvl(objUWGlobal.lineCd, paramLineCd) == objLineCds.MC 
			|| nvl(objUWGlobal.menuLineCd, paramLineCd) == "MC")//objLineCds.MC) Gzelle 07232014
			|| (objCurrPackPar != null && objUWGlobal.packParId != null ? 
					(nvl(objCurrPackPar.lineCd, paramLineCd) == objLineCds.MC || nvl(objCurrPackPar.menuLineCd, paramLineCd) == objLineCds.MC) : false)){
		lineCd = "MC";
		
	}else if((nvl(objUWGlobal.lineCd, paramLineCd) == objLineCds.FI 
			|| nvl(objUWGlobal.menuLineCd, paramLineCd) == "FI")//objLineCds.FI) Gzelle 07232014
			|| (objCurrPackPar != null && objUWGlobal.packParId != null ? 
					(nvl(objCurrPackPar.lineCd, paramLineCd) == objLineCds.FI || nvl(objCurrPackPar.menuLineCd, paramLineCd) == objLineCds.FI) : false)){
		lineCd = "FI";
	}else if((nvl(objUWGlobal.lineCd, paramLineCd) == objLineCds.MN 
			|| nvl(objUWGlobal.menuLineCd, paramLineCd) == "MN" //objLineCds.MN) Gzelle 07232014
			|| nvl(objUWGlobal.menuLineCd, paramLineCd) == objLineCds.MN) // dren 07.23.2015 : SR 0004592 - Added condition for PACK PAR
			|| (objCurrPackPar != null && objUWGlobal.packParId != null ? 
					(nvl(objCurrPackPar.lineCd, paramLineCd) == objLineCds.MN || nvl(objCurrPackPar.menuLineCd, paramLineCd) == objLineCds.MN) : false)){
		lineCd = "MN";	
				   
	}else if((nvl(objUWGlobal.lineCd, paramLineCd) == objLineCds.CA 
			|| nvl(objUWGlobal.menuLineCd, paramLineCd) == "CA")//objLineCds.CA) Gzelle 07232014
			|| (objCurrPackPar != null && (objUWGlobal.packParId != null ? 
					(nvl(objCurrPackPar.lineCd, paramLineCd) == objLineCds.CA || nvl(objCurrPackPar.menuLineCd, paramLineCd) == objLineCds.CA): false))){		
		lineCd = "CA";
	}else if((nvl(objUWGlobal.lineCd, paramLineCd) == objLineCds.EN 
			|| nvl(objUWGlobal.menuLineCd, paramLineCd) == "EN")//objLineCds.EN) Gzelle 07232014
			|| (objCurrPackPar != null && objUWGlobal.packParId != null ? 
					(nvl(objCurrPackPar.lineCd, paramLineCd) == objLineCds.EN || nvl(objCurrPackPar.menuLineCd, paramLineCd) == objLineCds.EN) : false)){
		lineCd = "EN";
	}else if((nvl(objUWGlobal.lineCd, paramLineCd) == objLineCds.AC 
			|| nvl(objUWGlobal.menuLineCd, paramLineCd) == "AC" //objLineCds.AC) Gzelle 07232014
			|| nvl(objUWGlobal.menuLineCd, paramLineCd) == objLineCds.AC) // dren 07.23.2015 : SR 0004592 - Added condition for PACK PAR
			|| (objCurrPackPar != null && objUWGlobal.packParId != null ? 
					(nvl(objCurrPackPar.lineCd, paramLineCd) == objLineCds.AC || nvl(objCurrPackPar.menuLineCd, paramLineCd) == objLineCds.AC) : false)) { 
		lineCd = "AC";
	}else if((nvl(objUWGlobal.lineCd, paramLineCd) == objLineCds.AV 
			|| nvl(objUWGlobal.menuLineCd, paramLineCd) == "AV")//objLineCds.AV) Gzelle 07232014
			|| (objCurrPackPar != null && objUWGlobal.packParId != null ? 
					(nvl(objCurrPackPar.lineCd, paramLineCd) == objLineCds.AV || nvl(objCurrPackPar.menuLineCd, paramLineCd) == objLineCds.AV) : false)) {
		lineCd = "AV";
	}else if((nvl(objUWGlobal.lineCd, paramLineCd) == objLineCds.MH 
			|| nvl(objUWGlobal.menuLineCd, paramLineCd) == "MH")//objLineCds.MH) Gzelle 07232014
			|| (objCurrPackPar != null && objUWGlobal.packParId != null ? 
					(nvl(objCurrPackPar.lineCd, paramLineCd) == objLineCds.MH || nvl(objCurrPackPar.menuLineCd, paramLineCd) == objLineCds.MH) : false)) {
		lineCd = "MH";
	}else if((nvl(objUWGlobal.lineCd, paramLineCd) == objLineCds.SU
			|| nvl(objUWGlobal.menuLineCd, paramLineCd) == "SU")//objLineCds.SU) Gzelle 07232014
			|| (objCurrPackPar != null && objUWGlobal.packParId != null ? 
					(nvl(objCurrPackPar.lineCd, paramLineCd) == objLineCds.SU || nvl(objCurrPackPar.menuLineCd, paramLineCd) == objLineCds.SU) : false)){
		lineCd = "SU";
	}
	return lineCd;
}