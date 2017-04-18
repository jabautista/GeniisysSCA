/**
 * Shows LOV for Document Cd 
 * @author Niknok Orio 
 * @date   06.05.2012
 */
function showDocumentCdLOV(moduleId, lovDocumentCd, fundCd, branchCd, paramName){
	try{
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action :   lovDocumentCd,
				page : 	   1, 
				fundCd:    fundCd,
				branchCd:  branchCd,
				paramName: paramName	
			},
			title: "",
			width: 430,
			height: 386,
			columnModel:[	
							{
								id : 'documentCd',
								title: 'Code',
							    width: '100px',
							    align: 'left',
							    titleAlign: 'left'
							},
							{
								id : 'documentName',
								title: 'Document Name',
							    width: '305px',
							    align: 'left',
							    titleAlign: 'left'
							},
							{
								id : 'gibrBranchCd',
							    width: '0px',
							    visible:false
							},
							{
								id : 'gibrGfunFundCd',
							    width: '0px',
							    visible:false
							},
							{
								id : 'lineCdTag',
							    width: '0px',
							    visible:false
							},
							{
								id : 'yyTag',
							    width: '0px',
							    visible:false
							},
							{
								id : 'mmTag',
							    width: '0px',
							    visible:false
							} 
						],
			draggable: true,
			onSelect : function(row){
				if (moduleId == "GIACS016"){
					$("varDocumentName").value = unescapeHTML2(row.documentName);
					$("varLineCdTag").value = unescapeHTML2(row.lineCdTag);
					$("varYyTag").value = unescapeHTML2(row.yyTag);
					$("varMmTag").value = unescapeHTML2(row.mmTag);
					$("txtDocumentCd").value = unescapeHTML2(row.documentCd);
					$("txtDocumentCd").focus();
					
					if ($("varLineCdTag").value == "Y"){
						enableSearch("lovLineCd");
						$("lovLineCdDiv").addClassName("required");
						$("txtLineCd").addClassName("required");
					}else{
						disableSearch("lovLineCd");
						$("lovLineCdDiv").removeClassName("required");
						$("txtLineCd").removeClassName("required");
						$("txtLineCd").value = "";
					}	
					changeTag= 1;
				}
			},
	  		onCancel: function(){
	  			if (moduleId == "GIACS016"){
	  				$("txtDocumentCd").focus();
	  			}
	  		}
		});
	}catch(e){
		showErrorMessage("showDocumentCdLOV",e);
	}
}