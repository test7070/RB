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
            q_tables = 't';
            var q_name = "cub";
            var q_readonly = ['txtNoa', 'txtComp', 'txtProduct', 'txtStore','txtSpec', 'txtWorker', 'txtWorker2', 'txtVcceno','txtMo'];
            var q_readonlys = ['txtDate2', 'txtOrdeno', 'txtNo2', 'txtW01'];
            var q_readonlyt = [];
            var bbmNum = [['txtTotal', 10, 0, 1]];
            var bbsNum = [];
            var bbtNum = [];
            var bbmMask = [];
            var bbsMask = [];
            var bbtMask = [];
            q_sqlCount = 6;
            brwCount = 6;
            brwList = [];
            brwNowPage = 0;
            brwKey = 'noa';
            q_desc = 1;
            brwCount2 = 5;
            aPop = new Array(
            	['txtOrdeno', '', 'view_ordes', 'noa,no2,productno,product,spec,mount,custno,comp,memo', 'txtOrdeno,txtNo2,txtProductno,txtProduct,txtSpec,txtTotal,txtCustno,txtComp,txtMemo', ''], 
	            ['txtCustno', 'lblCust', 'cust', 'noa,comp', 'txtCustno,txtComp', 'cust_b.aspx'], 
	            ['txtProductno', 'lblProduct', 'ucaucc', 'noa,product,spec', 'txtProductno,txtProduct,txtSpec', 'ucaucc_b.aspx'], 
	            ['txtTggno_', 'btnTggno_', 'tgg', 'noa,comp', 'txtTggno_,txtTgg_', "tgg_b.aspx"], 
	            ['txtProcessno_', 'btnProcessno_', 'process', 'noa,process', 'txtProcessno_,txtProcess_', 'process_b.aspx'], 
	            ['txtProductno_', 'btnProductno_', 'ucc', 'noa,product,unit', 'txtProductno_,txtProduct_,txtUnit_', 'ucc_b.aspx'], 
	            ['txtProductno__', 'btnProductno__', 'ucc', 'noa,product', 'txtProductno__,txtProduct__', 'ucc_b.aspx'],
	            ['txtStoreno', 'lblStore', 'store', 'noa,store', 'txtStoreno,txtStore', 'store_b.aspx']);

            $(document).ready(function() {
                bbmKey = ['noa'];
                bbsKey = ['noa', 'noq'];
                bbtKey = ['noa', 'noq'];
                q_brwCount();
                q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
            });

            function sum() {
                var t_price = 0, t_mount = 0, t_mo = 0,t_total = 0;
                for (var j = 0; j < q_bbsCount; j++) {
                    //t_mount = dec($('#txtMount_' + j).val());
                    //t_price = dec($('#txtPrice_' + j).val());
                    //t_total = q_add(t_total, round(q_mul(t_price, t_mount), 0));           
                    t_total = q_add(t_total, dec($('#txtMo_' + j).val()));                                                               

                    var t_taxrate = q_div(parseFloat(q_getPara('sys.taxrate')), 100);
                    if ($('#chkSale_' + b_seq).is(':checked'))
                        $('#txtW02_' + b_seq).val(round(q_mul($('#txtMo_' + b_seq).val(), t_taxrate), 0));
                        
                    $('#txtW01_' + j).val(round(q_add(dec($('#txtW02_' + j).val()), dec($('#txtMo_' + j).val())), 0));
                }

           		//bbm
                $('#txtMo').val(t_total);
                $('#txtPrice').val(round(q_div(t_total, dec($('#txtTotal').val())), dec(q_getPara('rc2.pricePrecision'))));
                if ($('#txtTotal').val() == 0) {
                    $('#txtPrice').val(0);
                }
            }

            function main() {
                if (dataErr) {
                    dataErr = false;
                    return;
                }
                mainForm(0);
            }

            function currentData() {
            }


            currentData.prototype = {
                data : [],
                exclude : ['txtNoa', 'txtDatea', 'txtOrdeno', 'txtNo2', 'txtWorker', 'txtWorker2'], //bbm
                excludes : [''], //bbs
                excludet : [''], //bbt
                copy : function() {
                    this.data = new Array();
                    for (var i in fbbm) {
                        var isExclude = false;
                        for (var j in this.exclude) {
                            if (fbbm[i] == this.exclude[j]) {
                                isExclude = true;
                                break;
                            }
                        }
                        if (!isExclude) {
                            this.data.push({
                                field : fbbm[i],
                                value : $('#' + fbbm[i]).val()
                            });
                        }
                    }
                    //bbs
                    for (var i in fbbs) {
                        for (var j = 0; j < q_bbsCount; j++) {
                            var isExcludes = false;
                            for (var k in this.excludes) {
                                if (fbbs[i] == this.excludes[k]) {
                                    isExcludes = true;
                                    break;
                                }
                            }
                            if (!isExcludes) {
                                this.data.push({
                                    field : fbbs[i] + '_' + j,
                                    value : $('#' + fbbs[i] + '_' + j).val()
                                });
                            }
                        }
                    }
                    //bbt
                    for (var i in fbbt) {
                        for (var j = 0; j < q_bbtCount; j++) {
                            var isExcludet = false;
                            for (var k in this.excludet) {
                                if (fbbt[i] == this.excludet[k]) {
                                    isExcludet = true;
                                    break;
                                }
                            }
                            if (!isExcludet) {
                                this.data.push({
                                    field : fbbt[i] + '__' + j,
                                    value : $('#' + fbbt[i] + '__' + j).val()
                                });
                            }
                        }
                    }
                },
                /*貼上資料*/
                paste : function() {
                    for (var i in this.data) {
                        $('#' + this.data[i].field).val(this.data[i].value);
                    }
                }
            };
            var curData = new currentData();

            function mainPost() {
                q_getFormat();
                bbmMask = [['txtDatea', r_picd], ['txtBdate', r_picd], ['txtEdate', r_picd]];
                bbsMask = [['txtDate2', r_picd], ['txtDatea', r_picd]];
                q_mask(bbmMask);
                bbmNum = [['txtTotal', 15, 0, 1], ['txtPrice', 15, q_getPara('rc2.pricePrecision'), 1], ['txtMo', 15, 0, 1]];
                bbsNum = [['txtMount', 15, q_getPara('rc2.mountPrecision'), 1], ['txtPrice', 15, q_getPara('rc2.pricePrecision'), 1], ['txtMo', 15, 0, 1], ['txtW01', 15, 0, 1], ['txtW02', 15, 0, 1], ['txtGweight', 15, q_getPara('rc2.mountPrecision'), 1]];
                bbtNum = [['txtMount', 15, q_getPara('rc2.mountPrecision'), 1]];

                //$('title').text("連續製令單"); //IE8會有問題
                document.title = '連續製令單'

                $('#btnOrdes').click(function() {
                    var t_custno = trim($('#txtCustno').val());
                    var t_where = '';
                    if (t_custno.length > 0) {
                        t_where = " isnull(enda,0)!=1 and isnull(cancel,0)!=1";
                        t_where += " and custno='" + t_custno + "'";
                        t_where += " and productno in (select noa from uca)  ";
                        if (!emp($('#txtOrdeno').val()))
                            t_where += " and charindex(noa,'" + $('#txtOrdeno').val() + "')>0 ";
                        t_where = t_where;
                    } else {
                        alert('請輸入客戶編號!!');
                        return;
                    }
                });

                $('#txtVcceno').click(function() {
                    var t_inano = $.trim($('#txtVcceno').val());
                    var t_storeno = $.trim($('#txtStoreno').val());
                    if (t_inano.length > 0) {
                        var t_where = "noa='" + t_inano + "'";
                        q_box("ina.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, q_name, "98%", "98%", q_getMsg("popSeek"));
                    }
                });

                $('#txtMo').change(function() {
                    $('#txtPrice').val(round(q_div($dec(('#txtMo').val()), dec($('#txtTotal').val())), dec(q_getPara('rc2.pricePrecision'))));
                });

                $('#btnProcess').click(function() {
                    q_box("process.aspx?", "", "98%", "98%", q_getMsg("popSeek"));
                });

                if ($('#txtTotal').val() == 0) {
                    $('#txtPrice').val(0);
                }

            }

            function sleep(milliseconds) {
                var start = new Date().getTime();
                for (var i = 0; i < 1e7; i++) {
                    if ((new Date().getTime() - start) > milliseconds) {
                        break;
                    }
                }
            }

            function q_gtPost(t_name) {
                switch (t_name) {
                    case 'stpost_rc2_0':
                        var as = _q_appendData("view_rc2", "", true);
                        for (var i = 0; i < as.length; i++) {
                            q_func('rc2_post.post', as[i].accy + ',' + as[i].noa + ',0');
                            sleep(100);
                        }
                        q_gt('view_ina', "where=^^product='" + $('#txtNoa').val() + "'^^", 0, 0, 0, "stpost_ina_0");
                        break;
                    case 'stpost_rc2_1':
                        var as = _q_appendData("view_rc2", "", true);
                        for (var i = 0; i < as.length; i++) {
                            q_func('rc2_post.post', as[i].accy + ',' + as[i].noa + ',1');
                            sleep(100);
                        }
                        q_gt('view_ina', "where=^^product='" + $('#txtNoa').val() + "'^^", 0, 0, 0, "stpost_ina_1");
                        break;
                    case 'stpost_rc2_3':
                        var as = _q_appendData("view_rc2", "", true);
                        for (var i = 0; i < as.length; i++) {
                            q_func('rc2_post.post', as[i].accy + ',' + as[i].noa + ',0');
                            sleep(100);
                        }
                        q_gt('view_ina', "where=^^product='" + $('#txtNoa').val() + "'^^", 0, 0, 0, "stpost_ina_3");
                        break;
                    case 'stpost_ina_0':
                        var as = _q_appendData("view_ina", "", true);
                        for (var i = 0; i < as.length; i++) {
                            q_func('ina_post.post', as[i].accy + ',' + as[i].noa + ',0');
                            sleep(100);
                        }
                        //執行txt
                        q_func('qtxt.query.cubs2rc2_rb_0', 'cub.txt,cubs2rc2_rb,' + encodeURI(r_accy) + ';' + encodeURI($('#txtNoa').val()) + ';0;' + encodeURI(q_getPara('sys.key_rc2')) + ';' + encodeURI(q_getPara('sys.key_ina')) + ';' + encodeURI($('#txtStoreno').val()));
                        break;
                    case 'stpost_ina_1':
                        var as = _q_appendData("view_ina", "", true);
                        for (var i = 0; i < as.length; i++) {
                            q_func('ina_post.post', as[i].accy + ',' + as[i].noa + ',1');
                            sleep(100);
                        }
                        Unlock(1);
                        break;
                    case 'stpost_ina_3':
                        var as = _q_appendData("view_ina", "", true);
                        for (var i = 0; i < as.length; i++) {
                            q_func('ina_post.post', as[i].accy + ',' + as[i].noa + ',0');
                            sleep(100);
                        }
                        //執行txt
                        q_func('qtxt.query.cubs2rc2_rb_3', 'cub.txt,cubs2rc2_rb,' + encodeURI(r_accy) + ';' + encodeURI($('#txtNoa').val()) + ';0;' + encodeURI(q_getPara('sys.key_rc2')) + ';' + encodeURI(q_getPara('sys.key_ina')) + ';' + encodeURI($('#txtStoreno').val()));
                        break;
                    case 'getinano':
                        var as = _q_appendData("view_cub", "", true);
                        if (as[0] != undefined) {
                            $('#txtVcceno').val(as[0].vcceno)
                            abbm[q_recno]['vcceno'] = as[0].vcceno;
                        }
                        break;
                    case 'getrc2no':
                        var as = _q_appendData("view_cubs", "", true);
                        for (var i = 0; i < as.length; i++) {
                            for (var j = 0; j < q_bbsCount; j++) {
                                if (as[i].noq == $('#txtNoq_' + j).val()) {
                                    $('#txtOrdeno_' + j).val(as[i].ordeno);
                                    break;
                                }
                            }
                            for (var j = 0; j < abbs.length; j++) {
                                if (abbs[j]['noa'] == as[i].noa && abbs[j]['noq'] == as[i].noq) {
                                    abbs[j]['ordeno'] = as[i].ordeno;
                                    break;
                                }
                            }

                        }
                        break;
                    case 'pays':
                        var as = _q_appendData("pays", "", true);
                        if (as[0] != undefined) {
                            for (var j = 0; j < q_bbsCount; j++) {
                                if ($('#txtOrdeno_' + j).val() == as[0].rc2no && !emp($("#txtDatea_" + j).val()) && !emp($('#txtOrdeno_' + j).val())) {
                                    $("#btnMinus_" + j).attr('disabled', 'disabled');
                                    $("#txtDatea_" + j).attr('disabled', 'disabled');
                                    $("#txtTggno_" + j).attr('disabled', 'disabled');
                                    $("#btnTggno_" + j).attr('disabled', 'disabled');
                                    $("#txtTgg_" + j).attr('disabled', 'disabled');
                                    $("#txtProcessno_" + j).attr('disabled', 'disabled');
                                    $("#txtProcess_" + j).attr('disabled', 'disabled');
                                    $("#btnProcessno_" + j).attr('disabled', 'disabled');
                                    $("#txtMount_" + j).attr('disabled', 'disabled');
                                    $("#txtPrice_" + j).attr('disabled', 'disabled');
                                    $("#txtMo_" + j).attr('disabled', 'disabled');
                                    $("#chkSale_" + j).attr('disabled', 'disabled');
                                    $("#txtW01_" + j).attr('disabled', 'disabled');
                                    $("#txtMemo_" + j).attr('disabled', 'disabled');
                                    $("#chkCut_" + j).attr('disabled', 'disabled');
                                    //	alert(as[0].rc2no);
                                }
                            }

                        }
                        break;

                    case q_name:
                        if (q_cur == 4)
                            q_Seek_gtPost();
                        break;
                }
            }

            function q_stPost() {
                if (!(q_cur == 1 || q_cur == 2))
                    return false;

                if (!emp($('#txtNoa').val())) {
                    Lock(1, {
                        opacity : 0
                    });
                    q_gt('view_rc2', "where=^^postname='" + $('#txtNoa').val() + "'^^", 0, 0, 0, "stpost_rc2_0");
                }
            }

            function q_funcPost(t_func, result) {
                switch(t_func) {
                    case 'qtxt.query.cubs2rc2_rb_0':
                        q_func('qtxt.query.cubs2rc2_rb_1', 'cub.txt,cubs2rc2_rb,' + encodeURI(r_accy) + ';' + encodeURI($('#txtNoa').val()) + ';1;' + encodeURI(q_getPara('sys.key_rc2')) + ';' + encodeURI(q_getPara('sys.key_ina')) + ';' + encodeURI($('#txtStoreno').val()));
                        break;
                    case 'qtxt.query.cubs2rc2_rb_1':
                        q_gt('view_rc2', "where=^^postname='" + $('#txtNoa').val() + "'^^", 0, 0, 0, "stpost_rc2_1");
                        //回寫到bbs 與 bbm
                        q_gt('view_cub', "where=^^noa='" + $('#txtNoa').val() + "'^^", 0, 0, 0, "getinano");
                        q_gt('view_cubs', "where=^^noa='" + $('#txtNoa').val() + "'^^", 0, 0, 0, "getrc2no");
                        break;
                    case 'qtxt.query.cubs2rc2_rb_3':
                        _btnOk($('#txtNoa').val(), bbmKey[0], ( bbsHtm ? bbsKey[1] : ''), '', 3)
                        break;
                }
            }

            function q_boxClose(s2) {
                var ret;
                switch (b_pop) {
                    /*case 'ordes':
                     if (q_cur > 0 && q_cur < 4) {
                     if (!b_ret || b_ret.length == 0){
                     b_pop = '';
                     return;
                     }else{
                     $('#txtCustno').val(b_ret[0].custno);
                     $('#txtComp').val(b_ret[0].comp);
                     $('#txtOrdeno').val(b_ret[0].noa);
                     $('#txtNo2').val(b_ret[0].no2);
                     $('#txtProductno').val(b_ret[0].productno);
                     $('#txtProduct').val(b_ret[0].product);
                     $('#txtSpec').val(b_ret[0].spec);
                     $('#txtTotal').val(b_ret[0].mount);
                     //$('#txtPrice').val(b_ret[0].price);
                     //$('#txtMo').val(b_ret[0].mo);
                     $('#txtMemo').val(b_ret[0].memo);
                     }
                     }
                     break;
                     case 'bbs_tgg':
                     if (q_cur > 0 && q_cur < 4) {
                     if (!b_ret || b_ret.length == 0){
                     b_pop = '';
                     return;
                     }else{
                     $('#txtTggno_'+b_seq).val(b_ret[0].noa);
                     $('#txtTgg_'+b_seq).val(b_ret[0].comp);
                     }
                     }
                     break;*/
                    case q_name + '_s':
                        q_boxClose2(s2);
                        break;
                }
                b_pop = '';
            }

            function _btnSeek() {
                if (q_cur > 0 && q_cur < 4)
                    return;

                q_box('cub_rb_s.aspx', q_name + '_s', "500px", "400px", q_getMsg("popSeek"));
            }

            function btnIns() {
                if ($('#checkCopy').is(':checked'))
                    curData.copy();
                _btnIns();
                if ($('#checkCopy').is(':checked'))
                    curData.paste();
                $('#txtNoa').val('AUTO');
                $('#txtDatea').val(q_date());
                $('#txtDatea').focus();
                $('#txtStoreno').val('001');
                $('#txtStore').val('台北總倉');
            }

            function btnModi() {

                if (emp($('#txtNoa').val()))
                    return;
                _btnModi();
                for (var i = 0; i < q_bbsCount; i++) {
                    if ($('#chkSale_' + i).is(':checked')) {
                        $('#txtW02_' + i).css('color', 'green').css('background', 'RGB(237,237,237)').attr('readonly', 'readonly');
                    }
                }
                $('#txtDatea').focus();
            }

            function btnPrint() {
                q_box('z_cub_rbp.aspx' + "?;;;noa=" + trim($('#txtNoa').val()) + ";" + r_accy, '', "95%", "95%", q_getMsg("popPrint"));
            }

            function btnOk() {
                if ($('#txtDatea').val().length == 0 || !q_cd($('#txtDatea').val())) {
                    alert(q_getMsg('lblDatea') + '錯誤。');
                    return;
                }

                if (q_cur == 1)
                    $('#txtWorker').val(r_name);
                else
                    $('#txtWorker2').val(r_name);
                sum();

                var t_noa = trim($('#txtNoa').val());
                var t_date = trim($('#txtDatea').val());
                if (t_noa.length == 0 || t_noa == "AUTO")
                    q_gtnoa(q_name, replaceAll(q_getPara('sys.key_cub') + (t_date.length == 0 ? q_date() : t_date), '/', ''));
                else
                    wrServer(t_noa);
            }

            function wrServer(key_value) {
                var i;
                $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
                _btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
            }

            function bbsSave(as) {

                if (!as['Deate'] && !as['tggno'] && !as['Tgg'] && !as['Need'] && !as['productno'] && !as['product'] && !as['Unit'] && !as['Mount'] && !as['price'] && !as['Mo'] && !as['memo']) {
                    as[bbsKey[1]] = '';
                    return;
                }
                q_nowf();
                as['noa'] = abbm2['noa'];
                return true;

            }

            function bbtSave(as) {
                if (!as['productno']) {
                    as[bbtKey[1]] = '';
                    return;
                }
                q_nowf();
                return true;
            }

            function refresh(recno) {

                _refresh(recno);
                //取得類別
                //q_gt('cub_typea', '', 0, 0, 0, "cub_typea");
            }

            function readonly(t_para, empty) {
                _readonly(t_para, empty);
            }

            function btnMinus(id) {
                _btnMinus(id);
            }

            function btnPlus(org_htm, dest_tag, afield) {
                _btnPlus(org_htm, dest_tag, afield);
            }

            function btnPlut(org_htm, dest_tag, afield) {
                _btnPlus(org_htm, dest_tag, afield);
            }

            function bbsAssign() {
            	var t_mount = 0,t_price = 0;
                for (var i = 0; i < q_bbsCount; i++) {
                    $('#lblNo_' + i).text(i + 1);
                    if (!$('#btnMinus_' + i).hasClass('isAssign')) {
                        /*$('#btnTggno_'+i).click(function() {
                         t_IdSeq = -1;  /// 要先給  才能使用 q_bodyId()
                         q_bodyId($(this).attr('id'));
                         b_seq = t_IdSeq;
                         t_where = "noa in (select tggno from processs where noa='"+$('#txtProcessno_'+b_seq).val()+"') or noa='"+$('#txtTggno_'+b_seq).val()+"'";
                         q_box("tgg_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'bbs_tgg', "500px", "680px", "");
                         });*/                        					
                        $('#txtMount_' + i).change(function() {    
                        	t_IdSeq = -1;
                            q_bodyId($(this).attr('id'));
                            b_seq = t_IdSeq;  	
                            if($('#txtMount_' + b_seq).val()>0 && $('#txtPrice_' + b_seq).val()>0){
                            	t_mount = $('#txtMount_' + b_seq).val();
                            	t_price = $('#txtPrice_' + b_seq).val();
                            	$('#txtMo_' + b_seq).val(q_mul(t_mount,t_price));
                            }                    			                	
                        	
                            sum();
                        });
                        $('#txtPrice_' + i).change(function() {
                        	t_IdSeq = -1;
                            q_bodyId($(this).attr('id'));
                            b_seq = t_IdSeq;  	
                            if($('#txtMount_' + b_seq).val()>0 && $('#txtPrice_' + b_seq).val()>0){
                            	t_mount = $('#txtMount_' + b_seq).val();
                            	t_price = $('#txtPrice_' + b_seq).val();
                            	$('#txtMo_' + b_seq).val(q_mul(t_mount,t_price));
                            }   
                            sum();
                        });
                        $('#chkSale_' + i).change(function() {
                            sum();
                        });

                        $('#txtMo_' + i).change(function() {
                            t_IdSeq = -1;
                            q_bodyId($(this).attr('id'));
                            b_seq = t_IdSeq;
                            if (dec($('#txtMount_' + b_seq).val()) > 0)
                                $('#txtPrice_' + b_seq).val(round(q_div(dec($('#txtMo_' + b_seq).val()), dec($('#txtMount_' + b_seq).val())), dec(q_getPara('rc2.pricePrecision'))));
                            sum();
                        });

                        $('#txtOrdeno_' + i).click(function() {
                            t_IdSeq = -1;
                            q_bodyId($(this).attr('id'));
                            b_seq = t_IdSeq;
                            var t_rc2no = $.trim($("#txtOrdeno_" + b_seq).val());
                            if (t_rc2no.length > 0) {
                                var t_where = "noa='" + t_rc2no + "'";
                                q_box("rc2_rb.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, q_name, "98%", "98%", q_getMsg("popSeek"));
                            }
                        });

                        if ($('#chkSale_' + i).is(':checked'))
                            $('#txtW02_' + i).css('color', 'green').css('background', 'RGB(237,237,237)').attr('readonly', 'readonly');
                        $('#chkSale_' + i).change(function() {
                            t_IdSeq = -1;
                            q_bodyId($(this).attr('id'));
                            b_seq = t_IdSeq;
                            if ($('#chkSale_' + b_seq).is(':checked')) {
                                var t_taxrate = q_div(parseFloat(q_getPara('sys.taxrate')), 100);
                                //	$('#txtW02_'+b_seq).val(round(q_mul($('#txtW02_'+j).val(),t_taxrate),0));
                                $('#txtW02_' + b_seq).css('color', 'green').css('background', 'RGB(237,237,237)').attr('readonly', 'readonly');
                                $('#txtW02_' + b_seq).val(round(q_mul(dec($('#txtMo_' + b_seq).val()), t_taxrate), 0));
                            } else
                                $('#txtW02_' + b_seq).css('color', 'black').css('background', 'white').removeAttr('readonly');
                            sum();
                        })
                        $('#txtW02_' + i).change(function() {
                            sum();
                        })
                        //$('#txtOrdeno_' + i).click(function() {
                        //	t_IdSeq = -1;
                        //	q_bodyId($(this).attr('id'));
                        //	b_seq = t_IdSeq;
                        if(!emp(trim($('#txtOrdeno_' + i).val()))){
	                        t_where = "where=^^ rc2no='" + trim($('#txtOrdeno_' + i).val()) + "'^^";
	                        q_gt('pays', t_where, 0, 0, 0, "pays", r_accy);
                        }

                        //});

                    }
                }
                _bbsAssign();
            }

            function bbtAssign() {
                for (var i = 0; i < q_bbtCount; i++) {
                    $('#lblNo__' + i).text(i + 1);
                    if (!$('#btnMinut__' + i).hasClass('isAssign')) {
                    }
                }
                _bbtAssign();
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
                //_btnDele();
                if (emp($('#txtNoa').val()))
                    return;

                if (!confirm(mess_dele))
                    return;
                q_cur = 3;

                q_gt('view_rc2', "where=^^postname='" + $('#txtNoa').val() + "'^^", 0, 0, 0, "stpost_rc2_3");
            }

            function btnCancel() {
                _btnCancel();
            }

            function onPageError(error) {
                alert("An error occurred:\r\n" + error.Message);
            }

            var orde_no2 = '', orde_pno = '', orde_product = '', orde_custno = '', orde_comp = '', orde_pop = true;
            function q_popPost(s1) {
                switch (s1) {
                    /*case 'txtOrdeno':
                     if(orde_pop){
                     orde_no2=$('#txtNo2').val();
                     orde_custno=$('#txtCustno').val();
                     orde_comp=$('#txtComp').val();
                     orde_pno=$('#txtProductno').val();
                     orde_product=$('#txtProduct').val();
                     orde_pop=false;
                     }else{
                     orde_pop=true;
                     $('#txtNo2').val(orde_no2);
                     $('#txtCustno').val(orde_custno);
                     $('#txtComp').val(orde_comp);
                     $('#txtProductno').val(orde_pno);
                     $('#txtProduct').val(orde_product);
                     }

                     break;*/
                }

            }

		</script>
		<style type="text/css">
            #dmain {
                /*overflow: hidden;*/
                width: 1260px;
            }
            .dview {
                float: left;
                width: 375px;
                border-width: 0px;
            }
            .tview {
                border: 5px solid gray;
                font-size: medium;
                background-color: black;
            }
            .tview tr {
                height: 30px;
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
                width: 70%;
                /* margin: -1px;
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
                width: 9%;
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
                color: black;
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
                width: 98%;
                float: left;
            }

            .num {
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
            .tbbm select {
                border-width: 1px;
                padding: 0px;
                margin: -1px;
                font-size: medium;
            }
            input[type="text"], input[type="button"] {
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
                width: 1000px;
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
		<div id='dmain'>
			<div class="dview" id="dview" >
				<table class="tview" id="tview" >
					<tr>
						<td style="width:20px; color:black;"><a id='vewChk'> </a></td>
						<td style="width:15%; color:black;"><a id='vewDatea'> </a></td>
						<td style="width:30%; color:black;"><a id='vewProductno'> </a>製成品代號</td>
						<td style="width:50%; color:black;"><a id='vewProduct'>製成品名稱</a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=''/></td>
						<td id='datea' style="text-align: center;">~datea</td>
						<td id='productno' style="text-align: center;">~productno</td>
						<td id='product' style="text-align: center;">~product</td>
					</tr>
				</table>
			</div>
			<div class='dbbm'>
				<table class="tbbm" id="tbbm">
					<tr style="height:1px;">
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td class="tdZ"> </td>
					</tr>
					<tr>
						<td><span> </span><a id="lblDatea" class="lbl"> </a></td>
						<td><input id="txtDatea" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblNoa" class="lbl"> </a></td>
						<td><input id="txtNoa" type="text" class="txt c1"/></td>
						<td>
							<input id="checkCopy" type="checkbox" style="float:left;"/>
							<span> </span><a id='lblCopy' class="lbl" style="float:left;"> </a>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id="lblProduct" class="lbl btn" >製成品</a></td>
						<td><input id="txtProductno" type="text" class="txt c1"/></td>
						<td colspan="2"><input id="txtProduct" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblStore" class="lbl btn" >倉庫</a></td>
						<td><input id="txtStoreno" type="text" class="txt c1"/></td>
						<td><input id="txtStore" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblSpec" class="lbl" >規格</a></td>
						<td colspan="3"><input id="txtSpec" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblVcc" class="lbl" >入庫單號</a></td>
						<td colspan="3"><input id="txtVcceno" type="text" class="txt c1" style="width:50% ;color:blue";/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMount" class="lbl" >數量</a></td>
						<td><input id="txtTotal" type="text" class="txt num c1"/></td>
						<td><span> </span><a id="lblPrice" class="lbl" >單價</a></td>
						<td><input id="txtPrice" type="text" class="txt num c1"/></td>
						<td><span> </span><a id="lblMoney" class="lbl" >總計</a></td>
						<td><input id="txtMo" type="text" class="txt num c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMemo" class="lbl" > </a></td>
						<td colspan="3"><input id="txtMemo" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblWorker" class="lbl" > </a></td>
						<td><input id="txtWorker" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblWorker2" class="lbl" > </a></td>
						<td><input id="txtWorker2" type="text" class="txt c1"/></td>
						<td><span> </span><input id="btnProcess" type="button" class="btn c1" value="製程主檔"/></td>
					</tr>
				</table>
			</div>
			<div class='dbbs'>
				<table id="tbbs" class='tbbs'>
					<tr style='color:white; background:#003366;' >
						<td style="width:20px;"><input id="btnPlus" type="button" style="font-size: medium; font-weight: bold;" value="＋"/></td>
						<td style="width:20px;"> </td>
						<td style="width:80px;"><a id='lblDatea_s'>帳款日期</a></td>
						<td style="width:80px;"><a id='lblTggno_s'>廠商編號</a></td>
						<td style="width:120px;"><a id='lblTgg_s'>廠商名稱</a></td>
						<td style="width:80px;"><a id='lblProcessno_s'>製程編號</a></td>
						<td style="width:65px;"><a id='lblProcess'>製程</a></td>
						<td style="width:60px;"><a id='lblMount_s'>數量</a></td>
						<td style="width:60px;"><a id='lblPrice_s'>單價</a></td>
						<td style="width:60px;"><a id='lblMoney_s'>金額</a></td>
						<td style="width:50px;"><a id='lblSale_s'>外加稅</a></td>
						<td style="width:60px;"><a id='lblTxa_s'>稅金</a></td>
						<td style="width:60px;"><a id='lblW01_s'>總金額</a></td>
						<td ><a id='lblMemo_s'>備註</a></td>
						<td style="width:150px;"><a id='lblOrdeno_s'>進貨單編號</a></td>
						<td style="width:40px;"><a id='lblPay_s'>請款</a></td>
					</tr>
					<tr style='background:#cad3ff;'>
						<td align="center">
							<input id="btnMinus.*" type="button" style="font-size: medium; font-weight: bold;" value="－"/>
							<input id="txtNoq.*" type="text" style="display: none;"/>
						</td>
						<td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
						<td><input id="txtDatea.*" type="text" class="txt c1"/></td>
						<td>
							<input id="txtTggno.*" type="text" class="txt c1" style="width: 50%;"/>
							<input class="btn"  id="btnTggno.*" type="button" value='.' style=" font-weight: bold;" />
						</td>
						<td><input id="txtTgg.*" type="text" class="txt c1"/></td>
						<td>
							<input id="txtProcessno.*" type="text" class="txt c1" style="width: 50%;"/>
							<input class="btn"  id="btnProcessno.*" type="button" value='.' style=" font-weight: bold;" />
						</td>
						<td><input id="txtProcess.*" type="text" class="txt c1"/></td>
						<td><input id="txtMount.*" type="text" class="txt c1 num"/></td>
						<td><input id="txtPrice.*" type="text" class="txt c1 num"/></td>
						<td><input id="txtMo.*" type="text" class="txt c1 num"/></td>
						<td><input id="chkSale.*" type="checkbox" class="txt c1" /></td>
						<td><input id="txtW02.*" type="text" class="txt c1" style="text-align:right;"/></td>
						<td><input id="txtW01.*" type="text" class="txt c1" style="text-align:right; "/></td>
						<td><input id="txtMemo.*" type="text" class="txt c1" /></td>
						<td><input id="txtOrdeno.*" type="text" class="txt c1 num" style="color:blue;width: 90%;text-align:left;"/></td>
						<td><input id="chkCut.*" type="checkbox" class="txt c1"  style="width: 50%;"/></td>

					</tr>
				</table>
			</div>
		</div>
		<input id="q_sys" type="hidden" />
		<div id="dbbt" class='dbbt' style="display: none;">
			<table id="tbbt" class="tbbt">
				<tr class="head" style="color:white; background:#003366;">
					<td style="width:20px;"><input id="btnPlut" type="button" style="font-size: medium; font-weight: bold;" value="＋"/></td>
					<td style="width:20px;"> </td>
					<td style="width:120px; text-align: center;">原料編號</td>
					<td style="width:180px; text-align: center;">原料名稱</td>
					<td style="width:100px; text-align: center;">數量</td>
					<td style="width:200px; text-align: center;">備註</td>
				</tr>
				<tr>
					<td>
						<input id="btnMinut..*" type="button" style="font-size: medium; font-weight: bold;" value="－"/>
						<input class="txt" id="txtNoq..*" type="text" style="display: none;"/>
					</td>
					<td><a id="lblNo..*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td>
						<input id="txtProductno..*" type="text" class="txt c1" style="width: 85%;"/>
						<input class="btn"  id="btnProductno..*" type="button" value='.' style=" font-weight: bold;" />
					</td>
					<td><input id="txtProduct..*" type="text" class="txt c1"/></td>
					<td><input id="txtMount..*" type="text" class="txt c1 num"/></td>
					<td><input id="txtMemo..*" type="text" class="txt c1"/></td>
				</tr>
			</table>
		</div>
	</body>
</html>

