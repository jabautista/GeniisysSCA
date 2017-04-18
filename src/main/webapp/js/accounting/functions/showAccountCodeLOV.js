/**
* List of Values: Account Code
* @author Christian Santos
* @date 05.03.2012
* @module GIACS014
*/
function showAccountCodeLOV(){
	LOV.show({
		controller: "AccountingLOVController",
		urlParameters: {action: "getAccountCodeLOV",
						glAcctCategory: $F("glAcctCategory"),
						glControlAcct: $F("glControlAcct"),
						glSubAcct1: $F("acctCode1"),
						glSubAcct2: $F("acctCode2"),
						glSubAcct3: $F("acctCode3"),
						glSubAcct4: $F("acctCode4"),
						glSubAcct5: $F("acctCode5"),
						glSubAcct6: $F("acctCode6"),
						glSubAcct7: $F("acctCode7")},
		title: "List of Values: Account Code",
		hideColumnChildTitle: true,
		width: 800,
		height: 403,
		columnModel : [
		               {
		            	   id : 'glAcctCategory glControlAcct glSubAcct1 glSubAcct2 glSubAcct3 glSubAcct4 glSubAcct5 glSubAcct6 glSubAcct7',
		            	   title: 'Acct Code',
		            	   width: 270,
		            	   children: [
		            	               {
										   id : 'glAcctCategory',
										   width: 30,
										   align: 'right',
										   renderer: function(value){
						            		   return lpad(value, 2, 0);
						            	   }
									   },
									   {
										   id : 'glControlAcct',
										   width: 30,
										   align: 'right',
										   renderer: function(value){
						            		   return lpad(value, 2, 0);
						            	   }
									   },
									   {
										   id : 'glSubAcct1',
										   width: 30,
										   align: 'right',
										   renderer: function(value){
						            		   return lpad(value, 2, 0);
						            	   }
									   },
									   {
										   id : 'glSubAcct2',
										   width: 30,
										   align: 'right',
										   renderer: function(value){
						            		   return lpad(value, 2, 0);
						            	   }
									   },
									   {
										   id : 'glSubAcct3',
										   width: 30,
										   align: 'right',
										   renderer: function(value){
						            		   return lpad(value, 2, 0);
						            	   }
									   },
									   {
										   id : 'glSubAcct4',
										   width: 30,
										   align: 'right',
										   renderer: function(value){
						            		   return lpad(value, 2, 0);
						            	   }
									   },
									   {
										   id : 'glSubAcct5',
										   width: 30,
										   align: 'right',
										   renderer: function(value){
						            		   return lpad(value, 2, 0);
						            	   }
									   },
									   {
										   id : 'glSubAcct6',
										   width: 30,
										   align: 'right',
										   renderer: function(value){
						            		   return lpad(value, 2, 0);
						            	   }
									   },
									   {
										   id : 'glSubAcct7',
										   width: 30,
										   align: 'right',
										   renderer: function(value){
						            		   return lpad(value, 2, 0);
						            	   }
									   }
					       ]
		               },
		               {
		            	   id : 'glAcctName',
		            	   title: 'Account Name',
		            	   width: '400px',
		            	   align: 'left'
		               },
		               {
		            	   id : 'gsltSlTypeCd',
		            	   title: 'SL Type',
		            	   width: '100px',
		            	   align: 'left'
		               },
		               {
		            	   id : 'glAcctId',
		            	   width: '0',
		            	   visible: false
		               }
		               /*,
		               {
		            	   id : "slCd",
		            	   width: '0',
		            	   visible:false
		               }*/
		              ],
		draggable: true,
			onSelect: function(row) {
				$("glAcctCategory").value 	= parseInt(row.glAcctCategory).toPaddedString(2);
				$("glControlAcct").value 	= parseInt(row.glControlAcct).toPaddedString(2);
				$("acctCode1").value 		= parseInt(row.glSubAcct1).toPaddedString(2);
				$("acctCode2").value 		= parseInt(row.glSubAcct2).toPaddedString(2);
				$("acctCode3").value 		= parseInt(row.glSubAcct3).toPaddedString(2);
				$("acctCode4").value 		= parseInt(row.glSubAcct4).toPaddedString(2);
				$("acctCode5").value 		= parseInt(row.glSubAcct5).toPaddedString(2);
				$("acctCode6").value 		= parseInt(row.glSubAcct6).toPaddedString(2);
				$("acctCode7").value 		= parseInt(row.glSubAcct7).toPaddedString(2);
				$("ucAcctName").value 		= row.glAcctName;
				//$("ucHiddenSlCd").value 	= row.slCd;
				$("ucHiddenSlTypeCd").value = row.gsltSlTypeCd;
				$("ucHiddenGlAcctId").value = row.glAcctId;
				
				if ($F("ucHiddenSlTypeCd") == ""){
					$("ucSlName").readOnly = true;
					$("ucSlName").style.backgroundColor = "#FFFFFF";
					$("slNameDiv").removeClassName("required");
					$("ucSlName").value = "";
					disableSearch("oscmSlName");
				}else{
					$("ucSlName").readOnly = false;
					$("ucSlName").style.backgroundColor ="#FFFACD";
					$("slNameDiv").addClassName("required");
					enableSearch("oscmSlName");
				}
		}
	});
}