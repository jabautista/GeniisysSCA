<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<table cellspacing="1"">
	<tr>
		<td>
			<div id="leadPolicyListingDiv" style="padding: 10px 0; margin-left: 15px;">
				<div id="leadPolicyTableGridDiv" style="height: 205px; width: 440px;"></div>
			</div>
		</td>
		<td>
			<div id="leadPolicyListingDiv2" style="padding: 10px 0; float: left; margin-left: 15px;">
				<div id="leadPolicyTableGridDiv2" style="height: 205px; width: 440px;"></div>
			</div>
		</td>
	</tr>
</table>

<script>
	var objLpPeril = new Object();
	objLpPeril.objLpPerilTableGrid = JSON.parse('${leadPolicyPerilTableGrid}'.replace(/\\/g, '\\\\'));
	objLpPeril.objLpPerilListing = objLpPeril.objLpPerilTableGrid.rows || null;

	var lpPerilTableModel = {
		url: contextPath+"/GIPILeadPolicyController?action=refreshLeadPolicyPerilListing&parId="+encodeURIComponent($F("globalParId"))+"&itemNo="+encodeURIComponent($F("selectedItemNo")),
		options:{
			title: '',
			width: '425px',
			onCellFocus: function (element, value, x, y, id) {
				addTableGridRowClassSelectedRow(lpPerilTableGrid2, x, y);
				$('mtgRow'+lpPerilTableGrid._mtgId+'_'+y).scrollIntoView();
				var selectRec = lpPerilTableGrid.getRow(y);
				$("perilDescLbl").value = unescapeHTML2(selectRec.perilName);
				$("perilRemarksLbl").value = unescapeHTML2(selectRec.compRem);
			},
			onRemoveRowFocus: function (element, value, x, y, id) {
				removeTableGridRowClassSelectedRow(lpPerilTableGrid2, x ,y);
				$("perilDescLbl").value = "";
				$("perilRemarksLbl").value = "";
			}
		},
		columnModel: [
		    { id: 'recordStatus',
			  title: '',
			  width: '0',
			  visible: false,
			  editor: 'checkbox'
		    },
		    { id: 'divCtrId',
			  width: '0',
			  visible: false
		    },
		    { id: 'itemNo',
			  width: '0',
			  visible: false
			},
		    {	id: 'perilSname',
			    title: 'Peril',
			    sortable: false,
				width: '80px',
				visible: true
			},
			{	id: 'sharePremiumRate',
				title: 'Rate',
				align: 'right',
				titleAlign: 'right',
				geniisysClass: 'rate',
				sortable: false,
				width: '83.5px',
				visible: true
			},
			{	id: 'shareTsiAmount',
				title: 'TSI Amount',
				align: 'right',
				sortable: false,
				geniisysClass: 'money',
				width: '110px',
				visible: true
			},
			{	id: 'sharePremiumAmount',
				title: 'Premium Amount',
				align: 'right',
				sortable: false,
				geniisysClass: 'money',
				width: '110px',
				visible: true
			},
			{	id: 'discountSw',
				title: '&#160;D',
				sortable: false,
				align: 'center',
				titleAlign: 'center',
				width: '20px',
				visible: true,
				editor:	'checkbox'
			},
			{ id: 'perilName',
			  width: '0',
			  visible: false
			},
			{ id: 'compRem',
			  width: '0',
			  visible: false
			}
		],
		requiredColumns: 'perilSname',
		rows: objLpPeril.objLpPerilListing,
		hideRowsOnLoad: true
	};

	var lpPerilTableModel2 = {
			url: contextPath+"/GIPILeadPolicyController?action=refreshLeadPolicyPerilListing&parId="+encodeURIComponent($F("globalParId"))+"&itemNo="+encodeURIComponent($F("selectedItemNo")),
			options:{
				title: '',
				width: '425px',
				onCellFocus: function (element, value, x, y, id) {
					addTableGridRowClassSelectedRow(lpPerilTableGrid, x, y);
					$('mtgRow'+lpPerilTableGrid2._mtgId+'_'+y).scrollIntoView();
					var selectRec = lpPerilTableGrid.getRow(y);
					$("perilDescLbl").value = unescapeHTML2(selectRec.perilName);
					$("perilRemarksLbl").value = unescapeHTML2(selectRec.compRem);
					
				},
				onRemoveRowFocus: function (element, value, x, y, id) {
					removeTableGridRowClassSelectedRow(lpPerilTableGrid, x,y);
					$("perilDescLbl").value = "";
					$("perilRemarksLbl").value = "";
				}
			},
			columnModel: [
			    { id: 'recordStatus',
				  title: '',
				  width: '0',
				  visible: false,
				  editor: 'checkbox'
			    },
			    { id: 'divCtrId',
				  width: '0',
				  visible: false
			    },
			    { id: 'itemNo',
				  width: '0',
				  visible: false
				},
			    {	id: 'perilSname',
				    title: 'Peril',
				    sortable: false,
					width: '80px',
					visible: true
				},
				{	id: 'premiumRate',
					title: 'Rate',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'rate',
					sortable: false,
					width: '83.5px',
					visible: true
				},
				{	id: 'tsiAmount',
					title: 'TSI Amount',
					align: 'right',
					sortable: false,
					geniisysClass: 'money',
					width: '110px',
					visible: true
				},
				{	id: 'premiumAmount',
					title: 'Premium Amount',
					align: 'right',
					sortable: false,
					geniisysClass: 'money',
					width: '110px',
					visible: true
				},
				{	id: 'discountSw',
					title: '&#160;D',
					sortable: false,
					align: 'center',
					titleAlign: 'center',
					width: '20px',
					visible: true,
					editor:	'checkbox'
				},
				{ id: 'perilName',
				  width: '0',
				  visible: false
				},
				{ id: 'compRem',
				  width: '0',
				  visible: false
				}
			],
			requiredColumns: 'perilSname',
			rows: objLpPeril.objLpPerilListing,
			hideRowsOnLoad: true
		};

	lpPerilTableGrid = new MyTableGrid(lpPerilTableModel);
	lpPerilTableGrid.pager = "";
	lpPerilTableGrid.render('leadPolicyTableGridDiv');

	lpPerilTableGrid2 = new MyTableGrid(lpPerilTableModel2);
	lpPerilTableGrid2.pager = "";
	lpPerilTableGrid2.render('leadPolicyTableGridDiv2');

</script>