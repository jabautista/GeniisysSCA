/*
 * Tonio 8.10.2011
 * GICLS010 Claim Basic Information
 * Sets Global values from Claims Basic Info
 */
function populateGlobalsFromBasicInfo(obj){
	//paki stringify na lang para makita ung column names
	objCLMGlobal.claimId = obj.claimId;
	objCLMGlobal.strClaimFileDate = obj.strClaimFileDate;
}