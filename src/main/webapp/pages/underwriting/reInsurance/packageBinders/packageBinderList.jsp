<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="packageBinderListTableGrid" style="position: relative; height: 260px; margin: 10px;"> </div>
<script type="text/javascript">
try{
	var packageBinderListTableGrid = JSON.parse('${packageBinderListTG}');
	var packageBinderListRows = packageBinderListTableGrid.rows || [];
	var currX = null;
	var currY = null;
	
	function populatePolicyNo(obj){
		try{ 
			if (nvl(obj,null) == null){
				currY = null;
				currX = null;
				$("txtDspPolNo").clear();
			}else{
				$("txtDspPolNo").value = obj.dspPolicyNo;
			}	
		}catch(e){
			showErrorMessage("populatePolicyNo", e);	
		}	
	}
	
	var packageBinderListTM = {
			url: contextPath+"/GIRIFrpsRiController?action=getPackageBinderList"+"&packPolicyId="+objGIRIS053A.packPolicyId+"&refresh=1",
			options:{
				pager: { 
				},
				onCellFocus: function(element, value, x, y, id){
					currX = Number(x);
					currY = Number(y);
					populatePolicyNo(objUW.packageBinderListTG.getRow(currY));
					
					if (id == 'recordStatus'){
						var dspGrpBdr = objUW.packageBinderListTG.getValueAt(objUW.packageBinderListTG.getColumnIndex('dspGrpBdr'), currY);
	            		var tag = objUW.packageBinderListTG.getValueAt(objUW.packageBinderListTG.getColumnIndex('recordStatus'), currY);
						if (tag == "Y"){
							if (nvl(dspGrpBdr,"") == ""){
	            				objUW.packageBinderListTG.uncheckRecStatus(currX,currY);
	            				showMessageBox("Cannot reverse package binder which is not yet packaged.", "I");
	            				return;
	            			} 
						} 
	            		checkRevBinder(tag, dspGrpBdr);
					}
					objUW.packageBinderListTG.releaseKeys();
				},
				prePager: function(){
					populatePolicyNo(null);
				},
				onSort: function(){
					populatePolicyNo(null);
				},
				onRemoveRowFocus: function ( x, y, element) {
					populatePolicyNo(null);
					objUW.packageBinderListTG.releaseKeys();
				}
			},
			columnModel:[
	   			{
	   				id: 'divCtrId',
	   			  	width: '0',
	   			  	visible: false 
	   		 	},
	   		 	{
					id: 'dspFrpsNo',
					title: 'FRPS No.',
					width: '90px', 
					visible: true
				},
	   		 	{
					id: 'binderNo',
					title: 'Binder No.',
					width: '90px',  
					visible: true
				},
	   		 	{
					id: 'riSname',
					title: 'Reinsurer',
					width: '225px',  
					visible: true
				},
	   		 	{
					id: 'riShrPct',
					title: 'RI Share %',
					width: '100px',  
					type: 'number',
					geniisysClass: 'rate',
					deciRate: 9,
					visible: true
				},
	   		 	{
					id: 'riTsiAmt',
					title: 'RI TSI Amt.',
					type: 'number',
					geniisysClass: 'money',
					width: '100px',  
					visible: true
				},
	   		 	{
					id: 'riPremAmt',
					title: 'RI Prem Amt.',
					type: 'number',
					geniisysClass: 'money',
					width: '100px',  
					visible: true
				},
				{ 								 
					id: 'recordStatus', 		 
					title: '&#160;R',
				 	altTitle: 'Reverse Package Binder Tag',
				 	titleAlign: 'center',
			 		width: 23,
			 		sortable: false,
				 	editable: true, 			 
				 	hideSelectAllBox: true,
				 	defaultValue: false,
				 	editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
			            	if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}	
		            	}
				 	})	
	   			},
				{
					id: 'dspGrpBdr',
					title: 'Pack Binder No.',
					width: '94px',  
					visible: true
				},
	   			{
	   				id: 'lineCd',
	   			  	width: '0',
	   			  	visible: false 
	   		 	},
	   			{
	   				id: 'frpsYy',
	   			  	width: '0',
	   			  	visible: false 
	   		 	},
	   			{
	   				id: 'frpsSeqNo',
	   			  	width: '0',
	   			  	visible: false 
	   		 	},
	   		 	{
	   				id: 'riCd',
	   			  	width: '0',
	   			  	visible: false 
	   		 	},
	   		 	{
	   				id: 'packBinderId',
	   			  	width: '0',
	   			  	visible: false 
	   		 	},
	   		 	{
	   				id: 'fnlBinderId',
	   			  	width: '0',
	   			  	visible: false 
	   		 	},
	   		 	{
	   				id: 'currencyRt',
	   			  	width: '0',
	   			  	visible: false 
	   		 	},
	   		 	{
	   				id: 'currencyCd',
	   			  	width: '0',
	   			  	visible: false 
	   		 	},
	   			{
	   				id: 'dspPolicyNo',
	   			  	width: '0',
	   			  	visible: false 
	   		 	} 
			],
			resetChangeTag: true,
			requiredColumns: '',
			rows : packageBinderListRows
		};	
				
	objUW.packageBinderListTG = new MyTableGrid(packageBinderListTM);
	objUW.packageBinderListTG.pager = packageBinderListTableGrid; 
	objUW.packageBinderListTG.render('packageBinderListTableGrid');
	
	objGIRIS053A.selectedRowsForReverse = [];
	
	objUW.packageBinderListTG.afterRender = function(){
		if(objGIRIS053A.selectedRowsForReverse.length > 0 && objUW.packageBinderListTG.geniisysRows.length > 0) {			
			for(var i=0; i<objUW.packageBinderListTG.geniisysRows.length; i++){
				for(var k=0; k<objGIRIS053A.selectedRowsForReverse.length; k++){
					if(objGIRIS053A.selectedRowsForReverse[k] == objUW.packageBinderListTG.geniisysRows[i].packBinderId){
						objUW.packageBinderListTG.setValueAt("Y", objUW.packageBinderListTG.getColumnIndex('recordStatus'), i, true);
					}
				}
			}
		}
		
		if(objUW.packageBinderListTG.geniisysRows.length > 0) {
			objGIRIS053A.genSw = objUW.packageBinderListTG.geniisysRows[0].genSw;
			
			$$("div#packageBinderListTableGrid .mtgInputCheckbox").each(function(obj){
				obj.observe("click", function(){
					var rowIndex = this.id.substring(this.id.length - 1);
					if(obj.checked){						
						objGIRIS053A.selectedRowsForReverse.push(objUW.packageBinderListTG.geniisysRows[rowIndex].packBinderId);
					} else {
						var tempPackBinderId = objUW.packageBinderListTG.geniisysRows[rowIndex].packBinderId;
						var tempArray = objGIRIS053A.selectedRowsForReverse.toString();
						objGIRIS053A.selectedRowsForReverse = tempArray.replace(new RegExp(tempPackBinderId, "g"), "").split(",");
						objGIRIS053A.selectedRowsForReverse.clean("");
					}
				});				
			});
		}
	};
	
	function checkRevBinder(tag, binder){
		try{
			for (var i=0; i<objUW.packageBinderListTG.rows.length; i++){
				if (nvl(objUW.packageBinderListTG.rows[i][objUW.packageBinderListTG.getColumnIndex('recordStatus')],null) != tag && 
						nvl(objUW.packageBinderListTG.rows[i][objUW.packageBinderListTG.getColumnIndex('dspGrpBdr')],null) == binder){
					if (tag == "Y"){
						objUW.packageBinderListTG.checkRecStatus(objUW.packageBinderListTG.getColumnIndex('recordStatus'),i);
						objUW.packageBinderListTG.setValueAt("Y",objUW.packageBinderListTG.getIndexOf('recordStatus'),i,false);
					}else{
						objUW.packageBinderListTG.uncheckRecStatus(objUW.packageBinderListTG.getColumnIndex('recordStatus'),i);
						objUW.packageBinderListTG.setValueAt("N",objUW.packageBinderListTG.getIndexOf('recordStatus'),i,false);
					}	
				}
			}	
		}catch(e){
			showErrorMessage("checkRevBinder", e);	
		}
	}	
	
	hideNotice("");
}catch(e){
	showErrorMessage("Package binder listing page", e);
}	
</script>
			