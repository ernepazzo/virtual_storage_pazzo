import { Controller } from "@hotwired/stimulus"

// 2. Importa jQuery y hazlo global (¡obligatorio para plugins!)
import jQuery from "jquery"
window.$ = window.jQuery = jQuery

// 3. Importa librerías
import bootbox from "bootbox"
import toastr from "toastr"

// 4. Importa extensiones de Bootstrap Table
import "bootstrap-table/dist/bootstrap-table.min"
import "bootstrap-table/dist/extensions/custom-view/bootstrap-table-custom-view"
import "bootstrap-table/dist/extensions/toolbar/bootstrap-table-toolbar"
import "bootstrap-slider"

// 5. Importa locales
import "bootstrap-table/dist/locale/bootstrap-table-es-ES.min.js"

export default class extends Controller {
    connect() {
        toastr.options = {
            "closeButton": false,
            "debug": false,
            "newestOnTop": false,
            "progressBar": true,
            "positionClass": "toast-bottom-right",
            "preventDuplicates": false,
            "onclick": null,
            "showDuration": "300",
            "hideDuration": "1000",
            "timeOut": "3000",
            "extendedTimeOut": "1000",
            "showEasing": "swing",
            "hideEasing": "linear",
            "showMethod": "fadeIn",
            "hideMethod": "fadeOut"
        }

        let table = $('#table');
        // let admin_table = $('#admin_table');
        // let table_page = $('#table_page');

        if (table.data('bootstrap.table')) {
            table.bootstrapTable('destroy');
        }

        table.bootstrapTable({
            language: 'es-Es',
            pagination: true,
            search: true,
            refresh: true,
            sidePagination: "server",
            showRefresh: true,
            pageSize: 10,
            pageList: [10, 25, 50, 100, 200, 'All'],
            toolbar: '#toolbar',
            toolbarAlign: "left",
            idField: "id",
            showFullscreen: true,
            showColumns: true,
            showToggle: true,
            selectItemName: "id",
            onLoadSuccess: function (data) {
                table.bootstrapTable('uncheckAll');
            }
        });

        function iconFormatter(value, row, index) {
            return value; // value ya contiene el HTML del ícono
        }
        window.iconFormatter = iconFormatter;


        /*admin_table.bootstrapTable({
            language: 'es',
            pagination: true,
            search: false,
            refresh: true,
            sidePagination: "server",
            showRefresh: "true",
            pageSize: 5,
            pageList: "[5, 25, 50, 100, 200, All]",
            toolbar: '#toolbar',
            toolbarAlign: "left",
            idField: "id",
            selectItemName: "id",
            onLoadSuccess: function (data) {
                table.bootstrapTable('checkInvert');
            }
        });

        $("#range-start-time").slider({
            // tooltip: 'always',
            focus: true
        });
        $("#range-price").slider({
            // tooltip: 'always',
            focus: true
        });
        $("#range-duration").slider({
            // tooltip: 'always',
            focus: true
        });
        $("#range-adults").slider({
            // tooltip: 'always',
            focus: true
        });
        $("#range-childrens").slider({
            // tooltip: 'always',
            focus: true
        });
        $("#range-pax").slider({
            // tooltip: 'always',
            focus: true
        });

        table_page.bootstrapTable({
            language: 'es',
            pagination: true,
            search: true,
            refresh: true,
            sidePagination: "server",
            showRefresh: "true",
            advancedSearch: "true",
            pageSize: 6,
            pageList: "[6, 12, 18, 24, All]",
            toolbar: '#toolbar',
            toolbarAlign: "left",
            idField: "id",
            selectItemName: "id",
            customViewDefault: "true",
            showCustomView: "true",
            showCustomViewButton: "true",
        });
        $('#checkBtn').on('change', function () {
            $('.inputBtnDataTable').prop('checked', $(this).is(':checked'));
        })

        window.customViewFormatter = data => {
            const template = $('#profileTemplatePage').html()
            let view = ''

            $.each(data, function (i, row) {
                view += template.replace('%ID_GM%', row.id)
                    .replace('%IMG_CAT%', row.img_cat_card)
                    .replace('%PROD_NAME%', row.prod_name)
                    .replace('%PROD_NAME2%', row.prod_name)
                    .replace('%MOD_NAME%', row.mod_name)
                    .replace('%DEST_NAME%', row.dest_name)
                    .replace('%ADULT%', row.adult)
                    .replace('%CHILDREN%', row.children)
                    .replace('%MOD_DESC%', row.mod_desc)
                    .replace('%PAX%', row.pax)
                    .replace('%FROM_PRICE%', row.from_price)
                    .replace('%DETAILS%', row.details)
            })

            return `<div class="row mx-0">${view}</div>`
        }

        table_page.bootstrapTable('toggleCustomView');*/
    }

    delete(e) {
        bootbox.confirm({
            title: "Eliminar",
            message: "¿Seguro que desea eliminar este elemento?",
            buttons: {
                confirm: {
                    label: '<i class="fa fa-check"></i> Aceptar',
                    className: 'btn-success'
                },
                cancel: {
                    label: '<i class="fa fa-times"></i> Cancelar',
                    className: 'btn-secondary'
                }
            },
            size: 'small',
            callback: function (result) {
                if (result) {
                    $.ajax({
                        url: e.target.dataset.target + '/delete',
                        data: {},
                        type: 'GET',
                        success: function (data) {
                            if (data.success) {
                                toastr.success(data.msg);
                                $('#table').bootstrapTable('refresh');
                            } else {
                                toastr.error(data.msg);
                                console.log(data.msg);
                            }
                        }
                    })
                }
            }
        })
    }

