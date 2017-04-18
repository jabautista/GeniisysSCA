/**
 * Call modal page for Loss Advice in Losses Recov from RI (GIACS009)
 * 
 * @author Jerome Orio 10.22.2010
 * @version 1.0
 * @param
 * @return
 */
function openSearchLossAdvice() {
	Modalbox
			.show(
					contextPath
							+ "/GIACLossRiCollnsController?action=openSearchLossAdvice&ajaxModal=1",
					{
						title : "Search Loss Advice",
						width : 900,
						asynchronous : false
					});
}