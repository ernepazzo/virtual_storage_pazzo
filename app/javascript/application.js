// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
// import * as bootstrap from "bootstrap"



// jQuery (requerido por muchas librerías)
import jQuery from "jquery";
window.$ = window.jQuery = jQuery;

// Bootstrap 5 (requiere Popper)
import * as bootstrap from "bootstrap";
window.bootstrap = bootstrap;

// Toastr (notificaciones)
import "toastr";
import "toastr/build/toastr.min";
import toastr from "toastr"
window.toastr = toastr;

// Bootstrap Table
import "bootstrap-table";
import "bootstrap-table/dist/bootstrap-table.min";
// Opcional: locale en español
// import "bootstrap-table/dist/locale/bootstrap-table-es-ES.min";

// Select2
// import "select2";
// import "select2/dist/css/select2.min";
// import "select2-bootstrap-theme/dist/select2-bootstrap.min";

// Highcharts
// import Highcharts from "highcharts";
// window.Highcharts = Highcharts;

// Bootbox (alertas modernas)
// import "bootbox";
// window.bootbox = bootbox;

// i18n-js (para traducciones en JS)
import { I18n } from "i18n-js";
window.I18n = I18n;

// Si usas Turbolinks o Turbo (Rails 7 usa Turbo por defecto)
import { Turbo } from "@hotwired/turbo-rails";
window.Turbo = Turbo;