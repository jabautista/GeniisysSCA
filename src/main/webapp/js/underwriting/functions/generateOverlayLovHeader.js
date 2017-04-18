/**
 * Create Header for Overlay LOV
 * @author Jerome Orio
 */
function generateOverlayLovHeader(width, header){
	try{
		return '<label style="width: '+width+'; float: left; height: 20px; line-height: 20px; font-size: 12px; font-weight: bold;" title="'+header+'">'+header+'</label>';
	}catch(e){
		showErrorMessage("generateOverlayLovHeader", e);
	}
}