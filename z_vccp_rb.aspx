<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"> </script>
		<script src='../script/qj2.js' type="text/javascript"> </script>
		<script src='qset.js' type="text/javascript"> </script>
		<script src='../script/qj_mess.js' type="text/javascript"> </script>
		<script src="../script/qbox.js" type="text/javascript"> </script>
		<script src='../script/mask.js' type="text/javascript"> </script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"> </script>
		<script src="css/jquery/ui/jquery.ui.widget.js"> </script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"> </script>
		<script type="text/javascript">
			var t_first=true;
            if (location.href.indexOf('?') < 0) {
                location.href = location.href + "?;;;;"+((new Date()).getUTCFullYear()-1911);
            }
            $(document).ready(function() {
            	q_getId();
                q_gf('', 'z_vccp_rb');
                
                $('#q_report').click(function(e) {
					if(window.parent.q_name=="vcca"){
						var delete_report=999;
						for(var i=0;i<$('#q_report').data().info.reportData.length;i++){
							if($('#q_report').data().info.reportData[i].report=='z_vccp_rb01')
								delete_report=i;
						}
						if($('#q_report div div').text().indexOf('出貨單列印')>-1){
							$('#q_report div div').eq(delete_report).hide();
						}
						delete_report=999;
						for(var i=0;i<$('#q_report').data().info.reportData.length;i++){
							if($('#q_report').data().info.reportData[i].report=='z_vccp_rb03')
								delete_report=i;
						}
						if($('#q_report div div').text().indexOf('劃撥單列印')>-1){
							$('#q_report div div').eq(delete_report).hide();
						}
						delete_report=999;
						for(var i=0;i<$('#q_report').data().info.reportData.length;i++){
							if($('#q_report').data().info.reportData[i].report=='z_vccp_rb04')
								delete_report=i;
						}
						if($('#q_report div div').text().indexOf('信用卡單')>-1){
							$('#q_report div div').eq(delete_report).hide();
						}
						
						$('#q_report div div .radio').parent().each(function(index) {
							if(!$(this).is(':hidden') && t_first){
								$(this).children().removeClass('nonselect').addClass('select');
								t_first=false;
							}
							if($(this).is(':hidden') && t_first){
								$(this).children().removeClass('select').addClass('nonselect');
							}
						});
					}
				});
                
            });
            function q_gfPost() {
				$('#q_report').q_report({
					fileName : 'z_vccp_rb',
					options : [{
						type : '0', //[1]
						name : 'accy',
						value : r_accy
					},  {
						type : '1', //[2][3]
						name : 'xnoa'
					}, {
						type : '1', //[4][5]
						name : 'date'
					}, {
						type : '1', //[6][7]
						name : 'invo'
					},{
						type : '8',//[8]
						name : 'xshowprice',
						value : "1@".split(',')
					}]
				});
                q_popAssign();
                q_getFormat();
				q_langShow();
                	
				$('#txtDate1').mask('999/99/99');
				//$('#txtDate1').datepicker();
				$('#txtDate2').mask('999/99/99');
				//$('#txtDate2').datepicker();  
	                
	            var t_noa=q_getHref()[1]=='undefined'?'':q_getHref()[1];
                $('#txtXnoa1').val(t_noa);
                $('#txtXnoa2').val(t_noa);
                
                var t_invo=q_getHref()[3]=='undefined'?'':q_getHref()[3];
                if(t_invo.indexOf(',')>-1){
                	$('#txtInvo1').val(t_invo.split(',')[0]);
                	$('#txtInvo2').val(t_invo.split(',')[t_invo.split(',').length-1]);
                }else{
                	$('#txtInvo1').val(t_invo);
                	$('#txtInvo2').val(t_invo);
                }
				var t_date,t_year,t_month,t_day;
				t_date = new Date();
				t_date.setDate(1);
				t_year = t_date.getUTCFullYear()-1911;
				t_year = t_year>99?t_year+'':'0'+t_year;
				t_month = t_date.getUTCMonth()+1;
				t_month = t_month>9?t_month+'':'0'+t_month;
				t_day = t_date.getUTCDate();
				t_day = t_day>9?t_day+'':'0'+t_day;
				$('#txtDate1').val(t_year+'/'+t_month+'/'+t_day);
	                
				t_date = new Date();
				t_date.setDate(35);
				t_date.setDate(0);
				t_year = t_date.getUTCFullYear()-1911;
				t_year = t_year>99?t_year+'':'0'+t_year;
				t_month = t_date.getUTCMonth()+1;
				t_month = t_month>9?t_month+'':'0'+t_month;
				t_day = t_date.getUTCDate();
				t_day = t_day>9?t_day+'':'0'+t_day;
				$('#txtDate2').val(t_year+'/'+t_month+'/'+t_day);
	                
				$("input[type='checkbox'][value!='']").attr('checked', true);
				
				var t_ordeno=q_getHref()[5]=='undefined'?'':q_getHref()[5];
				if(t_ordeno!=''){
					var t_where = " where=^^ noa=(select MIN(noa) from view_vcc where charindex('"+t_ordeno+"',ordeno)=1) ^^";
					q_gt('view_vcc', t_where, 0, 0, 0, 'view_vcc', r_accy);
				}
				
				$('#q_report div div .radio.select').click();
            }

            function q_boxClose(s2) {
            }
            
            function q_gtPost(t_name) {
            	switch (t_name) {
            		case 'view_vcc':
            			var as = _q_appendData("view_vcc", "", true);
						if (as[0] != undefined) {
							var t_noa=q_getHref()[1]=='undefined'?'':q_getHref()[1];
							if(as[0].noa!=t_noa){
								//第二次出貨 代表上次發票已隨貨全開完
								var delete_report=999;
								for(var i=0;i<$('#qReport').data().info.reportData.length;i++){
									if($('#qReport').data().info.reportData[i].report=='z_vccp_rb02')
										delete_report=i;
								}
								if($('#qReport div div').text().indexOf('發票列印')>-1)
									$('#qReport div div').eq(delete_report).hide();
							}
						}
            		break;
            	}
            }
            
		</script>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<div id="q_menu"> </div>
		<div style="position: absolute;top: 10px;left:50px;z-index: 1;width:2000px;">
			<div id="container">
				<div id="q_report"> </div>
			</div>
			<div class="prt" style="margin-left: -40px;">
				<!--#include file="../inc/print_ctrl.inc"-->
			</div>
		</div>
	</body>
</html>
           
          