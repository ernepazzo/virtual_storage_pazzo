import {Controller} from "@hotwired/stimulus"

// 1️⃣ Importa jQuery globalmente
import jQuery from "jquery"
window.$ = window.jQuery = jQuery

// 2️⃣ Importa librerías globales
import toastr from "toastr"
import * as bootstrap from "bootstrap"
window.bootstrap = bootstrap

// OverlayScrollbars JS
import {OverlayScrollbars} from 'overlayscrollbars';

let obtenerIdCheckDatatable = () => {
    let array = []
    let input = $('#table').find('input[type="checkbox"]');
    input.map(elem => {
        let check = $(input[elem]);
        if (check.is(':checked')) {
            if (check.val() !== 'on') {
                array.push(check.val());
            }
        }

    })
    return array;
}


export default class extends Controller {
    connect() {
        // ======================================================
        // 🔹 OverlayScrollbars INIT (solo una vez)
        // ======================================================
        const SELECTOR_SIDEBAR_WRAPPER = ".sidebar-wrapper"
        const sidebarWrapper = document.querySelector(SELECTOR_SIDEBAR_WRAPPER)

        /*if (sidebarWrapper && window.OverlayScrollbarsGlobal?.OverlayScrollbars) {
            // evita reinicializar si ya está activo
            if (!sidebarWrapper.dataset.scrollInit) {
                this.scrollbar = OverlayScrollbarsGlobal.OverlayScrollbars(sidebarWrapper, {
                    scrollbars: {
                        theme: "os-theme-light",
                        autoHide: "leave",
                        clickScroll: true,
                    },
                })
                sidebarWrapper.dataset.scrollInit = "true"
                console.log("✅ OverlayScrollbars inicializado")
            }
        }*/
        if (sidebarWrapper && OverlayScrollbars) {
            // evita reinicializar si ya está activo
            if (!sidebarWrapper.dataset.scrollInit) {
                this.scrollbar = OverlayScrollbars(sidebarWrapper, {
                    scrollbars: {
                        theme: "os-theme-light",
                        autoHide: "leave",
                        clickScroll: true,
                    },
                })
                sidebarWrapper.dataset.scrollInit = "true"
                console.log("✅ OverlayScrollbars inicializado")
            }
        }

        // Destruir antes del cache para no duplicar en Turbo
        document.addEventListener("turbo:before-cache", () => this.destroyScroll())

        // ======================================================
        // 🔹 Inicialización de tooltips y toasts
        // ======================================================
        this.initTooltips()
        this.initToasts()

        // ======================================================
        // 🔹 Color Mode Toggler
        // ======================================================
        this.initColorMode()
    }

    // ======================================================
    // 🔧 Destruir scrollbar si existe
    // ======================================================
    destroyScroll() {
        const sidebarWrapper = document.querySelector(".sidebar-wrapper")
        if (this.scrollbar && this.scrollbar.destroy) {
            this.scrollbar.destroy()
            this.scrollbar = null
            if (sidebarWrapper) sidebarWrapper.dataset.scrollInit = ""
            console.log("💨 OverlayScrollbars destruido antes del cache")
        }
    }

    // ======================================================
    // 🎯 Inicialización de Tooltips
    // ======================================================
    initTooltips() {
        const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
        tooltipTriggerList.forEach((tooltipTriggerEl) => {
            new bootstrap.Tooltip(tooltipTriggerEl)
        })
    }

    // ======================================================
    // 🍞 Inicialización de Toasts
    // ======================================================
    initToasts() {
        const toastTriggerList = document.querySelectorAll('[data-bs-toggle="toast"]')
        toastTriggerList.forEach((btn) => {
            btn.addEventListener("click", (event) => {
                event.preventDefault()
                const toastEle = document.getElementById(btn.getAttribute("data-bs-target"))
                const toastBootstrap = bootstrap.Toast.getOrCreateInstance(toastEle)
                toastBootstrap.show()
            })
        })
    }

