/**
 * Call modal page for Recovery No. Loss Recovery in module GIACS010
 * 
 * @author Jerome Orio 10.06.2010
 * @version 1.0
 * @param
 * @return
 */
function openSearchRecoveryNo() {
	Modalbox
			.show(
					contextPath
							+ "/GIACLossRecoveriesController?action=openSearchRecoveryNoLossRec&ajaxModal=1",
					{
						title : "Search Recovery No.",
						width : 900,
						asynchronous : false
					});
}