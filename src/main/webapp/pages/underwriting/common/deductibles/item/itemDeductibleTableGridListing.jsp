<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="itemDeductibleTable" name="itemDeductibleTable" style="width : 100%;">
	<div id="itemDeductibleTableGridSectionDiv" class="">
		<div id="itemDeductibleTableGridDiv" style="padding: 10px;">
			<div id="itemDeductibleTableGrid" style="height: 198px; width: 900px;"></div>
		</div>
		<div style="height:30px; width: 915px;">
			<table  align="right">
				<tr>
					<td class="rightAligned" style="padding-right: 20px;">Total Deductible Amount:</td>
					<td ><input class="rightAligned" style="width: 166px;"  type="text" id="itemAmtTotal" name="itemAmtTotal" readonly="readonly"/></td>
				</tr>
			</table>
		</div>
	</div>	
</div>

<script type="text/javascript">
	try{		
		var objItemDeductible = JSON.parse('${tgItemDeductibles}');
		var amtTotal = 0;
		var tbItemDeductibles = {
			url : contextPath + "/GIPIWDeductibleController?action=refreshItemDeductibleTable&parId=" + objUWParList.parId + "&itemNo=" + $F("itemNo"),
			options : {
				width : '900px',
				masterDetail : true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					var objSelected = tbgItemDeductible.geniisysRows[y];
					
					tbgItemDeductible.keys.releaseKeys();
					setItemDeductibleForm(objSelected, 2);
				},
				onCellBlur : function(){
					//
				},
				onRemoveRowFocus : function(){
					tbgItemDeductible.keys.releaseKeys();
					setItemDeductibleForm(null, 2);
				},
				beforeSort: function(){ // Nica - 05.24.2012
					if(getAddedAndModifiedJSONObjects(objDeductibles).length > 0 || getDeletedJSONObjects(objDeductibles).length > 0){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
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
					setItemDeductibleForm(null, 2);								
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
					width : '270px',
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
               },
               {
	           		id : 'dedDeductibleCd',
	           		width : '0px',
	           		visible : false
	           }/*,
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
            	}*/
			],
			id : 3,
			rows : objItemDeductible.rows
		};

		tbgItemDeductible = new MyTableGrid(tbItemDeductibles);
		tbgItemDeductible.pager = objItemDeductible;
		tbgItemDeductible._mtgId = 3;
		tbgItemDeductible.render('itemDeductibleTableGrid');
		tbgItemDeductible.name = "tbgItemDeductible";
		tbgItemDeductible.afterRender = function(){			
			//objItemDeductibles = objItemDeductibles.concat(objItemDeductible.allRecords);
			setItemDeductibleForm(null, "2");
			if(tbgItemDeductible.geniisysRows.length != 0){
				amtTotal=tbgItemDeductible.geniisysRows[0].totalDeductible;
			}
			$("itemAmtTotal").value = formatCurrency(amtTotal).truncate(13, "...");
		};
	}catch(e){
		showErrorMessage("Item Deductible Listing", e);
	}
</script>