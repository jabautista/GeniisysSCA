/**
 * Shows list of Company 
 * @author Steven Ramirez
 * @date 4/26/2013
 * @description the textfield of the LOV is enable.
 * moved by Steve 4/26/2013 from enterJournalEntries.jsp
 */
function showGIACS003CompanyLOV(findText2,moduleId){
	LOV.show({
		controller: "AccountingLOVController",
		urlParameters: {
			action: "getGIACS003CompanyLOV",
			searchString: findText2
		},
		title: "List of Companies",
		width: 455,
		height: 388,
		autoSelectOneRecord: true, //reymon 05062013
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
		filterText: findText2,
		onSelect: function(row) {
			if (moduleId == 'GIACS003') {
				$("txtFundCd").value = unescapeHTML2(row.fundCd);
				$("txtCompany").value = unescapeHTML2(row.fundCd)+" - "+unescapeHTML2(row.fundDesc);
				$("txtBranchCd").clear();
				$("txtBranch").clear();
				$("txtBranch").focus();
				$("txtBranch").readOnly = false;
				enableSearch("searchBranch");
				changeTag = 1;
			} else if(moduleId == 'GIACS047') {
				$("txtFundCd").value = unescapeHTML2(row.fundCd);
				$("txtCompany").setAttribute("lastValidValue", unescapeHTML2(row.fundCd));
				$("txtCompany").value = unescapeHTML2(row.fundCd);
				$("txtCompanyName").value = unescapeHTML2(row.fundDesc);
				$("txtBranchName").clear();
				$("txtBranchCd").clear();
				$("txtBranch").setAttribute("lastValidValue", "");
				$("txtBranch").clear();
				$("txtBranch").focus();
				$("txtBranch").readOnly = false;
				enableSearch("searchBranch");
				enableToolbarButton("btnToolbarEnterQuery");
				disableToolbarButton("btnToolbarExecuteQuery");
			}else if(moduleId == "GIACS070"){ //added by shan 08.23.2013
				$("hidGfunFundCd").value = unescapeHTML2(row.fundCd);
				$("txtCompany").value = unescapeHTML2(row.fundCd)+" - "+unescapeHTML2(row.fundDesc);
				enableToolbarButton("btnToolbarEnterQuery");
				$("txtBranch").readOnly = false;
				$("txtBranch").clear();
				$("txtBranch").focus();
				enableSearch("searchBranchLOV");
				disableToolbarButton("btnToolbarExecuteQuery");
			}
		},
  		onCancel: function(){
  			if (moduleId == 'GIACS003') {
  				$("txtCompany").focus();
			} else if(moduleId == 'GIACS047') {
				$("txtCompany").value = $("txtCompany").readAttribute("lastValidValue");
			}else if(moduleId == 'GIACS070'){
				$("txtCompany").focus();
			}
  		},
  		onUndefinedRow : function(){
			showMessageBox("No record selected.", "I");
			if(moduleId == 'GIACS047'){
				$("txtCompany").value = $("txtCompany").readAttribute("lastValidValue");
  			}
		},
		onShow : function(){$(this.id+"_txtLOVFindText").focus();}
	});
}