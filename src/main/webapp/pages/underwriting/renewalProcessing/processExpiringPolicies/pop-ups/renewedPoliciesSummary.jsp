<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="renewedPoliciesSummaryListingMainDiv" name="renewedPoliciesSummaryListingMainDiv">
	<div id="renewedPoliciesSummaryTableGridDiv">
		<div id="renewedPoliciesSummaryGridDiv" style="height: 301px; margin: 18px;">
			<div id="renewedPoliciesSummaryTableGrid" style="height: 281px; width: 510px;"></div>
		</div>
		<div class="buttonsDiv" align="center" style="margin-top: 5px; margin-bottom: 10px;">
			<input type="button" id="btnOk" name="btnOk" style=" width: 140px;" class="button hover"  value="OK" />
		</div>
	</div>
</div>

<script type="text/javascript">

	try{
		var objRenPolSum = new Object();
		objRenPolSum.objRenPolSumListTableGrid = JSON.parse('${renewedPoliciesSummaryTableGrid}'.replace(/\\/g, '\\\\'));
		objRenPolSum.objRenPolSumList = objRenPolSum.objRenPolSumListTableGrid.rows || [];
		var refreshAction = '${refreshAction}';

		var renPolSumTableModel = {
			url: contextPath+"/GIEXExpiriesVController?action="+refreshAction,
			options:{
				width: '510px'		
			},
			columnModel: [
				{   id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0',
					visible: false
				},
				{ 	id: 'policyNo',
					sortable:	false,
					editable: false,
					title : 'Original Policy Number',
					width : '233px'
				},
				{	id:'parNo',
					sortable:	false,
					editable: false,
					title: 'Renewed Policy / PAR Number',
					width: '245px'
				},{	id:			'samePolnoSw',
					sortable:	false,
					align:		'center',
					title:		'&#160;SP',
					altTitle: 'Same Policy',
					width:		'25px',
					editable:  false,
					hideSelectAllBox: true,
					editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}	
		            	}
		            })
				}
			],
			rows: objRenPolSum.objRenPolSumList
		};

		renewedPoliciesSummaryTableGrid = new MyTableGrid(renPolSumTableModel);
		renewedPoliciesSummaryTableGrid.pager = objRenPolSum.objRenPolSumListTableGrid;
		renewedPoliciesSummaryTableGrid.render('renewedPoliciesSummaryTableGrid');

	}catch(e){
		showErrorMessage("renewedPoliciesSummaryListing", e);
	}

	$("btnOk").observe("click", function(){
		renewedPoliciesSummaryTableGrid.keys.removeFocus(renewedPoliciesSummaryTableGrid.keys._nCurrentFocus, true);
		renewedPoliciesSummaryTableGrid.keys.releaseKeys();
		Windows.close("modal_dialog_renewedPoliciesSummary");
		showProcessExpiringPoliciesPage();
	});
	
</script>