<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"></script>
		<script src="css/jquery/ui/jquery.ui.widget.js"></script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
		<script type="text/javascript">
			this.errorHandler = null;
			function onPageError(error) {
				alert("An error occurred:\r\n" + error.Message);
			}

			q_tables = 't';
			var q_name = "vcca";
			var q_readonly = ['txtMoney', 'txtTotal', 'txtChkno', 'txtTax', 'txtAccno', 'txtWorker','txtVccno'];
			var q_readonlys = ['txtOrdeno','txtNo2'];
			var q_readonlyt = ['txtVccaccy','txtVccno','txtVccnoq'];
			var bbmNum = [['txtMoney', 15, 0,1], ['txtTax', 15, 0,1], ['txtTotal', 15, 0,1], ['textTotal', 15, 0,1], ['textMoney', 15, 0,1]];
			var bbsNum = [['txtMount', 15, 0,1], ['txtPrice', 15, 3,1], ['txtTotal', 15, 0,1]];
			var bbtNum = [['txtMoney',15,0,1]];
			var bbmMask = [];
			var bbsMask = [];
			var bbtMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'Noa';
			aPop = new Array(['txtCno', 'lblAcomp', 'acomp', 'noa,acomp', 'txtCno,txtAcomp', 'acomp_b.aspx']
			, ['txtAddress', '', 'view_road', 'memo,zipcode', '0txtAddress,txtZip', 'road_b.aspx']
			, ['txtCustno', 'lblCust', 'cust', 'noa,comp,nick,serial,zip_invo,addr_invo', 'txtCustno,txtComp,txtNick,txtSerial,txtZip,txtAddress', 'cust_b.aspx']
			, ['txtBuyerno', 'lblBuyer', 'cust', 'noa,comp', 'txtBuyerno,txtBuyer', 'cust_b.aspx']
			, ['txtProductno_', 'btnProductno_', 'ucca', 'noa,product,unit', 'txtProductno_,txtProduct_,txtUnit_', 'ucca_b.aspx']
			
			, ['textBuyerno', '', 'cust', 'noa,comp,serial', 'textBuyerno,textBuyer,textSerial', 'cust_b.aspx']
			, ['textOrdeno', '', 'view_orde', 'noa,total,comp', 'textOrdeno,textTotal', 'orde_b.aspx']
			);
			q_xchg = 1;
			q_desc = 1;
			q_copy = 1;
			brwCount2 = 20;

			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				bbtKey = ['noa', 'noq'];
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1);
			});

			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}
				mainForm(1);
			}

			function mainPost() {
				q_getFormat();
				bbmMask = [['txtDatea', r_picd], ['txtMon', r_picm]];
				q_mask(bbmMask);
				q_cmbParse("cmbTaxtype", q_getPara('sys.taxtype'));
				
				$('#lblTrdno').text('訂單號碼');

				$('#cmbTaxtype').focus(function() {
					var len = $("#cmbTaxtype").children().length > 0 ? $("#cmbTaxtype").children().length : 1;
					$("#cmbTaxtype").attr('size', len + "");
				}).blur(function() {
					$("#cmbTaxtype").attr('size', '1');
				}).change(function(e) {
					sum();
				}).click(function(e) {
					sum();
				});
				
				$('#txtNoa').change(function(e) {
					$('#txtNoa').val($('#txtNoa').val().toUpperCase());
				}).click(function() {
					if(q_cur==1)
						q_msg($(this),'發票號碼保持空白，電子發票號碼將由系統自動產生');
				});
				
				$('#txtTax').change(function() {
					sum();
				});
				
				$('#chkAtax').change(function() {
					sum();
				});
				
				$('#txtMoney').change(function() {
					sum();
				});
				
				$('#lblAccno').click(function() {
					q_pop('txtAccno', "accc.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";accc3='" + $('#txtAccno').val() + "';" + $('#txtDatea').val().substring(0, 3) + '_' + r_cno, 'accc', 'accc3', 'accc2', "92%", "1054px", q_getMsg('popAccc'), true);
				});
				
				$('#lblTrdno').click(function() {
					q_pop('txtTrdno', "orde_rb.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa='" + $('#txtTrdno').val() + "';" + r_accy + '_' + r_cno, 'orde', 'noa', 'odate', "95%", "95%", q_getMsg('popOrde'), true);
				});
				
				$('#lblVccno').click(function() {
					t_vccno = $('#txtVccno').val();
					
					if(t_vccno.length>0){
						q_pop('txtVccno', "vcc_rb.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa='" + $('#txtVccno').val() + "';" + ($('#txtDatea').val().substring(0, 3)<'101'?r_accy:$('#txtDatea').val().substring(0, 3)) + '_' + r_cno, 'vcc', 'noa', 'datea', "95%", "95%", q_getMsg('popVcc'), true);
					}
				});
				
				$('#btnOrdes').click(function() {
					if(q_cur==1 || q_cur==2){
						var t_ordeno = trim($('#txtTrdno').val());
						if (t_ordeno.length > 0) {
							var t_where=" a.noa='"+t_ordeno+"' ";
							t_where=t_where+" group by b.noa,b.no2,b.productno,b.product,b.unit,case when a.taxtype='3' then case when b.mount=0 then round(b.price/1.05,2) else round((b.total/1.05/b.mount),2) end else b.price end,c.vmount ";
							t_where=t_where+" having SUM(b.mount)-sum(isnull(c.vmount,0))>0 ";
							q_gt('orde_vcca_rb2', "where=^^ "+t_where+" ^^", 0, 0, 0, "",'');
							//q_box("ordes_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";"+t_where + ";" + r_accy, 'ordes', "95%", "95%", q_getMsg("popOrdes"));
							var t_where=" noa='"+t_ordeno+"' ";
							q_gt('view_orde', "where=^^ "+t_where+" ^^", 0, 0, 0, "getorde",'');
						}else{
							alert('訂單編號禁止空白!!');
						}
					}
				});
				
				$('#btnOrdesMon').click(function() { //月結匯入
					if(q_cur==1 || q_cur==2){
						var t_custno = trim($('#txtCustno').val());
						var t_mon=trim($('#txtMon').val());
						if (t_custno.length > 0 && t_mon.length>0) {
							var t_where=" a.custno='"+t_custno+"' and a.mon='"+t_mon+"' ";
							t_where=t_where+" group by b.productno,b.product,b.unit,case when a.taxtype='3' then case when b.mount=0 then round(b.price/1.05,2) else round((b.total/1.05/b.mount),2) end else b.price end,c.vmount ";
							t_where=t_where+" having SUM(b.mount)-sum(isnull(c.vmount,0))>0 ";
							q_gt('orde_vcca_rb', "where=^^ "+t_where+" ^^", 0, 0, 0, "",'');	
							
							//q_gt('view_ordes', "where=^^ exists (select * from view_orde where noa=view_ordes.noa and custno='"+t_custno+"' and mon='"+t_mon+"') and not exists (select * from vcca where charindex(view_ordes.noa,trdno)>0 ) ^^", 0, 0, 0, "",'');
						}else{
							alert('銷貨客戶與帳款月份禁止空白!!');
						}
					}
				});
				
				//105/05/30 增加 只需匯入出貨資料不管其他已出貨判斷
				$('#btnVcc_rb').click(function() {
					if($('#txtMemo').val()){
						var t_where="where=^^ noa='"+$('#txtMemo').val()+"'^^ ";
						q_gt('view_vccs', t_where, 0, 0, 0, "getvccs",r_accy,1);
						var as = _q_appendData("view_vccs", "", true);
						if (as[0] != undefined) {
							q_gridAddRow(bbsHtm, 'tbbs', 'txtProductno,txtProduct,txtUnit,txtMount,txtPrice,txtMoney'
							, as.length, as, 'productno,product,unit,mount,price,total', 'txtProductno');
						}else{
							alert('無此出貨單號');
						}
					}else{
						alert('無出貨單號，請於【備註】欄內輸入!!');	
					}
				});
				
				$('#btnBatchvcca').click(function() {
					$("#table_batchvcca input[type='text']").val('');
					$('.batchbuyer').remove();
					var SeekF= new Array();
						$("#table_batchvcca input[type='text']").each(function() {
							if($(this).attr('disabled')!='disabled')
								SeekF.push($(this).attr('id'));
						});
						
						SeekF.push('btnOk_div_batchvcca');
						
						$("#table_batchvcca input[type='text']").each(function() {
							$(this).keydown(function(event) {
								if( event.which == 13) {
									$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).focus();
									$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).select();
								}
							});
						});
						
						$('#table_ordb td .num').each(function() {
							$(this).keyup(function() {
								var tmp=$(this).val();
								tmp=tmp.match(/\d{1,}\.{0,1}\d{0,}/);
								$(this).val(tmp);
							});
						});
						
						if(window.parent.q_name == 'orde'){
							var wParent = window.parent.document;
							$('#textOrdeno').val(wParent.getElementById("txtNoa").value);
							$('#textTotal').val(wParent.getElementById("txtTotal").value);
						}
					
					$('#div_batchvcca').show();
				});
				
				$('#textOrdeno').focusin(function() {
					q_cur=2;
				}).blur(function() {
					q_cur=0;
				});
				
				$('#textBuyerno').focusin(function() {
					q_cur=2;
				}).blur(function() {
					q_cur=0;
				});
				
				$('#btnOk_div_batchvcca').click(function() {
					if(!emp($('#textOrdeno').val())){
						if(!batch_orde){
							q_gt('view_orde', "where=^^ noa='"+$('#textOrdeno').val()+"' ^^", 0, 0, 0, "", r_accy);
							return;
						}
						if(q_float('textTotal')>0 && q_float('textMoney')>0){
							if(q_float('textTotal')%q_float('textMoney')==0){
								var t_buyerno='';
								var t_buyer='';
								var t_serial='';
								for(var i=0;i<($('.batchbuyer').length-1);i++){
									t_buyerno=t_buyerno+(t_buyerno.length>0?'^^':'')+$('#textBuyerno_'+i).val();
									t_buyer=t_buyer+(t_buyer.length>0?'^^':'')+$('#textBuyer_'+i).val();
									t_serial=t_serial+(t_serial.length>0?'^^':'')+$('#textSerial_'+i).val();
								}
								$('#textBuyerno').val(t_buyerno);
								$('#textBuyer').val(t_buyer);
								$('#textSerial').val(t_serial);
								
								var t_ordeno=$('#textOrdeno').val();
								var t_total=dec($('#textTotal').val());
								var t_money=dec($('#textMoney').val());
								var t_vccano=emp(trim($('#textVccano').val()))?'#non':$('#textVccano').val();
								t_buyerno=emp(trim($('#textBuyerno').val()))?'#non':$('#textBuyerno').val();
								t_buyer=emp(trim($('#textBuyer').val()))?'#non':$('#textBuyer').val();
								t_serial=emp(trim($('#textSerial').val()))?'#non':$('#textSerial').val();
								
								q_func('qtxt.query.vcca_rb','vcca.txt,batchvcca_rb,'+encodeURI(t_ordeno) 
								+ ';' + encodeURI(t_total) + ';' + encodeURI(t_money) + ';' + encodeURI(t_buyerno)+ ';' + encodeURI(t_buyer) 
								+ ';' + encodeURI(t_serial) + ';' + encodeURI(t_vccano) + ';' + encodeURI(r_name));
								
								$('#btnOk_div_batchvcca').attr('disabled','disabled').val('開立中...');
							}else{
								alert('訂單金額輸入除不盡!!');
							}
						}else{
							alert('訂單金額與分開金額不可為0!!');
						}
						batch_orde=false;
					}else{
						alert('訂單編號禁止空白!!');
					}
				});
				
				$('#btnClose_div_batchvcca').click(function() {
					$('#div_batchvcca').hide();
				});
				
				$('#textOrdeno').change(function() {
					$('.batchbuyer').remove();
					if(q_float('textTotal')>0 && q_float('textMoney')>0){
						if(q_float('textTotal')%q_float('textMoney')==0){
							batchbuyerrow();
						}else{
							alert('訂單金額輸入除不盡!!');
						}
					}
				});
				
				$('#textMoney').change(function() {
					$('.batchbuyer').remove();
					if(q_float('textTotal')>0 && q_float('textMoney')>0){
						if(q_float('textTotal')%q_float('textMoney')==0){
							batchbuyerrow();
						}else{
							alert('訂單金額輸入除不盡!!');
						}
					}
				});
			}
			function batchbuyerrow() {
				var tr_row=q_div(q_float('textTotal'),q_float('textMoney'));
				rowslength=0;
				//標題列
				var tr = document.createElement("tr");
				tr.className = "batchbuyer";
				tr.id = "batchvcca_title";
				tr.innerHTML = "<td id='nostitle' style='text-align: center;width:40px;'>序</td>";
				tr.innerHTML += "<td id='buyernotitle' style='text-align: center;width:100px;'>買受人編號</td>";
				tr.innerHTML+= "<td id='buyertitle' style='text-align: center;width:180px;'>買受人名稱</td>";
				tr.innerHTML+="<td id='serialtitle' style='text-align: center;width:120px;'>統一編號</td>";
				var tmp = document.getElementById("batchvcca_close");
				tmp.parentNode.insertBefore(tr,tmp);
				while (tr_row>0){
					var tr = document.createElement("tr");
					tr.className = "batchbuyer";
					tr.id = "batchvcca_"+rowslength;
					tr.innerHTML = "<td id='nos"+rowslength+"' style='text-align: center;'>"+(rowslength+1)+"</td>";
					tr.innerHTML += "<td id='buyerno"+rowslength+"'><input id='textBuyerno_"+rowslength+"' type='text' class='txt c2' value='' /></td>";
					tr.innerHTML+= "<td id='buyer"+rowslength+"'><input id='textBuyer_"+rowslength+"' type='text' class='txt c2' value='' /></td>";
					tr.innerHTML+="<td id='serial"+rowslength+"'><input id='textSerial_"+rowslength+"' type='text' class='txt c2' value='' /></td>";
					var tmp = document.getElementById("batchvcca_close");
					tmp.parentNode.insertBefore(tr,tmp);
					rowslength++;
					tr_row--;
				}
				
				var SeekF= new Array();
				$("#table_batchvcca input[type='text']").each(function() {
					if($(this).attr('disabled')!='disabled')
						SeekF.push($(this).attr('id'));
				});
				
				SeekF.push('btnOk_div_batchvcca');
				
				$("#table_batchvcca input[type='text']").each(function() {
					$(this).unbind('keydown');
					$(this).keydown(function(event) {
						if( event.which == 13) {
							$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).focus();
							$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).select();
						}
					});
				});
				
			}
			
			var batch_orde=false;
			function q_funcPost(t_func, result) {
				switch(t_func) {
					case 'qtxt.query.getvccano':
						var as = _q_appendData("tmp0", "", true, true);
						if (as[0] != undefined) {
							if(as[0].err.length>0){
								alert(as[0].err);
							}else{
								if(as[0].vccano.length>0){
									$('#txtNoa').val(as[0].vccano);
									btnOk();
								}else{
									alert('無可使用的發票號碼!!');
								}
							}
						}else{
							alert('無可使用的發票號碼!!');
						}
						break;
					case 'qtxt.query.vcca_rb':
						var as = _q_appendData("tmp0", "", true, true);
						if (as[0] != undefined) {
							if(as[0].err=='vccaok'){
								alert('訂單批次產生發票已產生完畢!!');
								var s2=[];
								s2[0]=q_name + '_s';
								s2[1]="where=^^ 1=1 ^^"
								q_boxClose2(s2);
							}else
								alert(as[0].err+'!!');
						}else{
							alert('訂單批次產生錯誤!!');
						}
						
						$('#btnOk_div_batchvcca').removeAttr('disabled').val('批次開立');
						$('#div_batchvcca').hide();
						break;
					case 'qtxt.query.orde_change':
						break;
				}
			}

			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case 'ordes':
						if (q_cur > 0 && q_cur < 4) {
							b_ret = getb_ret();
							if (!b_ret || b_ret.length == 0)
								break;
							ret = q_gridAddRow(bbsHtm, 'tbbs', 'txtProductno,txtProduct,txtUnit,txtMount,txtPrice,txtMoney,txtMemo'
							, b_ret.length, b_ret, 'productno,product,unit,mount,price,money,memo', 'txtProductno,txtProduct');
							sum();
						}
						break;
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
			}

			function q_gtPost(t_name) {
				switch (t_name) {
					case 'orde_money':
						var as = _q_appendData("view_orde", "", true);
						if (as[0] != undefined) {
							ordemoney=dec(as[0].total);
							t_where = "where=^^ trdno='"+$('#txtTrdno').val()+"' and noa!='"+$('#txtNoa').val()+"' ^^";
							q_gt('vcca', t_where, 0, 0, 0, "vcca_money", r_accy);
						}else{
							alert('無該訂單!!');
						}
						break;
					case 'vcca_money':
						var as = _q_appendData("vcca", "", true);
						vccamoney=0;
						if (as[0] != undefined) {
							for(var i=0;i<as.length;i++){
								vccamoney+=dec(as[i].total);
							}
						}
						if(ordemoney>=vccamoney+dec($('#txtTotal').val())){
							ordemoney_check=true;
							btnOk();
						}else{
							alert('本張發票金額:'+$('#txtTotal').val()+'\訂單已開發票金額:'+vccamoney+'\n訂單可開發票金額:'+ordemoney+'\n--------------------------\n發票超出金額:'+(vccamoney+dec($('#txtTotal').val())-ordemoney));
						}
						break;
					case 'orde_vcca_rb':
						var as = _q_appendData("view_orde", "", true);
						for(var i=0;i<q_bbsCount;i++){
                        	$('#btnMinus_'+i).click();
                        }
						q_gridAddRow(bbsHtm, 'tbbs', 'txtProductno,txtProduct,txtUnit,txtMount,txtPrice,txtMoney'
							, as.length, as, 'productno,product,unit,emount,price,etotal', '');
							sum();
						break;
					case 'orde_vcca_rb2':
						var as = _q_appendData("view_orde", "", true);
						for(var i=0;i<q_bbsCount;i++){
                        	$('#btnMinus_'+i).click();
                        }
						q_gridAddRow(bbsHtm, 'tbbs', 'txtOrdeno,txtNo2,txtProductno,txtProduct,txtUnit,txtMount,txtPrice,txtMoney'
							, as.length, as, 'noa,no2,productno,product,unit,emount,price,etotal', '');
							sum();
						break;
						break;
					case 'view_ordes':
						var as = _q_appendData("view_ordes", "", true);
						q_gridAddRow(bbsHtm, 'tbbs', 'txtProductno,txtProduct,txtUnit,txtMount,txtPrice,txtMoney,txtMemo'
							, as.length, as, 'productno,product,unit,mount,price,money,memo', 'txtProductno,txtProduct');
							sum();
						break;
					case 'view_orde':
						var as = _q_appendData("view_orde", "", true);
						if (as[0] != undefined) {
							if(as[0].kind=='隨貨多張'){
								batch_orde=true;
								//並檢查是否已開立發票
								q_gt('vcca', "where=^^ charindex('"+$('#textOrdeno').val()+"',trdno)>0 ^^", 0, 0, 0, "orde_vcca", r_accy);
							}else{
								alert('訂單非隨貨多張!!');
							}
						}else{
							alert('訂單不存在!!');
						}
						break;
					case 'orde_vcca':
						var as = _q_appendData("vcca", "", true);
						if (as[0] != undefined) {
							batch_orde=false;
							alert('訂單已開立過發票!!');
						}else{
							$('#btnOk_div_batchvcca').click();
						}
						break;
					case 'getAcomp':
						var as = _q_appendData("acomp", "", true);
						if (as[0] != undefined) {
							$('#txtCno').val(as[0].noa);
							$('#txtAcomp').val(as[0].nick);
						}
						Unlock(1);
						break;
					case 'vccar':
						var as = _q_appendData("vccar", "", true);
						if (as[0] == undefined) {
							alert("請檢查發票號碼主檔設定，或發票已輸入。");
							Unlock(1);
						} else {
							wrServer($('#txtNoa').val());
							return;
						}
						break;
					case 'vcca_rep':
						var as = _q_appendData("vcca", "", true);
						if (as[0] != undefined) {
							alert("【"+$('#textOrdeno').val()+"】訂單編號已開過發票【"+as[0].noa+"】!!!");
							$('#textOrdeno').val('');
							$('#textTotal').val('');
						}
						break;
					case 'getorde':
						var as = _q_appendData("view_orde", "", true);
						if (as[0] != undefined) {
							$('#txtCustno').val(as[0].custno);
							$('#txtComp').val(as[0].comp);
							$('#txtSerial').val(as[0].coin);
							if(as[0].taxtype=='3')
								as[0].taxtype='1'
							$('#cmbTaxtype').val(as[0].taxtype);
							var t_where=" noa='"+as[0].custno+"' ";
							q_gt('cust', "where=^^ "+t_where+" ^^", 0, 0, 0, "ordecust",'');
							sum();
						}
						break;
					case 'ordecust':
						var as = _q_appendData("cust", "", true);
						if (as[0] != undefined) {
							$('#txtZip').val(as[0].zip_invo);
							$('#txtAddress').val(as[0].addr_invo);
						}
						break;
					case q_name:
						if (q_cur == 4)// 查詢
							q_Seek_gtPost();
						break;
				}
			}

			function q_stPost() {
				if (!(q_cur == 1 || q_cur == 2))
					return false;
				abbm[q_recno]['accno'] = xmlString.split(";")[0];
				abbm[q_recno]['chkno'] = xmlString.split(";")[1];
				$('#txtAccno').val(xmlString.split(";")[0]);
				$('#txtChkno').val(xmlString.split(";")[1]);
				Unlock(1);
				
				if(q_cur==2 && !emp($('#txtNoa').val()) && $('#cmbTaxtype').val()=='6' && !emp($('#txtTrdno').val()) )
					q_func('qtxt.query.orde_change','vcca.txt,changeorde_rb,'+encodeURI($('#txtNoa').val()));
			}
			
			var ordemoney_check=false,ordemoney=0,vccamoney=0;
			function btnOk() {
				Lock(1, {
					opacity : 0
				});
				
				if ($('#txtCno').val().length == 0 ) {
					alert(q_getMsg('lblAcomp') + '禁止空白。');
					Unlock(1);
					return;
				}
				
				if ($('#txtDatea').val().length == 0 || !q_cd($('#txtDatea').val())) {
					alert(q_getMsg('lblDatea') + '錯誤。');
					Unlock(1);
					return;
				}
				
				if ($('#cmbTaxtype').val()=='3' ) {
					alert(q_getMsg('lblTaxtype') + '禁止內含。');
					Unlock(1);
					return;
				}
				
				if($('#txtNoa').val().length==0){
					var t_cno=$('#txtCno').val();
					var t_datea=$('#txtDatea').val();
					if(t_cno.length>0 && t_datea.length>0){
						q_func('qtxt.query.getvccano','vcca.txt,getvccano_rb,'+encodeURI(t_cno)+ ';' + encodeURI(t_datea));
						return;
					}
				}
				
				$('#txtNoa').val($.trim($('#txtNoa').val()));
				
				if ($('#txtNoa').val().length > 0 && !(/^[a-z,A-Z]{2}[0-9]{8}$/g).test($('#txtNoa').val())) {
					alert(q_getMsg('lblNoa') + '錯誤。');
					Unlock(1);
					return;
				}
				
				if ($.trim($('#txtMon').val()).length == 0)
					$('#txtMon').val($('#txtDatea').val().substring(0, 6));
					
				$('#txtMon').val($.trim($('#txtMon').val()));
				if (!(/^[0-9]{3}\/(?:0?[1-9]|1[0-2])$/g).test($('#txtMon').val())) {
					alert(q_getMsg('lblMon') + '錯誤。');
					Unlock(1);
					return;
				}
				
				//1124 因自動產生發票不會變動金額，故存檔檢查單價*數量=金額
				var t_err='';
				for (var j = 0; j < q_bbsCount; j++) {
					var t_mount=dec($('#txtMount_'+j).val()),t_price=dec($('#txtPrice_'+j).val()),t_total=dec($('#txtMoney_'+j).val());
					if(round(q_mul(t_mount,t_price),0)!=t_total && Math.abs(q_sub(round(q_mul(t_mount,t_price),0),t_total))>5 ){
						t_err=t_err+(t_err.length>0?'\n':'')+($('#txtProduct_'+j).val()+" 單價*數量 不等於 發票金額");
					}
				}
				if(t_err.length>0){
					alert(t_err);
					Unlock(1);
					return;
				}
				
				//檢查發票金額是否超出訂單金額
				if($('#txtTrdno').val().length>0 && !ordemoney_check){
					t_where = "where=^^ noa='"+$('#txtTrdno').val()+"' ^^";
					q_gt('view_orde', t_where, 0, 0, 0, "orde_money", r_accy);
					Unlock(1);
					return;
				}
				ordemoney_check=false;
				
				$('#txtWorker').val(r_name);
				
				sum();
				
				var t_where = '';
				if (q_cur == 1) {
					t_where = "where=^^ cno='" + $('#txtCno').val() + "' and ('" + $('#txtDatea').val() + "' between bdate and edate) " + " and exists(select noa from vccars where vccars.noa=vccar.noa and ('" + $('#txtNoa').val() + "' between binvono and einvono))" + " and not exists(select noa from vcca where noa='" + $('#txtNoa').val() + "') ^^";
				} else {
					t_where = "where=^^ cno='" + $('#txtCno').val() + "' and ('" + $('#txtDatea').val() + "' between bdate and edate) " + " and exists(select noa from vccars where vccars.noa=vccar.noa and ('" + $('#txtNoa').val() + "' between binvono and einvono)) ^^";
				}
				q_gt('vccar', t_where, 0, 0, 0, "", r_accy);
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)// 1-3
					return;
				q_box('vcca_rb_s.aspx', q_name + '_s', "500px", "480px", q_getMsg("popSeek"));
			}

			function bbsAssign() {/// 表身運算式
				for (var j = 0; j < q_bbsCount; j++) {
					$('#lblNo_' + j).text(j + 1);
					if (!$('#btnMinus_' + j).hasClass('isAssign')) {
						$('#txtMount_' + j).change(function() {
							sum();
						});
						$('#txtPrice_' + j).change(function() {
							sum();
						});
						$('#txtMoney_' + j).change(function() {
							sum();
						});
					}
				}
				_bbsAssign();
			}
			function bbtAssign() {
                for (var i = 0; i < q_bbtCount; i++) {
                    $('#lblNo__' + i).text(i + 1);
                    if (!$('#btnMinut__' + i).hasClass('isAssign')) {
                    	$('#txtVccno__'+i).bind('contextmenu',function(e) {
	                    	/*滑鼠右鍵*/
	                    	e.preventDefault();
	                    	var n = $(this).attr('id').replace('txtVccno__','');
	                    	var t_accy = $('#txtVccaccy__'+n).val();
	                    	var t_tablea = 'vccst';
	                    	if(t_tablea.length>0 && $(this).val().indexOf('TAX')==-1 && !($(this).val().indexOf('-')>-1 && $(this).val().indexOf('/')>-1)){//稅額和月結排除
	                    		//t_tablea = t_tablea + q_getPara('sys.project');
	                    		//q_box(t_tablea+".aspx?;;;noa='" + $(this).val() + "'", t_tablea, "95%", "95%", q_getMsg("pop"+t_tablea));	
	                    		q_box(t_tablea+".aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa='" + $(this).val() + "';" + t_accy, t_tablea, "95%", "95%", q_getMsg("pop"+t_tablea));
	                    	}
	                    });
                    }
                }
                _bbtAssign();
            }

			function btnIns() {
				_btnIns();
				$('#txtChkno').val('');
				$('#txtMon').val('');
				$('#txtDatea').val(q_date());
				$('#txtDatea').focus();
				$('#cmbTaxtype').val('1');
				$('#txtType').val('M'); //M手動開立 //A批次開立//E發票開立//(空白NULL)出貨單自動產生發票
				Lock(1, {
					opacity : 0
				});
				q_gt('acomp', '', 0, 0, 0, 'getAcomp', r_accy);
			}

			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				
				_btnModi();
				$('#txtDatea').focus();
				$('#txtNoa').attr('readonly', true).css('color', 'green').css('background-color', 'rgb(237,237,237)');
				//讓發票號碼不可修改
				sum();
			}

			function btnPrint() {
				q_box('z_vccp_rb.aspx' + "?;;;noa='" + trim($('#txtVccno').val()) + "' and invo='" + trim($('#txtNoa').val())  + "' and ordeno='" + trim($('#txtNoa').val())+"';" + r_accy, '', "95%", "95%", q_getMsg("popPrint"));
			}

			function wrServer(key_value) {
				var i;

				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}

			function bbsSave(as) {/// 表身 寫入資料庫前，寫入需要欄位
				if (!as['productno'] && !as['product']) {//不存檔條件
					as[bbsKey[1]] = '';
					/// no2 為空，不存檔
					return;
				}
				q_nowf();
				return true;
			}
			function bbtSave(as) {/// 表身 寫入資料庫前，寫入需要欄位
				if (!as['vccno']) {//不存檔條件
					as[bbsKey[1]] = '';
					return;
				}
				q_nowf();
				return true;
			}
			
			//1041103轉來發票不計算金額
			function sum() {
				if (!(q_cur == 1 || q_cur == 2) || ($('#txtType').val()=='E' && $('#cmbTaxtype').val()!='6') )
					return;
					
				$('#txtTax').css('color', 'green').css('background', 'RGB(237,237,237)').attr('readonly', 'readonly');
				var t_mounts, t_prices, t_moneys, t_mount = 0, t_money = 0, t_taxrate, t_tax, t_total;

				for (var k = 0; k < q_bbsCount; k++) {
					t_mounts = q_float('txtMount_' + k);
					t_prices = q_float('txtPrice_' + k);
					t_moneys = round(t_mounts * t_prices, 0);
					$('#txtMoney_' + k).val(t_moneys);
					t_money += t_moneys;
					t_mount += t_mounts;
				}
				
				//銷貨客戶
				$('#txtCustno').attr('readonly', false);
				$('#txtComp').attr('readonly', false);
				//統一編號
				$('#txtSerial').attr('readonly', false);
				//產品金額
				$('#txtMoney').attr('readonly', false);
				//帳款月份
				$('#txtMon').attr('readonly', false);
				//營業稅
				$('#txtTax').attr('readonly', false);
				//總計
				$('#txtTotal').attr('readonly', false);
				//買受人
				$('#txtBuyerno').attr('readonly', false);
				$('#txtBuyer').attr('readonly', false);
				
				for (var k = 0; k < q_bbsCount; k++) {
					$('#txtMount_'+k).attr('readonly', false);
					$('#txtMoney_'+k).attr('readonly', false);
				}

				t_taxrate = parseFloat(q_getPara('sys.taxrate')) / 100;
				switch ($('#cmbTaxtype').val()) {
					case '1':
						// 應稅
						if($('#chkAtax').prop('checked')){
							t_tax=round(q_float('txtTax'), 0);
							$('#txtTax').css('color', 'black').css('background', 'white').removeAttr('readonly');  
						}else if(t_money<=10)
							t_tax = 0;
						else 
							t_tax = round(t_money * t_taxrate, 0);
						t_total = t_money + t_tax;
						break;
					case '2':
						//零稅率
						t_tax = 0;
						t_total = t_money + t_tax;
						break;
					case '3':
						// 內含
						t_tax = round(t_money / (1 + t_taxrate) * t_taxrate, 0);
						t_total = t_money;
						t_money = t_total - t_tax;
						break;
					case '4':
						// 免稅
						t_tax = 0;
						t_total = t_money + t_tax;
						break;
					case '5':
						// 自定
						$('#txtTax').css('color', 'black').css('background', 'white').removeAttr('readonly');  
						t_tax = round(q_float('txtTax'), 0);
						t_total = t_money + t_tax;
						break;
					case '6':
						// 作廢-清空資料
						t_money = 0, t_tax = 0, t_total = 0;
						//銷貨客戶
						$('#txtCustno').val('').attr('readonly', true);
						$('#txtComp').val('').attr('readonly', true);
						//統一編號
						$('#txtSerial').val('').attr('readonly', true);
						//產品金額
						$('#txtMoney').val(0).attr('readonly', true);
						//帳款月份
						$('#txtMon').val('').attr('readonly', true);
						//營業稅
						$('#txtTax').val(0).attr('readonly', true);
						//總計
						$('#txtTotal').val(0).attr('readonly', true);
						//買受人
						$('#txtBuyerno').val('').attr('readonly', true);
						$('#txtBuyer').val('').attr('readonly', true);
						for (var k = 0; k < q_bbsCount; k++) {
							$('#txtMount_'+k).val(0).attr('readonly', true);
							$('#txtMoney_'+k).val(0).attr('readonly', true);
						}
						break;
					default:
				}
				$('#txtMoney').val(t_money);
				$('#txtTax').val(t_tax);
				$('#txtTotal').val(t_total);
			}

			function refresh(recno) {
				_refresh(recno);
				t_count = 0
				try{
					for(var i=0;i<q_bbtCount;i++)
						if($('#txtVccno__'+i).val().length>0)
							t_count ++;
				}catch(e){
					
				}
				
				if(t_count>0)
					$("#dbbt").show();
				else
					$("#dbbt").hide();
					
				$('#div_batchvcca').hide();
			}
			
			var orderbopen = true;
			function readonly(t_para, empty) {
				_readonly(t_para, empty);
				//08/19 開放給他們改
				/*if (!emp($('#txtVccno').val()) || !emp($('#txtTrdno').val())){
					$('#txtNoa').attr('disabled','disabled');
					$('#cmbTaxtype').attr('disabled','disabled');
					$('#btnPlus').attr('disabled','disabled');
					$('#txtTrdno').attr('disabled','disabled');
					
					for (var i = 0; i < q_bbsCount; i++) {
						$('#btnMinus_'+i).attr('disabled','disabled');
						$('#txtProductno_'+i).attr('disabled','disabled');
						$('#btnProductno_'+i).attr('disabled','disabled');
						$('#txtProduct_'+i).attr('disabled','disabled');
						$('#txtUnit_'+i).attr('disabled','disabled');
						$('#txtMount_'+i).attr('disabled','disabled');
						$('#txtPrice_'+i).attr('disabled','disabled');
						$('#txtMoney_'+i).attr('disabled','disabled');
						$('#txtMemo_'+i).attr('disabled','disabled');
					}
				}*/
				
				if(t_para){
					//$('#btnOrdes').removeAttr('disabled');
					$('#btnBatchvcca').removeAttr('disabled');
				}else{
					//$('#btnOrdes').attr('disabled','disabled');
					$('#btnBatchvcca').attr('disabled','disabled');
				}
				$('#div_batchvcca').hide();
				
				if (orderbopen && t_para && window.parent.q_name == 'orde') {
					var wParent = window.parent.document;
					if(wParent.getElementById("cmbKind").value=='隨貨多張' && wParent.getElementById("txtOrdbno").value=='' )
						btnIns();
					orderbopen = false;
				}
			}

			function btnMinus(id) {
				_btnMinus(id);
				sum();
			}

			function btnPlus(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);
			}

			function q_appendData(t_Table) {
				return _q_appendData(t_Table);
			}

			function btnSeek() {
				_btnSeek();
			}

			function btnTop() {
				_btnTop();
			}

			function btnPrev() {
				_btnPrev();
			}

			function btnPrevPage() {
				_btnPrevPage();
			}

			function btnNext() {
				_btnNext();
			}

			function btnNextPage() {
				_btnNextPage();
			}

			function btnBott() {
				_btnBott();
			}

			function q_brwAssign(s1) {
				_q_brwAssign(s1);
			}

			function btnDele() {
				_btnDele();
			}

			function btnCancel() {
				_btnCancel();
			}
			
			function q_popPost(s1) {
				switch (s1) {
					case 'textOrdeno':
						if(!emp($('#textOrdeno').val())){
							t_where = "where=^^ trdno='" + $('#textOrdeno').val() + "' ^^";
							q_gt('vcca', t_where, 0, 0, 0, "vcca_rep", r_accy);
						}
						break;
				}
			}
			function checkId(str) {
				if ((/^[a-z,A-Z][0-9]{9}$/g).test(str)) {//身分證字號
					var key = 'ABCDEFGHJKLMNPQRSTUVXYWZIO';
					var s = (key.indexOf(str.substring(0, 1)) + 10) + str.substring(1, 10);
					var n = parseInt(s.substring(0, 1)) * 1 + parseInt(s.substring(1, 2)) * 9 + parseInt(s.substring(2, 3)) * 8 + parseInt(s.substring(3, 4)) * 7 + parseInt(s.substring(4, 5)) * 6 + parseInt(s.substring(5, 6)) * 5 + parseInt(s.substring(6, 7)) * 4 + parseInt(s.substring(7, 8)) * 3 + parseInt(s.substring(8, 9)) * 2 + parseInt(s.substring(9, 10)) * 1 + parseInt(s.substring(10, 11)) * 1;
					if ((n % 10) == 0)
						return 1;
				} else if ((/^[0-9]{8}$/g).test(str)) {//統一編號
					var key = '12121241';
					var n = 0;
					var m = 0;
					for (var i = 0; i < 8; i++) {
						n = parseInt(str.substring(i, i + 1)) * parseInt(key.substring(i, i + 1));
						m += Math.floor(n / 10) + n % 10;
					}
					if ((m % 10) == 0 || ((str.substring(6, 7) == '7' ? m + 1 : m) % 10) == 0)
						return 2;
				} else if ((/^[0-9]{4}\/[0-9]{2}\/[0-9]{2}$/g).test(str)) {//西元年
					var regex = new RegExp("^(?:(?:([0-9]{4}(-|\/)(?:(?:0?[1,3-9]|1[0-2])(-|\/)(?:29|30)|((?:0?[13578]|1[02])(-|\/)31)))|([0-9]{4}(-|\/)(?:0?[1-9]|1[0-2])(-|\/)(?:0?[1-9]|1\\d|2[0-8]))|(((?:(\\d\\d(?:0[48]|[2468][048]|[13579][26]))|(?:0[48]00|[2468][048]00|[13579][26]00))(-|\/)0?2(-|\/)29))))$");
					if (regex.test(str))
						return 3;
				} else if ((/^[0-9]{3}\/[0-9]{2}\/[0-9]{2}$/g).test(str)) {//民國年
					str = (parseInt(str.substring(0, 3)) + 1911) + str.substring(3);
					var regex = new RegExp("^(?:(?:([0-9]{4}(-|\/)(?:(?:0?[1,3-9]|1[0-2])(-|\/)(?:29|30)|((?:0?[13578]|1[02])(-|\/)31)))|([0-9]{4}(-|\/)(?:0?[1-9]|1[0-2])(-|\/)(?:0?[1-9]|1\\d|2[0-8]))|(((?:(\\d\\d(?:0[48]|[2468][048]|[13579][26]))|(?:0[48]00|[2468][048]00|[13579][26]00))(-|\/)0?2(-|\/)29))))$");
					if (regex.test(str))
						return 4;
				}
				return 0;
				//錯誤
			}
		</script>
		<style type="text/css">
            #dmain {
                overflow: visible;
            }
            .dview {
                float: left;
                width: 1000px;
                border-width: 0px;
            }
            .tview {
                border: 5px solid gray;
                font-size: medium;
                background-color: black;
            }
            .tview tr {
                height: 100%;
            }
            .tview td {
                padding: 2px;
                text-align: center;
                border-width: 0px;
                background-color: #FFFF66;
                color: blue;
            }
            .dbbm {
                float: left;
                width: 100%;
                /*margin: -1px;
                 border: 1px black solid;*/
                border-radius: 5px;
            }
            .tbbm {
                padding: 0px;
                border: 1px white double;
                border-spacing: 0;
                border-collapse: collapse;
                font-size: medium;
                color: blue;
                background: #cad3ff;
                width: 100%;
            }
            .tbbm tr {
                height: 35px;
            }
            .tbbm tr td {
                width: 16%;
            }
            .tbbm .tdZ {
                width: 1%;
            }
            .tbbm tr td span {
                float: right;
                display: block;
                width: 5px;
                height: 10px;
            }
            .tbbm tr td .lbl {
                float: right;
                color: blue;
                font-size: medium;
            }
            .tbbm tr td .lbl.btn {
                color: #4297D7;
                font-weight: bolder;
                font-size: medium;
            }
            .tbbm tr td .lbl.btn:hover {
                color: #FF8F19;
            }
            .txt.c1 {
                width: 100%;
                float: left;
            }
            .txt.c2 {
                width: 98%;
                float: left;
            }
            .txt.c3 {
                width: 96%;
                float: left;
            }
            .txt.num {
                text-align: right;
            }
            .tbbm td {
                margin: 0 -1px;
                padding: 0;
            }
            .tbbm td input[type="text"] {
                border-width: 1px;
                padding: 0px;
                margin: -1px;
                float: left;
            }
            input[type="text"], input[type="button"],select {
                font-size: medium;
            }
            .dbbs {
                width: 1260px;
            }
            .dbbs .tbbs {
                margin: 0;
                padding: 2px;
                border: 2px lightgrey double;
                border-spacing: 1;
                border-collapse: collapse;
                font-size: medium;
                color: blue;
                /*background: #cad3ff;*/
                background: lightgrey;
                width: 100%;
            }
            .dbbs .tbbs tr {
                height: 35px;
            }
            .dbbs .tbbs tr td {
                text-align: center;
                border: 2px lightgrey double;
            }
            .dbbs .tbbs select {
                border-width: 1px;
                padding: 0px;
                margin: -1px;
                font-size: medium;
            }
            #dbbt {
                width: 1200px;
            }
            #tbbt {
                margin: 0;
                padding: 2px;
                border: 2px pink double;
                border-spacing: 1;
                border-collapse: collapse;
                font-size: medium;
                color: blue;
                background: pink;
                width: 100%;
            }
            #tbbt tr {
                height: 35px;
            }
            #tbbt tr td {
                text-align: center;
                border: 2px pink double;
            }

		</style>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	>
		<!--#include file="../inc/toolbar.inc"-->
		<div id="div_batchvcca" style="position:absolute; top:300px; left:400px; display:none; width:450px; background-color: #CDFFCE; border: 5px solid gray;">
			<table id="table_batchvcca" style="width:100%;" border="1" cellpadding='2'  cellspacing='0'>
				<tr style="height: 0px;  display: none;">
					<td style="width:40px;background-color: #f8d463;"> </td>
					<td style="width:100px;background-color: #f8d463;"> </td>
					<td style="width:180px;background-color: #f8d463;"> </td>
					<td style="width:120px;background-color: #f8d463;"> </td>
				</tr>
				<tr>
					<td style="background-color: #f8d463;" colspan="2" align="center">訂單號碼</td>
					<td style="background-color: #f8d463;" colspan="2"><input id="textOrdeno" type="text" class="txt c2"> </td>
				</tr>
				<tr>
					<td style="background-color: #f8d463;" colspan="2" align="center">訂單金額</td>
					<td style="background-color: #f8d463;" colspan="2"><input id="textTotal" type="text" class="txt num c2" disabled="disabled"> </td>
				</tr>
				<tr>
					<td style="background-color: #f8d463;" colspan="2" align="center">分開金額</td>
					<td style="background-color: #f8d463;" colspan="2"><input id="textMoney" type="text" class="txt num c2"> </td>
				</tr>
				<tr style="display: none;">
					<td style="background-color: #f8d463;" colspan="2" align="center">買受人</td>
					<td style="background-color: #f8d463;"><input id="textBuyerno" type="text" class="txt c3"> </td>
					<td style="background-color: #f8d463;"><input id="textBuyer" type="text" class="txt c3"> </td>
				</tr>
				<tr style="display: none;">
					<td style="background-color: #f8d463;" colspan="2" align="center">統一編號</td>
					<td style="background-color: #f8d463;" colspan="2"><input id="textSerial" type="text" class="txt c2"> </td>
				</tr>
				<tr>
					<td style="background-color: #f8d463;" colspan="2" align="center">發票起始號</td>
					<td style="background-color: #f8d463;" colspan="2"><input id="textVccano" type="text" class="txt c2"> </td>
				</tr>
				<tr id='batchvcca_close'>
					<td align="center" colspan='4'>
						<input id="btnOk_div_batchvcca" type="button" value="批次開立">
						<input id="btnClose_div_batchvcca" type="button" value="關閉視窗">
					</td>
				</tr>
			</table>
		</div>
		<div id="dmain">
			<div class="dview" id="dview">
				<table class="tview" id="tview">
					<tr>
						<td align="center" style="width:20px; color:black;"><a id='vewChk'> </a></td>
						<td align="center" style="width:120px; color:black;"><a id='vewNoa'> </a></td>
						<td align="center" style="width:80px; color:black;"><a id='vewDatea'> </a></td>
						<td align="center" style="width:80px; color:black;"><a id='vewBuyer'> </a></td>
						<td align="center" style="width:80px; color:black;"><a id='vewMoney'> </a></td>
						<td align="center" style="width:80px; color:black;"><a id='vewTax'> </a></td>
						<td align="center" style="width:80px; color:black;"><a id='vewTotal'> </a></td>
						<td align="center" style="width:200px; color:black;"><a id='vewMemo'> </a></td>
					</tr>
					<tr>
						<td>
						<input id="chkBrow.*" type="checkbox" style=' '/>
						</td>
						<td id='noa' style="text-align: center;">~noa</td>
						<td id='datea' style="text-align: center;">~datea</td>
						<td id='buyer,4' style="text-align: left;">~buyer,4</td>
						<td id='money,0,1' style="text-align: right;">~money,0,1</td>
						<td id='tax,0,1' style="text-align: right;">~tax,0,1</td>
						<td id='total,0,1' style="text-align: right;">~total,0,1</td>
						<td id='memo' style="text-align: left;">~memo</td>
					</tr>
				</table>
			</div>
			<div class="dbbm">
				<table class="tbbm"  id="tbbm">
					<tr style="height:1px;">
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td class="tdZ"> </td>
					</tr>
					<tr>
						<td><span> </span><a id='lblDatea' class="lbl"> </a></td>
						<td><input id="txtDatea"  type="text"  class="txt c1"/></td>
						<td><span> </span><a id="lblAcomp" class="lbl btn"> </a></td>
						<td colspan="3">
							<input id="txtCno" type="text" style="float:left; width:25%;">
							<input id="txtAcomp" type="text" style="float:left; width:75%;"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id='lblNoa' class="lbl"> </a></td>
						<td><input id="txtNoa"  type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblMon' class="lbl"> </a></td>
						<td><input id="txtMon"  type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblChkno' class="lbl"> </a></td>
						<td><input id="txtChkno"  type="text" class="txt c1" /></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblCust" class="lbl btn"> </a></td>
						<td colspan="3">
							<input id="txtCustno" type="text" style="float:left; width:30%;">
							<input id="txtComp" type="text" style="float:left; width:70%;"/>
							<input id="txtNick" type="text"  style="display:none;"/>
						</td>
						<td><span> </span><a id='lblSerial' class="lbl"> </a></td>
						<td><input id="txtSerial" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblAddress' class="lbl"> </a></td>
						<td colspan="5">
							<input id="txtZip" type="text" style="float:left; width:10%;"/>
							<input id="txtAddress" type="text" style="float:left; width:90%;"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id='lblTaxtype' class="lbl"> </a></td>
						<td><select id="cmbTaxtype" class="txt c1" > </select></td>
						<td><span> </span><a id='lblBuyer' class="lbl btn"> </a></td>
						<td colspan="3">
							<input id="txtBuyerno"  type="text"  style="float:left; width:30%;"/>
							<input id="txtBuyer" type="text"  style="float:left; width:70%;"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id='lblMoney' class="lbl"> </a></td>
						<td><input id="txtMoney"  type="text"  class="txt num c1"/></td>
						<td><span> </span><a id='lblTax' class="lbl"> </a></td>
						<td>
							<input id="txtTax"  type="text"  class="txt num c1" style="width: 70%;"/>
							<input id="chkAtax" type="checkbox" onchange='sum()' />
						</td>
						<td><span> </span><a id='lblTotal' class="lbl"> </a></td>
						<td><input id="txtTotal"  type="text"  class="txt num c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMemo" class="lbl" > </a></td>
						<td colspan='5'><input id="txtMemo"  type="text"  class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblWorker' class="lbl"> </a></td>
						<td><input id="txtWorker"  type="text"  class="txt c1"/></td>
						<td><span> </span><a id='lblVccno' class="lbl btn"> </a></td>
						<td><input id="txtVccno"  type="text" class="txt c1"/></td>
						<td colspan="2">
							<input id="btnOrdesMon"  type="button" value="月結匯入"/>
							<input id="btnVcc_rb"  type="button" value="出貨匯入"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id='lblAccno' class="lbl btn"> </a></td>
						<td><input id="txtAccno"  type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblTrdno' class="lbl btn"> </a></td>
						<td><input id="txtTrdno"  type="text" class="txt c1"/></td>
						<td colspan="2">
							<input id="btnOrdes"  type="button" value="訂單匯入"/>
							<input id="btnBatchvcca"  type="button" value="訂單批次產生發票"/>
							<input id="txtType"  type="hidden" class="txt c1"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class='dbbs'>
			<table id="tbbs" class='tbbs' style=' text-align:center'>
				<tr style='color:white; background:#003366;' >
					<td  align="center" style="width:40px;">
						<input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"  />
					</td>
					<td align="center" style="width:30px;"> </td>
					<td align="center" style="width:140px;"><a id='lblProductno'> </a></td>
					<td align="center" style="width:350px;"><a id='lblProduct'> </a></td>
					<td align="center" style="width:50px;"><a id='lblUnit'> </a></td>
					<td align="center" style="width:110px;"><a id='lblMount'> </a></td>
					<td align="center" style="width:110px;"><a id='lblPrice'> </a></td>
					<td align="center" style="width:130px;"><a id='lblTotals'> </a></td>
					<td align="center" style="width:300px;"><a id='lblMemos'> </a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td align="center">
						<input class="btn"  id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" />
						<input id="txtNoq.*" type="text" style="display: none;" />
					</td>
					<td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td>
						<input id="txtProductno.*" type="text" style="float:left;width: 80%;"/>
						<input id="btnProductno.*" type="button" value="." style="float:left;width: 15%;"/>
					</td>
					<td><input id="txtProduct.*" type="text" style="float:left;width: 95%;"/></td>
					<td><input id="txtUnit.*" type="text" style="float:left;width: 95%;"/></td>
					<td><input id="txtMount.*" type="text" style="float:left;width: 95%; text-align: right;"/></td>
					<td><input id="txtPrice.*" type="text" style="float:left;width: 95%; text-align: right;"/></td>
					<td><input id="txtMoney.*" type="text" style="float:left;width: 95%; text-align: right;"/></td>
					<td><input id="txtMemo.*" type="text" style="float:left;width: 95%;"/>
						<input id="txtOrdeno.*" type="text" style="float:left;width: 70%;"/>
						<input id="txtNo2.*" type="text" style="float:left;width: 25%;"/>
					</td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
		<div id="dbbt" style="display:none;">
			<table id="tbbt">
				<tbody>
					<tr class="head" style="color:white; background:#003366;">
						<td style="width:20px;">
						<input id="btnPlut" type="button" style="font-size: medium; font-weight: bold;" value="＋"/>
						</td>
						<td style="width:20px;"> </td>
						<td style="width:120px; text-align: center;">出貨單號</td>
						<td style="width:200px; text-align: center;">品名</td>
						<td style="width:100px; text-align: center;">數量</td>
						<td style="width:100px; text-align: center;">重量</td>
						<td style="width:100px; text-align: center;">單價</td>
						<td style="width:100px; text-align: center;">金額</td>
					</tr>
					<tr>
						<td>
							<input id="btnMinut..*"  type="button" style="font-size: medium; font-weight: bold;" value="－"/>
							<input class="txt" id="txtNoq..*" type="text" style="display: none;"/>
						</td>
						<td><a id="lblNo..*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
						<td>
							<input class="txt" id="txtVccaccy..*" type="text" style="width:95%;display:none;"/>
							<input class="txt" id="txtVccno..*" type="text" style="width:75%;float:left;"/>
							<input class="txt" id="txtVccnoq..*" type="text" style="width:15%;float:left;"/>
						</td>
						<td>
							<input class="txt" id="txtProduct..*" type="text" style="width:95%;float:left;"/>
						</td>
						<td><input class="txt" id="txtMount..*" type="text" style="width:95%;text-align: right;"/></td>
						<td><input class="txt" id="txtWeight..*" type="text" style="width:95%;text-align: right;"/></td>
						<td><input class="txt" id="txtPrice..*" type="text" style="width:95%;text-align: right;"/></td>
						<td><input class="txt" id="txtMoney..*" type="text" style="width:95%;text-align: right;"/></td>
					</tr>
				</tbody>
			</table>
		</div>
	</body>
</html>