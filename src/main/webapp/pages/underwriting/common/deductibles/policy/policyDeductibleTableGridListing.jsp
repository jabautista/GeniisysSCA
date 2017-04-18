<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="policyDeductibleTable" name="policyDeductibleTable" style="width : 100%;">
	<div id="policyDeductibleTableGridSectionDiv" class="">
		<div id="policyDeductibleTableGridDiv" style="padding: 10px;">
			<div id="policyDeductibleTableGrid" style="height: 198px; width: 900px;"></div>
		</div>
		<div style="height:30px; width: 915px;">
			<table  align="right">
				<tr>
					<td class="rightAligned" style="padding-right: 20px;">Total Deductible Amount</td>
					<td ><input class="rightAligned" style="width: 166px;"  type="text" id="amtTotal" name="amtTotal" readonly="readonly"/></td>
				</tr>
			</table>
		</div>
	</div>	
</div>

<script type="text/javascript">
	try{		
		var objPolicyDeductible = JSON.parse('${tgPolicyDeductibles}');
		var amtTotal = 0;
		var tbPolicyDeductibles = {
			url : contextPath + "/GIPIWDeductibleController?action=refreshPolicyDeductibleTable&parId=" + objUWParList.parId + "&itemNo=0",
			options : {
				width : '900px',
				masterDetail : true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					var objSelected = tbgPolicyDeductible.geniisysRows[y];
					
					tbgPolicyDeductible.keys.releaseKeys();
					setItemDeductibleForm(objSelected, 1);
				},
				onCellBlur : function(){
					//
				},
				onRemoveRowFocus : function(){
					tbgPolicyDeductible.keys.releaseKeys();
					setItemDeductibleForm(null, 1);
				},
				masterDetailValidation : function(){
					if(getAddedAndModifiedJSONObjects(objDeductibles).length > 0 || getDeletedJSONObjects(objDeductibles).length > 0){
						return true;
					}else{
						return false;
					}
				},
				masterDetailSaveFunc : function(){
					$("btnSave").click();
				},
				masterDetailNoFunc : function(){
					objDeductibles = objItemTempStorage.objGIPIWDeductibles.slice(0);					
					setItemDeductibleForm(null, 1);								
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
				}
			},
			columnModel : [
				{
					id : 'recordStatus',
					width : '20px',
					editor : 'checkbox',
					visible : false
				},
				{
					id : 'divCtrId',
					width : '0px',
					visible : false
				},
				{
					id : 'parId',
					width : '0px',
					visible : false
				},
				{
					id : 'aggregateSw',
					title: '&#160;&#160;A',
					width : '23px',
					align : 'center',
					titleAlign : 'center',
					//defaultValue: "N",
					defaultValue: false,
				  	otherValue: false,				  	
				  	editable: false,
				  	sortable : false,
				  	editor: new MyTableGrid.CellCheckbox({					  	
						getValueOf: function(value){		            		
							//return value == "Y" ? true : false;		
							if (value){
								return "Y";
		            		}else{
								return "N";	
		            		} 		
		            	}})	
				},
				{
					id : 'ceilingSw',
					title: '&#160;&#160;C',
					width : '23px',
					align : 'center',
					titleAlign : 'center',
					//defaultValue: "N",
					defaultValue: false,
				  	otherValue: false,				  	
				  	editable: false,
				  	sortable : false,
				  	editor: new MyTableGrid.CellCheckbox({					  	
						getValueOf: function(value){		            		
							//return value == "Y" ? true : false;		
							if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}            		
		            	}})
				},
				{
					id : 'itemNo',
					title : 'Item No.',
					width : '60px',
					sortable : false,				
					renderer : function(value){
						return lpad(value.toString(), 9, "0");
               		}
               },
               {
					id : 'deductibleTitle',
					title : 'Deductible Title',
					width : '234px',
					filterOption : true
               },
               {
					id : 'deductibleText',
					title : 'Deductible Text',
					width : '250px',
					filterOption : true
               },
               {
					id : "deductibleRate",
					title : "Rate",
					width : '100px',
					align : 'right',			
					renderer : function(value){
						if(value != null){
							return formatToNineDecimal(value);
						}else{
							return "";
						}						
	          		}
			   },
               {
					id : 'deductibleAmount',
					title : 'Amount',
					width : '150px',
					type : 'number',
					geniisysClass : 'money'
               }/*,
               {
	           		id : 'dedDeductibleCd',
	           		width : '0px',
	           		visible : false
	           },
               {
            		id : 'dedLineCd',
            		width : '0px',
            		visible : false
            	},
            	{
            		id : 'dedSublineCd',
            		width : '0px',
            		visible : false
            	},
            	{
            		id : 'userId',
            		width : '0px',
            		visible : false
            	},
            	{
            		id : 'perilCd',
            		width : '0px',
            		visible : false
            	},
            	{
            		id : 'ceilingSw',
            		width : '0px',
            		visible : false
            	},
            	{
            		id : 'dedType',
            		width : '0px',
            		visible : false
            	},
            	{
            		id : 'minimumAmount',
            		width : '0px',
            		visible : false
            	},
            	{
            		id : 'maximumAmount',
            		width : '0px',
            		visible : false
            	},
            	{
            		id : 'rangeSw',
            		width : '0px',
            		visible : false
            	}	*/
			],
			rows : objPolicyDeductible.rows
		};

		tbgPolicyDeductible = new MyTableGrid(tbPolicyDeductibles);
		tbgPolicyDeductible.pager = objPolicyDeductible;
		tbgPolicyDeductible.render('policyDeductibleTableGrid');
		tbgPolicyDeductible.afterRender = function(){			
			objDeductibles = objPolicyDeductible.allRecords.filter(function(obj){	return obj.itemNo == 0;	});
			objItemTempStorage.objGIPIWDeductibles = objPolicyDeductible.allRecords.filter(function(obj){	return obj.itemNo == 0;	}).slice(0);
			setItemDeductibleForm(null, "1");
			if(tbgPolicyDeductible.geniisysRows.length != 0){
				amtTotal=tbgPolicyDeductible.geniisysRows[0].totalDeductible;
			}
			$("amtTotal").value = formatCurrency(amtTotal).truncate(13, "...");
		};		
	}catch(e){
		showErrorMessage("Policy Deductible Listing", e);
	}
</script>