/**
* Shows list of branch per fundCd
* @author niknok
* @date 06.04.2012
*/
function showBranchLOV(moduleId, fundCd){
	LOV.show({
		controller: "AccountingLOVController",
		urlParameters: {
			action: "getBranchCd2LOV",
			fundCd: fundCd,
			moduleId : moduleId
		},
		title: "",
		width: 455,
		height: 388,
		columnModel : [
		               {
		            	   id : "branchCd",
		            	   title: "Code",
		            	   width: '120px'
		               },
		               {
		            	   id: "branchName",
		            	   title: "Branch Name",
		            	   width: '319px'
		               }
		              ],
		draggable: true,
		onSelect: function(row) {
			if (moduleId == "GIACS016" || moduleId == "GIACS071"){
				$("txtDspBranchCd").value = unescapeHTML2(row.branchCd);
				$("txtBranchCd").value = unescapeHTML2(row.branchCd);
				$("txtDspBranchName").value = unescapeHTML2(row.branchName);
				$("branch").value = unescapeHTML2(row.branchCd)+" - "+unescapeHTML2(row.branchName);
			} else if(moduleId == "GIACS002"){
				$("hidBranchCd").value = unescapeHTML2(row.branchCd);
				$("hidBranchName").value = unescapeHTML2(row.branchName);
				$("branch").value = unescapeHTML2(row.branchCd)+" - "+unescapeHTML2(row.branchName);
			}
		},
  		onCancel: function(){
  			if (moduleId == "GIACS016"){
  				$("branch").focus();
  			}
  		}
	});
}