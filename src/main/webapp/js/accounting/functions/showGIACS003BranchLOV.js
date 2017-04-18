// moved from enterJournalEntries.jsp by Kris 04.11.2013
function showGIACS003BranchLOV(moduleId, fundCd, findText2){
	LOV.show({
		controller: "AccountingLOVController",
		urlParameters: {
			action: "getGIACS003BranchLOV",
			fundCd: fundCd,
			moduleId: moduleId,
			searchString: findText2
		},
		title: "List of Branches",
		width: moduleId == 'GIACS047' ? 385 :485,
		height: 388,
		autoSelectOneRecord: true, //reymon 05062013
		columnModel : [
		               {
		            	   id : "branchCd",
		            	   title: "Branch Code",
		            	   width: '80px'
		               },
		               {
		            	   id : "fundDesc",
		            	   title: "Fund",
		            	   width:  moduleId == 'GIACS047' ? '0px' : '200px',
		            	   visible: moduleId == 'GIACS047' ? false : true  
		               },
		               {
		            	   id: "branchName",
		            	   title: "Branch Name",
		            	   width: moduleId == 'GIACS047' ? '270px' : '200px'
		               }
		              ],
		draggable: true,
		filterText: findText2,
		onSelect: function(row) {
			if(moduleId == 'GIACS047'){
				$("txtBranchCd").value = unescapeHTML2(row.branchCd);
				$("txtBranch").value = unescapeHTML2(row.branchCd);
				$("txtBranchName").value = unescapeHTML2(row.branchName);
				$("txtBranch").setAttribute("lastValidValue", unescapeHTML2(row.branchCd));
				if ($F("txtCoveredFromDate") != "" && $F("txtCoveredToDate") != "") {
					enableToolbarButton("btnToolbarExecuteQuery");
				}
			}else if(moduleId == "GIACS070"){	//added by shan 08.23.2013
				$("hidBranchCd").value = unescapeHTML2(row.branchCd);;
				$("txtBranch").value = unescapeHTML2(row.branchCd)+" - "+unescapeHTML2(row.branchName);
				enableToolbarButton("btnToolbarEnterQuery");
				enableToolbarButton("btnToolbarExecuteQuery");
			}else{
				$("txtBranchCd").value = unescapeHTML2(row.branchCd);
				$("txtBranch").value = unescapeHTML2(row.branchCd)+" - "+unescapeHTML2(row.branchName);
				changeTag = 1;
			}
		},
  		onCancel: function(){
  			if(moduleId == 'GIACS047'){
  				$("txtBranch").value = $("txtBranch").readAttribute("lastValidValue");
  			}else{
  				$("txtBranch").focus();
  			}
  		},
  		onUndefinedRow : function(){
			showMessageBox("No record selected.", "I");
			if(moduleId == 'GIACS047'){
				$("txtBranch").value = $("txtBranch").readAttribute("lastValidValue");
  			}
		},
		onShow : function(){$(this.id+"_txtLOVFindText").focus();}
	});
}