// simple checks if the current user has the
// parameter: moduleName - name of module to check, e.g. GIIMM006
function checkUserModule(moduleName) {
	var exist = false;
	modules.any(function (mod) {if (moduleName == mod) {exist = true;}});
	
	return exist;
}