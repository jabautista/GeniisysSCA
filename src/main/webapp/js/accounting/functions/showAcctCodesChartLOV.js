/**
Shows list of giac account names and codes
* @author m. cadwising
* @date 03.22.2012
* @module GIACS039
*/
function showAcctCodesChartLOV(){
	LOV.show({
		controller : "AccountingLOVController",
		urlParameters : {action : "getAcctCodesChartLOV"},
		title: "Account Codes",
		hideColumnChildTitle: true,
		width: 787,
		height: 386,
		columnModel: [
		/*{
			id : 'dspAcctCd',
			title: 'GL Account Code',
		    width: '250px',
		    align: 'right',
		    titleAlign: 'right',
		    renderer: function(value){
		    	var vStr = value.split("").toString();
		    	return vStr.replace(/\,/g, ' ');
		    }
		},*/
		//Modified GL Codes display. SR-5704 JMM
		{
			id: 'dspAcctCd',
			title: 'GL Account Code',
			width: 270,
			children: [
		
			{
				id : 'glAcctCategory',
				title: '',
				width: 30,
				align: 'right',
			    visible : true
			},
			{
				id : 'glControlAcct',
				title: '',
				width: 30,
				align: 'right',
			    visible : true
			},
			{
				id : 'glSubAcct1',
				title: '',
			    width: 30,
			    align: 'right',
			    visible : true
			},
			{
				id : 'glSubAcct2',
				title: '',
				width: 30,
				align: 'right',
			    visible : true
			},
			{
				id : 'glSubAcct3',
				title: '',
				width: 30,
				align: 'right',
			    visible : true
			},
			{
				id : 'glSubAcct4',
				title: '',
				width: 30,
				align: 'right',
			    visible : true
			},
			{
				id : 'glSubAcct5',
				title: '',
				width: 30,
				align: 'right',
			    visible : true
			},
			{
				id : 'glSubAcct6',
				title: '',
				width: 30,
				align: 'right',
			    visible : true
			},
			{
				id : 'glSubAcct7',
				title: '',
				width: 30,
				align: 'right',
			    visible : true
			},
		]
		},
		{
			id : 'glAcctId',
			title: '',
		    width: '0px',
		    visible : false
		},
		{
			id : 'gsltSlTypeCd',
			title: '',
		    width: '0px',
		    visible : false
		},
		{
			id : 'glAcctName',
			title: 'GL Account Name',
		    width: '482px',
		    align: 'left',
		    titleAlign: 'left'
		}
		
		],
		draggable: true,
		onSelect: function(row) {
			$("hidGlAcctIdInputVat").value = row.glAcctId;
			$("hidGsltSlTypeCdInputVat").value = row.gsltSlTypeCd;
			$("txtGlAcctCategoryInputVat").value = row.glAcctCategory;
			$("txtGlControlAcctInputVat").value = row.glControlAcct;
			$("txtGlSubAcct1InputVat").value = row.glSubAcct1;
			$("txtGlSubAcct2InputVat").value = row.glSubAcct2;
			$("txtGlSubAcct3InputVat").value = row.glSubAcct3;
			$("txtGlSubAcct4InputVat").value = row.glSubAcct4;
			$("txtGlSubAcct5InputVat").value = row.glSubAcct5;
			$("txtGlSubAcct6InputVat").value = row.glSubAcct6;
			$("txtGlSubAcct7InputVat").value = row.glSubAcct7;
			$("txtDspAccountName").value = row.glAcctName;
			
			//marco - 06.19.2013
			$("txtSlNameInputVat").value = "";
			$("hidSlCdInputVat").value = "";
			if($F("hidGsltSlTypeCdInputVat").blank() && !$F("hidGlAcctIdInputVat").blank()){
				$("txtSlNameInputVat").removeClassName("required");
				$("txtSlNameInputVatDiv").removeClassName("required");
				$("txtSlNameInputVat").setStyle({backgroundColor: 'white'});
				$("txtSlNameInputVatDiv").setStyle({backgroundColor: 'white'});
				disableSearch("slCdInputVatDate");
			}else{
				//commented, not required :  shan 11.20.2013 // uncommented : 02.10.2015
				$("txtSlNameInputVat").addClassName("required");	
				$("txtSlNameInputVatDiv").addClassName("required");
				$("txtSlNameInputVat").setStyle({backgroundColor: '#FFFACD'});
				$("txtSlNameInputVatDiv").setStyle({backgroundColor: '#FFFACD'});
				enableSearch("slCdInputVatDate");
			}
		}
	});
}