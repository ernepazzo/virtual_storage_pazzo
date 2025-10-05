import "@hotwired/turbo-rails"
import "./controllers"
// import * as bootstrap from "bootstrap"

// jQuery (requerido por muchas librerías)
import jQuery from "jquery";
window.$ = window.jQuery = jQuery;

// Bootstrap 5 (requiere Popper)
import * as bootstrap from "bootstrap";
window.bootstrap = bootstrap;
import "bootstrap-table/dist/bootstrap-table.min.js"
import "bootstrap-table/dist/locale/bootstrap-table-es-ES.min.js" // idioma opcional
import "bootstrap/dist/css/bootstrap.min.css"
import "bootstrap-table/dist/bootstrap-table.min.css"

import bootbox from "bootbox"
window.bootbox = bootbox
import toastr from "toastr"
window.toastr = toastr;

// Carga AdminLTE
// import "admin-lte/dist/js/adminlte.min.js"
// import "./admin/adminlte.min.js"
// import "./admin/adminlte.min.css"

import 'admin-lte/dist/css/adminlte.min.css';
import 'admin-lte/dist/js/adminlte.min.js';

// Opcional: reiniciar plugins de AdminLTE tras navegación Turbo
document.addEventListener("turbo:load", () => {
    // AdminLTE ya se autoinicializa, pero si necesitas algo personalizado, aquí va.
})

// i18n-js (para traducciones en JS)
import { I18n } from "i18n-js";
window.I18n = I18n;