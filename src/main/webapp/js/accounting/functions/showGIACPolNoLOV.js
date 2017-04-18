/**
Shows list of Policy Numbers for GIAC Premium Deposit
* @author emsy bolaños
* @date 06.13.2012
* @module GIACS026
*/
function showGIACPolNoLOV(){
	try{
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action   : "getGiacPolNoLOV",
				moduleId : "GIACS026",
				assdNo	 : $F("txtAssdNo"), //added by steven 12/18/2012
					page : 1
			},
			title: "Search Policy No",
			width: 550,
			height: 400,
			columnModel: [
	 			{
					id : 'policyNo',
					title: 'Policy No',
					width : '170px',
					align: 'left',
					titleAlign : 'left'
				},
				{
					id : 'assuredName',
					title: 'Assured Name',
				    width: '210px',
				    align: 'left'
				},
				{
					id : 'endtSeqNo',
					title: 'Endt Seq No',
				    width: '100px',
				    align: 'right',
				    titleAlign: 'right'
				},
				{
					id : 'lineCd',
				    width: '0px',
				    visible: false
				},
				{
					id : 'sublineCd',
				    width: '0px',
				    visible: false
				},
				{
					id : 'issCd',
				    width: '0px',
				    visible: false
				},
				{
					id : 'issueYy',
				    width: '0px',
				    visible: false
				},
				{
					id : 'polSeqNo',
				    width: '0px',
				    visible: false
				},
				{
					id : 'renewNo',
				    width: '0px',
				    visible: false
				}
			],
			draggable: true,
			onSelect: function(row) {
				if(row != undefined){
					$("txtLineCd").value = row.lineCd;
					$("txtSublineCd").value = row.sublineCd;
					$("txtIssCd").value = row.issCd;
					$("txtIssueYy").value = row.issueYy;
					$("txtPolSeqNo").value = parseInt(row.polSeqNo).toPaddedString(6);
					$("txtRenewNo").value = row.renewNo;
					$("txtPolicyNo").value = row.policyNo;
					
					$("txtParNo").value	= (row.parLineCd == null || row.parLineCd == "") && (row.parSeqNo == null || row.parSeqNo == "") ? "" : unescapeHTML2(row.dspParNo);
					
					$("txtParLineCd").value	= nvl(row.parLineCd,"");
					$("txtParIssCd").value = nvl(row.parIssCd,"");
					$("txtParYy").value = nvl(row.parYy,"");
					$("txtParSeqNo").value = row.parSeqNo == null || row.parSeqNo == "" ? "" : parseInt(row.parSeqNo).toPaddedString(6);	
					$("txtQuoteSeqNo").value = nvl(row.quoteSeqNo,"");
					
					
					$("txtAssdNo").value = row.assdNo;
					$("txtDrvAssuredName").value =  unescapeHTML2(row.assdNo + " - " +  row.assuredName); //added by steven 12/18/2012
					$("txtAssuredName").value = unescapeHTML2(row.assuredName); //added by steven 12/18/2012
					
					
											
				}
			},
			onCancel: function(){
	  			$("txtPolicyNo").focus();
	  		}
		});
	}catch(e){
		showErrorMessage("showGIACPolNoLOV",e);
	}
}