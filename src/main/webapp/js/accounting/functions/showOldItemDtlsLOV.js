/**
* Show Old Item Details
* @author Christian Santos
* @date 05.02.2012
* @module GIACS014
*/
function showOldItemDtlsLOV(){
	LOV.show({
		controller: "AccountingLOVController",
		urlParameters: {action: "getOldItemDtlsLOV",
						gaccTranId: objACGlobal.gaccTranId,
						tranYear: $F("ucTranYear"),
						tranMonth: $F("ucTranMonth"),
						tranSeqNo: $F("ucTranSeqNo"),
						oldItemNo: $F("ucOldItemNo")},
		title: "GI Unidentified Collections",
		width: 800,
		height: 482,
		columnModel : [
		               {
		            	   id : "tranYear",
		            	   title: "Tran Year",
		            	   width: '100px',
		            	   titleAlign: 'center',
		            	   align: 'right'
		               },
		               {
		            	   id : "tranMonth",
		            	   title: "Tran Month",
		            	   width: '100px',
		            	   titleAlign: 'center',
		            	   align: 'right',
		            	   renderer: function(value){
		            		   return lpad(value, 2, 0);
		            	   }
		               },
		               {
		            	   id : "tranSeqNo",
		            	   title: "Tran Seq No.",
		            	   width: '100px',
		            	   titleAlign: 'center',
		            	   align: 'right',
		            	   renderer: function(value){
		            		   return lpad(value, 5, 0);
		            	   }
		               },
		               {
		            	   //id : "guncItemNo",
		            	   id : "itemNo",
		            	   title: "Old Item No.",
		            	   width: '110px',
		            	   titleAlign: 'center',
		            	   align: 'right',
		            	   renderer: function(value){
		            		   return lpad(value, 2, 0);
		            	   }
		               },
		               {
		            	   id : "collectionAmt",
		            	   title: "Amount",
		            	   width: '120px',
		            	   titleAlign: 'center',
		            	   align: 'right'
		               },
		               {
		            	   id : "particulars",
		            	   title: "Particulars",
		            	   width: '250px',
		            	   titleAlign: 'center',
		            	   align: 'left'
		               },
		               {
		            	   id : "gaccTranId",
		            	   width: '0',
		            	   visible:false
		               },
		               {
		            	   id : "glAcctName",
		            	   width: '0',
		            	   visible:false
		               },
		               {
		            	   id : "gsltSlTypeCd",
		            	   width: '0',
		            	   visible:false
		               },
		               {
		            	   id : "glAcctId",
		            	   width: '0',
		            	   visible:false
		               },
		               {
		            	   id : "slCd",
		            	   width: '0',
		            	   visible:false
		               },
		               {
		            	   id : "guncTranId",
		            	   width: '0',
		            	   visible:false
		               },
		               {
						   id : 'glAcctCategory',
						   width: '0',
						   visible:false
					   },
					   {
						   id : 'glCtrlAcct',
						   width: '0',
						   visible:false
					   },
					   {
						   id : 'glSubAcct1',
						   width: '0',
						   visible:false
					   },
					   {
						   id : 'glSubAcct2',
						   width: '0',
						   visible:false
					   },
					   {
						   id : 'glSubAcct3',
						   width: '0',
						   visible:false
					   },
					   {
						   id : 'glSubAcct4',
						   width: '0',
						   visible:false
					   },
					   {
						   id : 'glSubAcct5',
						   width: '0',
						   visible:false
					   },
					   {
						   id : 'glSubAcct6',
						   width: '0',
						   visible:false
					   },
					   {
						   id : 'glSubAcct7',
						   width: '0',
						   visible:false
					   },
					   {
						   id : 'slName',
						   width: '0',
						   visible:false
					   }
		              ],
		draggable: true,
		autoSelectOneRecord: true,		// shan 10.29.2013
		onSelect: function(row) {
			$("ucTranYear").value 		= parseInt(row.tranYear).toPaddedString(4);
			$("ucTranMonth").value 		= parseInt(row.tranMonth).toPaddedString(2);
			$("ucTranSeqNo").value 		= parseInt(row.tranSeqNo).toPaddedString(5);
			$("ucOldItemNo").value 		= parseInt(row.itemNo).toPaddedString(2);
			$("ucAmount").value 		= formatCurrency(row.collectionAmt);
			$("ucHiddenAmount").value 	= row.collectionAmt;
			$("ucParticulars").value 	= unescapeHTML2(row.particulars);
			$("glAcctCategory").value 	= parseInt(row.glAcctCategory).toPaddedString(2);
			$("glControlAcct").value 	= parseInt(row.glCtrlAcct).toPaddedString(2);
			$("acctCode1").value 		= parseInt(row.glSubAcct1).toPaddedString(2);
			$("acctCode2").value 		= parseInt(row.glSubAcct2).toPaddedString(2);
			$("acctCode3").value 		= parseInt(row.glSubAcct3).toPaddedString(2);
			$("acctCode4").value 		= parseInt(row.glSubAcct4).toPaddedString(2);
			$("acctCode5").value 		= parseInt(row.glSubAcct5).toPaddedString(2);
			$("acctCode6").value 		= parseInt(row.glSubAcct6).toPaddedString(2);
			$("acctCode7").value 		= parseInt(row.glSubAcct7).toPaddedString(2);
			$("ucAcctName").value 		= row.glAcctName;
			$("ucSlName").value 		= row.slName;
			$("ucHiddenSlTypeCd").value = row.gsltSlTypeCd;
			$("ucHiddenGlAcctId").value = row.glAcctId;
			$("ucHiddenSlCd").value 	= row.slCd;
			$("ucHiddenGuncTranId").value = row.guncTranId;	
			
			//shan 10.29.2013
			$("ucTranYear").setAttribute("lastValidValue", parseInt(row.tranYear).toPaddedString(4));
			$("ucTranMonth").setAttribute("lastValidValue", parseInt(row.tranMonth).toPaddedString(2));
			$("ucTranSeqNo").setAttribute("lastValidValue", parseInt(row.tranSeqNo).toPaddedString(5));
			$("ucOldItemNo").setAttribute("lastValidValue", parseInt(row.itemNo).toPaddedString(2));
		},
		onUndefinedRow: function(){	//shan 10.29.2013
			$("ucTranYear").value = $("ucTranYear").readAttribute("lastValidValue");
			$("ucTranMonth").value = $("ucTranMonth").readAttribute("lastValidValue");
			$("ucTranSeqNo").value = $("ucTranSeqNo").readAttribute("lastValidValue");
			$("ucOldItemNo").value = $("ucOldItemNo").readAttribute("lastValidValue");
			showMessageBox("No record selected.", "I");
		},
		onCancel: function(){	//shan 10.29.2013
			$("ucTranYear").value = $("ucTranYear").readAttribute("lastValidValue");
			$("ucTranMonth").value = $("ucTranMonth").readAttribute("lastValidValue");
			$("ucTranSeqNo").value = $("ucTranSeqNo").readAttribute("lastValidValue");
			$("ucOldItemNo").value = $("ucOldItemNo").readAttribute("lastValidValue");
		}
	});
}