    checkUncheckAll(e) {
        $('.inputBtnDataTable').prop('checked', $(e.target).is(':checked'));
    }

    /* Para Hotetec */
    delete_booking(e) {
        bootbox.confirm({
            title: "Cancelar",
            message: "¿Seguro que desea cancelar esta reserva?",
            buttons: {
                confirm: {
                    label: '<i class="fa fa-check"></i> Aceptar',
                    className: 'btn-success'
                },
                cancel: {
                    label: '<i class="fa fa-times"></i> Cancelar',
                    className: 'btn-secondary'
                }
            },
            size: 'small',
            callback: function (result) {
                if (result) {
                    $.ajax({
                        url: e.target.dataset.target,
                        data: {},
                        type: 'GET',
                        success: function (data) {
                            if (data.success) {
                                toastr.success(data.msg);
                                $('#table').bootstrapTable('refresh');
                                if (data.redirect_url) {
                                    window.location.href = `${data.redirect_url}?redirect=true`;
                                }
                            } else {
                                toastr.error(data.msg);
                                console.log(data.msg);
                                if (data.redirect_url) {
                                    window.location.href = data.redirect_url;
                                }
                            }
                        }
                    })
                }
            }
        })
    }
    /* Para Hotetec FIN */

    block(e) {
        bootbox.confirm({
            message: "¿Seguro que desea bloquear el acceso y la renta a este usuario?",
            buttons: {
                confirm: {
                    label: '<i class="fa fa-check"></i> Aceptar',
                    className: 'btn-success'
                },
                cancel: {
                    label: '<i class="fa fa-times"></i> Cancelar',
                    className: 'btn-secondary'
                }
            },
            size: 'small',
            callback: function (result) {
                if (result) {
                    $.ajax({
                        url: e.target.dataset.target + '/block',
                        data: {},
                        type: 'GET',
                        success: function (data) {
                            if (data.success) {
                                toastr.success(data.msg);
                                $('#table').bootstrapTable('refresh');
                            } else {
                                toastr.error(data.msg);
                                console.log(data.msg);
                            }
                        }
                    })
                }
            }
        })
    }

    change_status(e) {
        bootbox.confirm({
            message: "¿Seguro que desea cambiar el estado de disponibilidad?",
            buttons: {
                confirm: {
                    label: '<i class="fa fa-check"></i> Aceptar',
                    className: 'btn-success'
                },
                cancel: {
                    label: '<i class="fa fa-times"></i> Cancelar',
                    className: 'btn-secondary'
                }
            },
            size: 'small',
            callback: function (result) {
                if (result) {
                    $.ajax({
                        url: e.target.dataset.target,
                        data: {},
                        type: 'GET',
                        success: function (data) {
                            if (data.success) {
                                toastr.success(data.msg);
                                $('#table').bootstrapTable('refresh');
                            } else {
                                toastr.error(data.msg);
                                console.log(data.msg);
                            }
                        }
                    })
                }
            }
        })

    }

    commercial(e) {
        console.log(e);
        bootbox.confirm({
            message: "¿Seguro que desea poner este usuario como Comercial del sitio?",
            buttons: {
                confirm: {
                    label: '<i class="fa fa-check"></i> Aceptar',
                    className: 'btn-success'
                },
                cancel: {
                    label: '<i class="fa fa-times"></i> Cancelar',
                    className: 'btn-secondary'
                }
            },
            size: 'small',
            callback: function (result) {
                if (result) {
                    $.ajax({
                        url: e.target.dataset.target,
                        data: {},
                        type: 'POST',
                        success: function (data) {
                            if (data.success) {
                                toastr.success(data.msg);
                                $('#table').bootstrapTable('refresh');
                            } else {
                                toastr.error(data.msg);
                                console.log(data.msg);
                            }
                        }
                    })
                }
            }
        })
    }

    filterTable(e) {
        $(`#${e.target.dataset.table}`).bootstrapTable('refresh');
    }

    clearFilter(e) {
        let parentElement = $(`#${e.target.dataset.target}`);
        let input = parentElement.find('input[type="text"]');
        let input_hidden = parentElement.find('input[type="hidden"]');
        let select = parentElement.find('select');

        input.map((index, elem) => {
            elem.value = '';
        })
        input_hidden.map((index, elem) => {
            elem.value = '';
        })
        select.map((index, elem) => {
            $(elem).val(null).trigger('change');
        })
    }

    filterTableFilters(e) {
        $(`#${e.target.dataset.table}`).bootstrapTable('refresh');
        $(`#${e.target.dataset.show}`).removeClass('show');
    }

    async clearFilterFilters(e) {
        let parentElement = $(`#${e.target.dataset.target}`);
        let input = parentElement.find('input[type="checkbox"]');
        let select = parentElement.find('select');

        await new Promise((resolve) => {
            input.map((index, elem) => {
                $(elem).prop('checked', false);
            });
            select.map((index, elem) => {
                $(elem).val(null).trigger('change');
            });
            resolve(); // Indicamos que el bloque ha terminado
        });

        $("#range-start-time").slider('refresh', {});
        $("#range-price").slider('refresh', {});
        $("#range-duration").slider('refresh', {});
        $("#range-adults").slider('refresh', {});
        $("#range-childrens").slider('refresh', {});
        $("#range-pax").slider('refresh', {});

        this.filterTableFilters(e);
    }
}