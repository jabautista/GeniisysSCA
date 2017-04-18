/**
 * Shows giac inst no list of values
 * @author d.alcantara
 * @module GIACS030
 */

//modified by Christian Santos 05.31.2012
function showChartOfAcctsLOV(notIn, obj, acctName) {
	LOV.show({
		controller: "AccountingLOVController",
		urlParameters: {
			action: "getChartOfAcctsLOV",
			notIn: notIn,
			glObj: obj,
			acctName: acctName,
			page: 1
		},
		title: "Search GL Account Code", //"GIAC Chart of Accounts",
		hideColumnChildTitle: true,
		width: 800,
		height: 403,
		columnModel: [
		     {
	        	   id : 'glAcctCategory glControlAcct glSubAcct1 glSubAcct2 glSubAcct3 glSubAcct4 glSubAcct5 glSubAcct6 glSubAcct7',
	        	   title: 'Acct Code',
	        	   width: 270,
	        	   children: [
	        	               {
								   id : 'glAcctCategory',
								   width: 30,
								   align: 'right'/*,
								   renderer: function(value){
				            		   return lpad(value, 2, 0);
				            	   }*/
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
				   id: "glAcctName",
				   title: "GL Account Name",
				   width: '360px',
				   titleAlign: 'left',
				   align: 'left'
			},
			{
				   id: "glAcctId",
				   title: "GL Acct Id",
				   width: '67px',
				   align: 'right'
			},
			{
				   id: "gsltSlTypeCd",
				   title: "SL Type Cd",
				   width: '67px',
				   align: 'right'
			}
		],
		draggable: true,
		onSelect: function(row) {
			$("inputGlAcctCtgy").value 	= parseInt(row.glAcctCategory);
			$("inputGlCtrlAcct").value 	= parseInt(row.glControlAcct).toPaddedString(2);
			$("inputSubAcct1").value 	= parseInt(row.glSubAcct1).toPaddedString(2);
			$("inputSubAcct2").value 	= parseInt(row.glSubAcct2).toPaddedString(2);
			$("inputSubAcct3").value 	= parseInt(row.glSubAcct3).toPaddedString(2);
			$("inputSubAcct4").value 	= parseInt(row.glSubAcct4).toPaddedString(2);
			$("inputSubAcct5").value 	= parseInt(row.glSubAcct5).toPaddedString(2);
			$("inputSubAcct6").value 	= parseInt(row.glSubAcct6).toPaddedString(2);
			$("inputSubAcct7").value 	= parseInt(row.glSubAcct7).toPaddedString(2);
			$("inputGlAcctName").value 	= unescapeHTML2(row.glAcctName); //added unescapeHTML2 by robert 10.19.2013
			$("hiddenGlAcctId").value 	= row.glAcctId;
			$("hiddenSlTypeCd").value 	= row.gsltSlTypeCd;
			validateGlAcctId(row.glAcctId, row.gsltSlTypeCd);	//Gzelle 11062015 KB#132
			hideOverlay();
			if(row.gsltSlTypeCd == null || row.gsltSlTypeCd == "") {
				$("inputSlName").removeClassName("required");
				$("selectSlDiv").removeClassName("required");
				$("inputSlName").style.backgroundColor = "#FFFFFF";
				disableSearch("searchSlCd");
			} else {
				if ($("hiddenSlTypeCd").getAttribute("isSlExisting") == "Y") {
					$("inputSlName").addClassName("required");
					$("selectSlDiv").addClassName("required");
					$("inputSlName").style.backgroundColor = "#FFFACD";
				}else {
					$("inputSlName").removeClassName("required");
					$("selectSlDiv").removeClassName("required");
					$("inputSlName").style.backgroundColor = "#FFFFFF";
				}
				enableSearch("searchSlCd");
			}
		},
		prePager: function(){
			tbgLOV.request.notIn = notIn;
		}
	});
}