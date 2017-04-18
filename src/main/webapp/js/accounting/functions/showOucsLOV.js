/**
 * Shows LOV for Department 
 * @author Niknok Orio 
 * @date   06.06.2012
 */
function showOucsLOV(moduleId, fundCd, branchCd, refId, filterText){
	try{
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action: 	"getGiacOucsLOV",
				page :		1,
				fundCd:    	fundCd,
				branchCd:  	branchCd,
				filterText:	filterText == null ? "%" : filterText
			},
			title: "",
			width: 405,
			height: 386,
			columnModel:[
			             	{	id : "oucCd",
								title: "Code",
								width: '78px'
							},
							{	id : "oucName",
								title: "Department Name",
								width: '310px'
							},
							{
								id : 'oucId',
							    width: '0px',
							    visible:false
							} 
						],
			draggable: true,
			filterText: filterText == null ? "%" : filterText,
			autoSelectOneRecord: true,
			onSelect : function(row){
				if (moduleId == "GIACS016"){
					$("txtDspOucName").value = unescapeHTML2(row.oucName);
					$("txtDspDeptCd").value = (row.oucCd);
					$("txtGoucOucId").value = (row.oucId);
	  				$("txtDspDeptCd").focus();
	  				$("txtDspDeptCd").setAttribute("lastValidValue", row.oucCd);
	  				changeTag = 1;
	  				if(refId == null && $F("txtRequestDate") == ""){ // irwin 5.8.2013
	  					$("txtRequestDate").value = objACGlobal.sysdate;
	  				}
	  			}
			},
	  		onCancel: function(){
	  			if (moduleId == "GIACS016"){
	  				$("txtDspDeptCd").focus();
	  				$("txtDspDeptCd").value = $("txtDspDeptCd").getAttribute("lastValidValue");
	  			}
	  		}
		});
	}catch(e){
		showErrorMessage("showOucsLOV",e);
	}
}