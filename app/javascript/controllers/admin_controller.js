import { Controller } from "@hotwired/stimulus"

// 1️⃣ Importa jQuery globalmente
import jQuery from "jquery"
window.$ = window.jQuery = jQuery

// 2️⃣ Importa librerías globales
import toastr from "toastr"
import * as bootstrap from "bootstrap"
window.bootstrap = bootstrap

export default class extends Controller {
    connect() {
        // ======================================================
        // 🔹 OverlayScrollbars INIT (solo una vez)
        // ======================================================
        const SELECTOR_SIDEBAR_WRAPPER = ".sidebar-wrapper"
        const sidebarWrapper = document.querySelector(SELECTOR_SIDEBAR_WRAPPER)

        if (sidebarWrapper && window.OverlayScrollbarsGlobal?.OverlayScrollbars) {
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
}
