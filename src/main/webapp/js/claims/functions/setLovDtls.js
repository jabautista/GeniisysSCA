function setLovDtls(lovName, idText, desc, title){
	objCLM.lovSelected = lovName;
	objCLM.idText = idText;
	objCLM.desc = desc;
	objCLM.lovTitle = nvl(title,"");
}