    // ======================================================
    // 🌙 Color Mode Toggler
    // ======================================================
    initColorMode() {
        "use strict"

        const storedTheme = localStorage.getItem("theme")
        const getPreferredTheme = () =>
            storedTheme ||
            (window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light")

        const setTheme = (theme) => {
            if (theme === "auto" && window.matchMedia("(prefers-color-scheme: dark)").matches) {
                document.documentElement.setAttribute("data-bs-theme", "dark")
            } else {
                document.documentElement.setAttribute("data-bs-theme", theme)
            }
        }

        const showActiveTheme = (theme, focus = false) => {
            const themeSwitcher = document.querySelector("#bd-theme")
            if (!themeSwitcher) return

            const themeSwitcherText = document.querySelector("#bd-theme-text")
            const activeThemeIcon = document.querySelector(".theme-icon-active i")
            const btnToActive = document.querySelector(`[data-bs-theme-value="${theme}"]`)
            const svgOfActiveBtn = btnToActive.querySelector("i").getAttribute("class")

            document.querySelectorAll("[data-bs-theme-value]").forEach((el) => {
                el.classList.remove("active")
                el.setAttribute("aria-pressed", "false")
            })

            btnToActive.classList.add("active")
            btnToActive.setAttribute("aria-pressed", "true")
            activeThemeIcon.setAttribute("class", svgOfActiveBtn)

            const themeSwitcherLabel = `${themeSwitcherText.textContent} (${btnToActive.dataset.bsThemeValue})`
            themeSwitcher.setAttribute("aria-label", themeSwitcherLabel)
            if (focus) themeSwitcher.focus()
        }

        // Inicializa el tema actual
        setTheme(getPreferredTheme())
        showActiveTheme(getPreferredTheme())

        // Listeners
        window.matchMedia("(prefers-color-scheme: dark)").addEventListener("change", () => {
            if (storedTheme !== "light" && storedTheme !== "dark") {
                setTheme(getPreferredTheme())
            }
        })

        document.querySelectorAll("[data-bs-theme-value]").forEach((toggle) => {
            toggle.addEventListener("click", () => {
                const theme = toggle.getAttribute("data-bs-theme-value")
                localStorage.setItem("theme", theme)
                setTheme(theme)
                showActiveTheme(theme, true)
            })
        })
    }

    delete(e) {
        bootbox.confirm({
            title: 'Eliminar',
            message: "¿Seguro que desea eliminar este elemento?",
            buttons: {
                confirm: {
                    label: '<i class="bi bi-check-lg"></i> Aceptar',
                    className: 'btn-success'
                },
                cancel: {
                    label: '<i class="bi bi-x-lg"></i> Cancelar',
                    className: 'btn-secondary'
                }
            },
            size: 'md',
            callback: function (result) {
                if (result) {
                    $.ajax({
                        url: e.target.dataset.target,
                        data: {
                            format: 'json'
                        },
                        type: 'GET',
                        success: function (data) {
                            if (data.success) {
                                toastr.success(data.msg);
                                $('#table').bootstrapTable('refresh');
                            } else {
                                toastr.error(data.msg);
                            }
                        }
                    })
                }
            }
        })
    }

    blockDelete() {
        let ids = obtenerIdCheckDatatable();

        let count_id = ids.length;

        console.info('mi info!!!!');
        console.log(ids);
        console.log(count_id);

        if (count_id === 0) {
            toastr.info('Debe seleccionar al menos un elemento de la tabla para eliminar', 'Información importante');
        }

        if (count_id > 0) {
            bootbox.confirm({
                title: 'Eliminar',
                message: `¿Seguro que desea eliminar estos ${count_id} elemento(s)?`,
                buttons: {
                    confirm: {
                        label: '<i class="bi bi-check-lg"></i> Aceptar',
                        className: 'btn-success'
                    },
                    cancel: {
                        label: '<i class="bi bi-x-lg"></i> Cancelar',
                        className: 'btn-secondary'
                    }
                },
                size: 'md',
                callback: function (result) {
                    if (result) {
                        $.ajax({
                            url: `${location.href.split('?')[0]}/delete`,
                            data: {
                                format: 'json',
                                ids: ids
                            },
                            headers: {
                                'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                            },
                            type: 'POST',
                            success: function (data) {
                                if (data.success) {
                                    toastr.success(data.msg);
                                    $('#table').bootstrapTable('refresh');
                                } else {
                                    toastr.error(data.msg);
                                }
                            }
                        })
                    }
                }
            })
        }
    }
}
