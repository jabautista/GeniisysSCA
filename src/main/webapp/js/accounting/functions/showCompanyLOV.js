/**
* Shows list of company
* @author niknok
* @date 06.04.2012
*/
function showCompanyLOV(moduleId){
	LOV.show({
		controller: "AccountingLOVController",
		urlParameters: {
			action: "getCompanyLOV"
		},
		title: "",
		width: 455,
		height: 388,
		columnModel : [
		               {
		            	   id : "fundCd",
		            	   title: "Code",
		            	   width: '120px'
		               },
		               {
		            	   id: "fundDesc",
		            	   title: "Description",
		            	   width: '319px'
		               }
		              ],
		draggable: true,
		onSelect: function(row) {
			if (moduleId == "GIACS016" || moduleId == "GIACS071" || moduleId == "GIACS002"){
				$("txtFundCd").value = unescapeHTML2(row.fundCd);
				$("txtDspFundDesc").value = unescapeHTML2(row.fundDesc);
				$("company").value = unescapeHTML2(row.fundCd)+" - "+unescapeHTML2(row.fundDesc);
			}
		},
  		onCancel: function(){
  			if (moduleId == "GIACS016" || moduleId == "GIACS071" || moduleId == "GIACS002"){
  				$("company").focus();
  			} 
  		}
	});
}